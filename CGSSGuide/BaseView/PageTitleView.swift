//
//  PageTitleView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

import UIKit
import SnapKit

protocol PageTitleViewDelegate: class {
    func pageTitleView(_ pageTitleView: PageTitleView, didSelectAtIndex index: Int)
}

class PageTitleItemView: UIView {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        addSubview(label)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
/// 用于collectionview的可滚动可点击标题栏的视图
class PageTitleView: UIView {
    
    var titles: [String] = [String]() {
        didSet {
            reloadTitleItemViews()
        }
    }
    
    var currentIndex: Int {
        get {
            return Int(round(floatIndex))
        }
        set {
            floatIndex = CGFloat(newValue)
        }
        
    }
    
    func setCurrentIndex(index: Int, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.currentIndex = index
            })
        } else {
            currentIndex = index
        }
    }
    
    var floatIndex: CGFloat = 0 {
        didSet {
//            print("float index is\(floatIndex)")
            let items = titleStackView.arrangedSubviews as! [PageTitleItemView]
            let leftIndex = Int(floor(floatIndex))
            let rightIndex = Int(ceil(floatIndex))
            let leftItem = items[leftIndex]
            let rightItem = items[rightIndex]
            let currentItem = items[currentIndex]
            
            currentItem.label.textColor = UIColor.black
            
            let offset = floatIndex - floor(floatIndex)
            let left1 = leftItem.frame.minX + leftItem.label.frame.minX
            let left2 = rightItem.frame.minX + rightItem.label.frame.minX
            
            self.sliderView.frame.origin.x = left1 + (left2 - left1) * offset
            self.sliderView.fwidth = leftItem.label.fwidth + (rightItem.label.fwidth - leftItem.label.fwidth) * offset
        }
        willSet {
            let item = titleStackView.arrangedSubviews[currentIndex] as! PageTitleItemView
            item.label.textColor = UIColor.lightGray
        }
    }
    
    var sliderView: UIView!

    var titleStackView: UIStackView!
    
    weak var delegate: PageTitleViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleStackView = UIStackView()
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 0
        addSubview(titleStackView)
        titleStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        sliderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 2))
        sliderView.backgroundColor = UIColor.black
        addSubview(sliderView)
    }
    
    private func removeAllTitleItemViews() {
        for subView in titleStackView.arrangedSubviews {
            titleStackView.removeArrangedSubview(subView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sliderView.frame.origin.y = self.bounds.maxY - 2
    }
    
    private func reloadTitleItemViews() {
        removeAllTitleItemViews()
        for title in titles {
            let view = PageTitleItemView()
            view.label.text = title
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickAction(tap:)))
            view.addGestureRecognizer(tap)
            titleStackView.addArrangedSubview(view)
        }
        layoutIfNeeded()
        setCurrentIndex(index: 0, animated: false)
    }
    
    func clickAction(tap: UITapGestureRecognizer) {
        if let view = tap.view, let index = titleStackView.arrangedSubviews.index(of: view) {
            // setCurrentIndex(index: index, animated: true)
            delegate?.pageTitleView(self, didSelectAtIndex: index)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

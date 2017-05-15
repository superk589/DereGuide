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

class PageTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.lightGray
        font = UIFont.systemFont(ofSize: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
/// 用于collectionview的可滚动可点击标题栏的视图
class PageTitleView: UIView {
    
    struct Space {
        //static let left: CGFloat = 20
        static let top: CGFloat = 2
        static let `internal` :CGFloat = 51
    }
    struct Height {
        static let btn: CGFloat = 28
        static let slider: CGFloat = 1
    }
    
    struct Width {
        static let btn: CGFloat = 50
    }
    
    var titles: [String] = [String]() {
        didSet {
            reloadSubviews()
        }
    }
    
    var leftSpace: CGFloat {
        return (fwidth - Space.internal * CGFloat(titles.count - 1) - Width.btn * CGFloat(titles.count)) / 2
    }
    
    var currentIndex: Int {
        get {
            return Int(round(floatIndex))
        }
        set {
            floatIndex = CGFloat(newValue)
        }
        
    }
    var floatIndex: CGFloat = 0 {
        didSet {
            let leftIndex = Int(floor(floatIndex))
            let rightIndex = Int(ceil(floatIndex))
            let leftLabel = titleLabels[leftIndex]
            let rightLabel = titleLabels[rightIndex]
            let currentLabel = titleLabels[currentIndex]
            
            currentLabel.textColor = UIColor.black
            
            let offset = floatIndex - floor(floatIndex)
            let left1 = leftLabel.frame.minX + leftLabel.frame.minX
            let left2 = rightLabel.frame.minX + rightLabel.frame.minX
            
            self.sliderView.frame.origin.x = left1 + (left2 - left1) * offset
            self.sliderView.fwidth = leftLabel.fwidth + (rightLabel.fwidth - leftLabel.fwidth) * offset
        }
        willSet {
            let label = titleLabels[currentIndex]
            label.textColor = UIColor.lightGray
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
    
    
    var sliderView: UIView!
    
    var titleLabels = [PageTitleLabel]()
    
    weak var delegate: PageTitleViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sliderView = UIView.init(frame: CGRect.init(x: 0, y: fheight / 2 + 12, width: 10, height: 1))
        sliderView.backgroundColor = UIColor.black
        addSubview(sliderView)
    }
    
    func wipeItemBtns() {
        for subView in titleLabels {
            subView.removeFromSuperview()
        }
        titleLabels.removeAll()
    }
    
    func reloadSubviews() {
        wipeItemBtns()
        guard titles.count > 0 else {
            return
        }
        
        for i in 0..<titles.count {
            let width = Screen.width / CGFloat(titles.count)
            let label = PageTitleLabel()
            
            label.text = titles[i]
            addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(CGFloat(i) * width)
                make.top.equalToSuperview().offset(5)
                make.width.equalTo(width)
                make.bottom.equalToSuperview().offset(-5)
            })
            titleLabels.append(label)
            label.tag = 1000 + i
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickAction(tap:)))
            label.addGestureRecognizer(tap)
            
        }
        layoutIfNeeded()
        setCurrentIndex(index: 0, animated: false)
    }
    
    
    func clickAction(tap: UITapGestureRecognizer) {
        if let view = tap.view {
            setCurrentIndex(index: view.tag - 1000, animated: true)
            delegate?.pageTitleView(self, didSelectAtIndex: view.tag - 1000)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

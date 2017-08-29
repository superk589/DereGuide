//
//  FilterTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/1/6.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import TTGTagCollectionView

protocol FilterTableViewCellDelegate: class {
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index:Int)
    func didSelectAll(filterTableViewCell cell: FilterTableViewCell)
    func didDeselectAll(filterTableViewCell cell: FilterTableViewCell)
    func filterTableViewCell(_ cell: FilterTableViewCell, didDeselect index:Int)
}

class FilterTableViewCell: UITableViewCell, TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    var filterView: TTGTagCollectionView!
    weak var delegate: FilterTableViewCellDelegate?
    var tagViews = [FilterItemView]()
    var defaultTagView: FilterItemView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        filterView = TTGTagCollectionView()
        filterView.delegate = self
        filterView.dataSource = self
        contentView.addSubview(filterView)
        filterView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(-15)
        }
        
        defaultTagView = FilterItemView()
        defaultTagView.setTitle(title: NSLocalizedString("全部", comment: ""))
        defaultTagView.iv.zk.backgroundColor = Color.visual
        defaultTagView.isSelected = false
        tagViews.append(defaultTagView)
    }
    
    func setup(titles: [String]) {
        tagViews.removeAll()
        tagViews.append(defaultTagView)
        for title in titles {
            let tagView = FilterItemView()
            tagView.setSelected(selected: false)
            tagView.setTitle(title: title)
            tagViews.append(tagView)
        }
        filterView.reload()
    }
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(tagViews.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        return tagViews[Int(index)]
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {

        let tagView = tagViews[Int(index)]
        tagView.sizeToFit()
        return tagView.frame.size
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, updateContentSize contentSize: CGSize) {
        
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
        let tagView = tagViews[Int(index)]
        if index == 0 {
            tagView.isSelected = true
            delegate?.didSelectAll(filterTableViewCell: self)
            for i in 1..<tagViews.count {
                tagViews[i].isSelected = false
            }
        } else {
            tagView.isSelected = !tagView.isSelected
            if tagView.isSelected {
                if tagViews[0].isSelected {
                    delegate?.didDeselectAll(filterTableViewCell: self)
                    tagViews[0].isSelected = false
                }
                delegate?.filterTableViewCell(self, didSelect: Int(index - 1))
            } else {
                delegate?.filterTableViewCell(self, didDeselect: Int(index - 1))
                var isAllDeselected = true
                for view in tagViews {
                    if view.isSelected {
                        isAllDeselected = false
                    }
                }
                if isAllDeselected {
                    delegate?.didSelectAll(filterTableViewCell: self)
                    tagViews[0].isSelected = true
                }
            }

        }
    }
    
    
    func presetIndex(index: UInt) {
        tagViews[0].isSelected = false
        if tagViews.count >= 1 {
            for i in 0..<tagViews.count - 1 {
                let tagView = tagViews[i + 1]
                tagView.setSelected(selected: (index >> UInt(i)) % 2 == 1)
            }
        }
    }
    
    func presetAll() {
        let tagView = tagViews[0]
        tagView.isSelected = true
        for i in 1..<tagViews.count {
            tagViews[i].isSelected = false
        }
    }
    
    func setup(titles: [String], index: UInt, all: UInt) {
        self.setup(titles: titles)
        if index == all {
            self.presetAll()
        } else {
            self.presetIndex(index: index)
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        layoutIfNeeded()
        filterView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

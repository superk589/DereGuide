//
//  FilterTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/6.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import TTGTagCollectionView

protocol FilterTableViewCellDelegate: class {
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index:Int)
    func filterTableViewCell(_ cell: FilterTableViewCell, didDeselect index:Int)
}

class FilterTableViewCell: UITableViewCell, TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    var filterView: TTGTagCollectionView!
    weak var delegate: FilterTableViewCellDelegate?
    var tagViews = [FilterItemView]()
    
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
    }
    
    func setup(titles: [String]) {
        tagViews.removeAll()
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
        tagView.isSelected = !tagView.isSelected
        if tagView.isSelected {
            delegate?.filterTableViewCell(self, didSelect: Int(index))
        } else {
            delegate?.filterTableViewCell(self, didDeselect: Int(index))
        }
    }
    
    
    func presetIndex(index: UInt) {
        for i in 0..<tagViews.count {
            let tagView = tagViews[i]
            tagView.setSelected(selected: (index >> UInt(i)) % 2 == 1)
        }
    }
    
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        filterView.layoutIfNeeded()
        filterView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

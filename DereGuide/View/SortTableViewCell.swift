//
//  SortTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/1/12.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit
import TTGTagCollectionView

protocol SortTableViewCellDelegate: class {
    func sortTableViewCell(_ cell: SortTableViewCell, didSelect index:Int)
}

class SortTableViewCell: UITableViewCell, TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    let sortView = TTGTagCollectionView()
    var tagViews = [FilterItemView]()
    weak var delegate: SortTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        sortView.delegate = self
        sortView.dataSource = self
        contentView.addSubview(sortView)
        sortView.snp.makeConstraints { (make) in
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
        sortView.reload()
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
        if !tagView.isSelected {
            tagView.isSelected = true
            for i in 0..<tagViews.count {
                if index != UInt(i) {
                    tagViews[i].isSelected = false
                }
            }
            delegate?.sortTableViewCell(self, didSelect: Int(index))
        }
    }
    
    func presetIndex(index: UInt) {
        tagViews[Int(index)].isSelected = true
    }
    
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        sortView.layoutIfNeeded()
        sortView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

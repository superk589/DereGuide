//
//  SortTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/12.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import TTGTagCollectionView

protocol SortTableViewCellDelegate: class {
    func sortTableViewCell(_ cell: SortTableViewCell, didSelect index:Int)
}

class SortTableViewCell: UITableViewCell, TTGTextTagCollectionViewDelegate {
    
    var sortView: TTGTextTagCollectionView!
    weak var delegate: SortTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        sortView = TTGTextTagCollectionView()
        sortView.tagTextFont = UIFont.regular(size: 14)
        sortView.delegate = self
        sortView.delegate = self
        contentView.addSubview(sortView)
        sortView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(-15)
        }
    }
    
    func setup(titles: [String]) {
        sortView.removeAllTags()
        sortView.addTags(titles)
        sortView.tagTextColor = UIColor.darkText
        sortView.tagSelectedTextColor = UIColor.white
        sortView.tagBackgroundColor = UIColor.lightGray
        sortView.tagSelectedBackgroundColor = Color.parade
    }
    
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool) {
        if selected {
            for i in 0..<sortView.allTags().count {
                if index != UInt(i) {
                    sortView.setTagAt(UInt(i), selected: false)
                }
            }
            delegate?.sortTableViewCell(self, didSelect: Int(index))
        } else {
            sortView.setTagAt(index, selected: true)
        }
    }
    
    
    
    func presetIndex(index: UInt) {
        for i in 0..<sortView.allTags().count {
            sortView.setTagAt(UInt(i), selected: index == UInt(i))
        }
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

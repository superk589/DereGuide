//
//  FilterTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/6.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol FilterTableViewCellDelegate: class {
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index:Int)
    func filterTableViewCell(_ cell: FilterTableViewCell, didDeselect index:Int)
}

class FilterTableViewCell: UITableViewCell {
    
    var filterView: FilterView!
    weak var delegate: FilterTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        filterView = FilterView()
        filterView.delegate = self
        contentView.addSubview(filterView)
        filterView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(titles: [String], colors: [UIColor]) {
        filterView.setup(titles: titles, colors: colors)
    }
    
    func presetIndex(index: UInt) {
        filterView.setupPresetIndex(index: index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension FilterTableViewCell: FilterViewDelegate {
    func filterView(_ filterView: FilterView, didDeselect index: Int) {
        delegate?.filterTableViewCell(self, didDeselect: index)
    }
    
    func filterView(_ filterView: FilterView, didSelect index: Int) {
        delegate?.filterTableViewCell(self, didSelect: index)
    }
    
}

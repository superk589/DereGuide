//
//  UnitSimulationModeSelectionCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitSimulationModeSelectionCell: UITableViewCell {
    
    let leftLabel = UILabel()
    
    var rightLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        rightLabel.font = .systemFont(ofSize: 16)
        rightLabel.textColor = .darkGray
        
        contentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(leftLabel)
        }
        selectionStyle = .none

    }
    
    func setup(with title: String, rightDetail: String, rightColor: UIColor) {
        leftLabel.text = title
        rightLabel.text = rightDetail
        rightLabel.textColor = rightColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

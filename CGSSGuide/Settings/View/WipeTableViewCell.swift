//
//  WipeTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/11.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class WipeTableViewCell: UITableViewCell {
    
    var leftLabel: UILabel!
    
    var rightLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel = UILabel()
        contentView.addSubview(leftLabel)
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        rightLabel = UILabel()
        contentView.addSubview(rightLabel)
        rightLabel.font = UIFont.systemFont(ofSize: 16)
        
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(leftLabel.snp.right).offset(5)
        }
        rightLabel.textColor = UIColor.gray
        
        leftLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        leftLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        rightLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

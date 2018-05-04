//
//  WipeTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2016/10/11.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class WipeTableViewCell: UITableViewCell {
    
    let leftLabel = UILabel()
    
    let rightLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftLabel)
        leftLabel.font = .systemFont(ofSize: 16)
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(rightLabel)
        rightLabel.font = .systemFont(ofSize: 16)
        
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(leftLabel.snp.right).offset(5)
        }
        rightLabel.textColor = .gray
        
        leftLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        leftLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  ToolboxTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import SnapKit

class ToolboxTableViewCell: UITableViewCell {
    
    let icon = CGSSCardIconView()
    let descLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        icon.isUserInteractionEnabled = false

        descLabel.font = .systemFont(ofSize: 16)
        descLabel.backgroundColor = .white
        contentView.addSubview(icon)
        contentView.addSubview(descLabel)
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
            make.height.width.equalTo(48)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(10)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

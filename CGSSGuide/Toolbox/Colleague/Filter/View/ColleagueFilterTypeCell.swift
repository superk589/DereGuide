//
//  ColleagueFilterTypeCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ColleagueFilterTypeCell: UITableViewCell {
    
    var icon: UIImageView!
    
    var leftLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        icon = UIImageView()
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(24)
        }
        
        leftLabel = UILabel()
        leftLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        selectionStyle = .none
    }
    
    func setup(_ type: CGSSLiveTypes) {
        icon.image = type.icon
        if type == [] {
            leftLabel.text = NSLocalizedString("不限", comment: "")
        } else {
            leftLabel.text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var customSelected: Bool = false {
        didSet {
            accessoryType = customSelected ? .checkmark : .none
        }
    }

}

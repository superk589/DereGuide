//
//  ColleagueFilterTypeCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/15.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class ColleagueFilterTypeCell: UITableViewCell {
    
    let icon = UIImageView()
    
    let leftLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(24)
        }
        
        leftLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
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

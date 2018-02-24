//
//  DashboardSettingTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 23/02/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class DashboardSettingTableViewCell: UITableViewCell {
    
    let leftLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        selectionStyle = .none
    }
    
    func setup(title: String, isSelected: Bool) {
        leftLabel.text = title
        customSelected = isSelected
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

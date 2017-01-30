//
//  LicenseTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/30.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class LicenseTableViewCell: UITableViewCell {

    var titleLabel: UILabel!
    
    var siteLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
            make.right.lessThanOrEqualTo(-10)
        }
        titleLabel.numberOfLines = 0
        
        siteLabel = UILabel()
        siteLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(siteLabel)
        siteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(titleLabel)
            make.right.lessThanOrEqualTo(-10)
            make.bottom.equalToSuperview().offset(-8)
        }
        siteLabel.textColor = UIColor.darkGray
        
    }
    
    func setup(title: String, site: String) {
        self.titleLabel.text = title
        self.siteLabel.text = site
        if site == "" {
            accessoryType = .none
            siteLabel.snp.updateConstraints({ (update) in
                update.top.equalTo(titleLabel.snp.bottom).offset(0)
            })
        } else {
            accessoryType = .disclosureIndicator
            siteLabel.snp.updateConstraints({ (update) in
                update.top.equalTo(titleLabel.snp.bottom).offset(5)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

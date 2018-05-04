//
//  LicenseTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/1/30.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class LicenseTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    
    let siteLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        titleLabel.numberOfLines = 0
        
        siteLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(siteLabel)
        siteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(titleLabel)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.bottom.equalToSuperview().offset(-8)
        }
        siteLabel.textColor = .darkGray
    }
    
    func setup(title: String, site: String) {
        titleLabel.text = title
        siteLabel.text = site
        if site == "" {
            accessoryType = .none
            siteLabel.snp.updateConstraints { (update) in
                update.top.equalTo(titleLabel.snp.bottom).offset(0)
            }
        } else {
            accessoryType = .disclosureIndicator
            siteLabel.snp.updateConstraints { (update) in
                update.top.equalTo(titleLabel.snp.bottom).offset(5)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

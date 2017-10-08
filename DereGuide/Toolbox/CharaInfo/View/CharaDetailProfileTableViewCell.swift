//
//  CharaDetailProfileTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 08/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CharaDetailProfileTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    let iconView = CGSSCharaIconView()
    let charaProfileView = CharaProfileView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.height.width.equalTo(48)
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.centerY.equalTo(iconView)
            make.right.lessThanOrEqualTo(-10)
        }

        contentView.addSubview(charaProfileView)
        charaProfileView.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(20)
            make.left.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(chara: CGSSChar) {
        nameLabel.text = "\(chara.kanjiSpaced!)  \(chara.conventional!)"
        iconView.charaID = chara.charaId
        charaProfileView.setup(chara)
    }
}

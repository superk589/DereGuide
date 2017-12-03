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
    let romajiLabel = UILabel()
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
        }
        
        romajiLabel.font = UIFont(name: "PingFangSC-Light", size: 13)
        romajiLabel.adjustsFontSizeToFitWidth = true
        romajiLabel.baselineAdjustment = .alignCenters
        addSubview(romajiLabel)
        romajiLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.right.lessThanOrEqualTo(-10)
            make.lastBaseline.equalTo(nameLabel)
        }
        romajiLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        romajiLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        contentView.addSubview(charaProfileView)
        charaProfileView.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(20)
            make.left.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(chara: CGSSChar) {
        if CGSSGlobal.languageType == .en {
            romajiLabel.text = chara.kanjiSpaced
            nameLabel.text = chara.conventional
        } else {
            nameLabel.text = chara.kanjiSpaced
            romajiLabel.text = chara.conventional
        }
        iconView.charaID = chara.charaId
        charaProfileView.setup(chara)
    }
}

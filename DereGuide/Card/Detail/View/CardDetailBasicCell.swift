//
//  CardDetailBasicCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CardDetailBasicCell: UITableViewCell {
    
    let iconView = CGSSCardIconView()
    let rarityLabel = UILabel()
    let nameLabel = UILabel()
    let romajiLabel = UILabel()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        rarityLabel.font = .systemFont(ofSize: 10)
        contentView.addSubview(rarityLabel)
        rarityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(iconView.snp.top)
        }
        
        nameLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(nameLabel)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.bottom.equalTo(iconView.snp.bottom)
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
        
        titleLabel.font = .systemFont(ofSize: 10)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rarityLabel.snp.right).offset(5)
            make.top.equalTo(iconView.snp.top)
        }
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CardDetailBasicCell: CardDetailSetable {
    
    func setup(with card: CGSSCard) {
        if CGSSGlobal.languageType == .en {
            romajiLabel.text = card.chara?.name
            nameLabel.text = card.chara?.conventional
        } else {
            nameLabel.text = card.chara?.name
            romajiLabel.text = card.chara?.conventional
        }
        titleLabel.text = card.title
        rarityLabel.text = card.rarity?.rarityString
        iconView.cardID = card.id
    }
    
}

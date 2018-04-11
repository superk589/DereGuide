//
//  CardView.swift
//  DereGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardView: UIView {

    let cardIconView = CGSSCardIconView()
    let cardNameLabel = UILabel()
    let romajiLabel = UILabel()
    let rarityLabel = UILabel()
    let skillLabel = UILabel()
    let lifeLabel = UILabel()
    let vocalLabel = UILabel()
    let danceLabel = UILabel()
    let visualLabel = UILabel()
    let totalLabel = UILabel()
    let titleLabel = UILabel()
    let nameOnlyLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func prepare() {
        
        cardIconView.isUserInteractionEnabled = false
        addSubview(cardIconView)
        cardIconView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        rarityLabel.textAlignment = .left
        rarityLabel.font = .systemFont(ofSize: 10)
        addSubview(rarityLabel)
        rarityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(68)
            make.top.equalTo(9)
        }
        
        cardNameLabel.font = .systemFont(ofSize: 16)
        cardNameLabel.adjustsFontSizeToFitWidth = true
        cardNameLabel.baselineAdjustment = .alignCenters
        addSubview(cardNameLabel)
        cardNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(68)
            make.top.equalTo(rarityLabel.snp.bottom).offset(2)
        }
    
        romajiLabel.font = UIFont(name: "PingFangSC-Light", size: 13)
        romajiLabel.adjustsFontSizeToFitWidth = true
        romajiLabel.baselineAdjustment = .alignCenters
        addSubview(romajiLabel)
        romajiLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cardNameLabel.snp.right).offset(5)
            make.right.lessThanOrEqualTo(-10)
            make.lastBaseline.equalTo(cardNameLabel)
        }
        romajiLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        romajiLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        cardNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        cardNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        
        titleLabel.font = .systemFont(ofSize: 10)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.baselineAdjustment = .alignCenters
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rarityLabel.snp.right).offset(5)
            make.top.equalTo(rarityLabel)
        }
        
        skillLabel.font = .systemFont(ofSize: 10)
        skillLabel.textAlignment = .right
        addSubview(skillLabel)
        skillLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(rarityLabel)
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(5)
        }
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        skillLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        rarityLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        lifeLabel.font = UIFont(name: "menlo", size: 12)
        lifeLabel.textColor = .life
        lifeLabel.textAlignment = .right
        
        vocalLabel.font = UIFont(name: "menlo", size: 12)
        vocalLabel.textColor = .vocal
        vocalLabel.textAlignment = .right
        
        danceLabel.font = UIFont(name: "menlo", size: 12)
        danceLabel.textColor = .dance
        danceLabel.textAlignment = .right
        
        visualLabel.font = UIFont(name: "menlo", size: 12)
        visualLabel.textColor = .visual
        visualLabel.textAlignment = .right

        totalLabel.font = UIFont(name: "menlo", size: 12)
        totalLabel.textColor = .darkGray
        totalLabel.textAlignment = .right

        let stackView = UIStackView(arrangedSubviews: [lifeLabel, vocalLabel, danceLabel, visualLabel, totalLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(68)
            make.right.equalTo(-10)
            make.bottom.equalTo(cardIconView.snp.bottom)
        }
    }
    
    func setup(with card: CGSSCard) {
        if CGSSGlobal.languageType == .en {
            romajiLabel.text = card.chara?.name
            cardNameLabel.text = card.chara?.conventional
        } else {
            cardNameLabel.text = card.chara?.name
            romajiLabel.text = card.chara?.conventional
        }
        
        cardIconView.cardID = card.id
        
        // 显示数值
        lifeLabel.text = String(card.life)
        vocalLabel.text = String(card.vocal)
        danceLabel.text = String(card.dance)
        visualLabel.text = String(card.visual)
        totalLabel.text = String(card.overall)
        
        // 显示稀有度
        rarityLabel.text = card.rarity?.rarityString ?? ""
        
        // 显示title
        titleLabel.text = card.title ?? ""
        
        // 显示主动技能类型
        if let skill = card.skill {
            skillLabel.text = skill.descriptionShort
        } else {
            skillLabel.text = ""
        }
    }
}

//
//  CardView.swift
//  DereGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardView: UIView {

    var cardIconView: CGSSCardIconView!
    var cardNameLabel: UILabel!
    var rarityLabel: UILabel!
    var skillLabel: UILabel!
    var lifeLabel: UILabel!
    var vocalLabel: UILabel!
    var danceLabel: UILabel!
    var visualLabel: UILabel!
    var totalLabel: UILabel!
    var titleLabel: UILabel!
    var nameOnlyLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func prepare() {
        
        cardIconView = CGSSCardIconView()
        cardIconView.isUserInteractionEnabled = false
        addSubview(cardIconView)
        cardIconView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        rarityLabel = UILabel()
        rarityLabel.textAlignment = .left
        rarityLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(rarityLabel)
        rarityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(68)
            make.top.equalTo(9)
        }
        
        cardNameLabel = UILabel()
        cardNameLabel.font = UIFont.systemFont(ofSize: 16)
        cardNameLabel.adjustsFontSizeToFitWidth = true
        cardNameLabel.baselineAdjustment = .alignCenters
        addSubview(cardNameLabel)
        cardNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(68)
            make.right.lessThanOrEqualTo(-10)
            make.top.equalTo(rarityLabel.snp.bottom).offset(2)
        }
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.baselineAdjustment = .alignCenters
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(rarityLabel.snp.right).offset(5)
            make.top.equalTo(rarityLabel)
        }
        
        skillLabel = UILabel()
        skillLabel.font = UIFont.systemFont(ofSize: 10)
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
        
        lifeLabel = UILabel()
//        lifeLabel.frame = CGRect(x: originX, y: originY, width: width, height: height)
        lifeLabel.font = UIFont.init(name: "menlo", size: 12)
        lifeLabel.textColor = Color.life
        lifeLabel.textAlignment = .right
        
        vocalLabel = UILabel()
//        vocalLabel.frame = CGRect(x: originX + width, y: originY, width: width, height: height)
        vocalLabel.font = UIFont.init(name: "menlo", size: 12)
        vocalLabel.textColor = Color.vocal
        vocalLabel.textAlignment = .right
        
        danceLabel = UILabel()
//        danceLabel.frame = CGRect(x: originX + 2 * width, y: originY, width: width, height: height)
        danceLabel.font = UIFont.init(name: "menlo", size: 12)
        danceLabel.textColor = Color.dance
        danceLabel.textAlignment = .right
        
        visualLabel = UILabel()
//        visualLabel.frame = CGRect(x: originX + 3 * width, y: originY, width: width, height: height)
        visualLabel.font = UIFont.init(name: "menlo", size: 12)
        visualLabel.textColor = Color.visual
        visualLabel.textAlignment = .right

        totalLabel = UILabel()
//        totalLabel.frame = CGRect(x: originX + 4 * width, y: originY, width: width, height: height)
        totalLabel.font = UIFont.init(name: "menlo", size: 12)
        totalLabel.textColor = UIColor.darkGray
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
        if let name = card.chara?.name, let conventional = card.chara?.conventional {
            cardNameLabel.text = name + "  " + conventional
        }
        
        cardIconView?.cardId = card.id
        
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

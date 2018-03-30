//
//  CharView.swift
//  DereGuide
//
//  Created by zzk on 2017/7/13.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class CharView: UIView {
    
    var iconView: CGSSCharaIconView!
    var nameLabel: UILabel!
    let romajiLabel = UILabel()
    var sortingPropertyLabel: UILabel!
    
    let cvLabel = UILabel()
    let voLabel = UILabel()
    let daLabel = UILabel()
    let viLabel = UILabel()
    let totalLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    fileprivate func prepare() {
        
        iconView = CGSSCharaIconView()
        iconView.isUserInteractionEnabled = false
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.height.width.equalTo(48)
            make.bottom.equalTo(-10)
        }
        
        cvLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(cvLabel)
        cvLabel.adjustsFontSizeToFitWidth = true
        cvLabel.baselineAdjustment = .alignCenters
        cvLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(9)
        }
        
        sortingPropertyLabel = UILabel()
        sortingPropertyLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(sortingPropertyLabel)
        sortingPropertyLabel.textAlignment = .right
        sortingPropertyLabel.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(cvLabel.snp.right).offset(5)
            make.right.equalTo(-10)
            make.top.equalTo(cvLabel)
        }
        
        sortingPropertyLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        cvLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(-10)
            make.top.equalTo(cvLabel.snp.bottom)
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
        
        voLabel.font = UIFont(name: "menlo", size: 12)
        voLabel.textColor = .vocal
        voLabel.textAlignment = .right
        
        daLabel.font = UIFont(name: "menlo", size: 12)
        daLabel.textColor = .dance
        daLabel.textAlignment = .right
        
        viLabel.font = UIFont(name: "menlo", size: 12)
        viLabel.textColor = .visual
        viLabel.textAlignment = .right
        
        totalLabel.font = UIFont(name: "menlo", size: 12)
        totalLabel.textColor = .darkGray
        totalLabel.textAlignment = .right
        
        let stackView = UIStackView(arrangedSubviews: [voLabel, daLabel, viLabel, totalLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(68)
            make.right.equalTo(-10)
            make.bottom.equalTo(iconView.snp.bottom)
        }
    }
    
    func setupWith(char: CGSSChar, sorter: CGSSSorter) {
        nameLabel.text = char.kanjiSpaced
        romajiLabel.text = char.conventional
        if char.voice == "" {
            cvLabel.text = "CV: \(NSLocalizedString("未付声", comment: "角色信息页面"))"
        } else {
            cvLabel.text = "CV: \(char.voice!)"
        }
        iconView.charaID = char.charaId
        
        if !["sName", "sCharaId", "sBusVoValue", "sBusDaValue", "sBusViValue", "sBusTotalValue"].contains(sorter.property) {
            if sorter.property == "sBirthday" {
                sortingPropertyLabel.text = "\(sorter.displayName): \(String.init(format: NSLocalizedString("%d月%d日", comment: ""), char.birthMonth, char.birthDay))"
            } else {
                if let value = char.value(forKeyPath: sorter.property) as? Int, value == 0 || value >= 5000 {
                    sortingPropertyLabel.text = "\(sorter.displayName): \(NSLocalizedString("未知", comment: ""))"
                } else {
                    sortingPropertyLabel.text = "\(sorter.displayName): \(char.value(forKeyPath: sorter.property) ?? NSLocalizedString("未知", comment: ""))"
                }
            }
        } else {
            sortingPropertyLabel.text = ""
        }
        
        voLabel.text = char.busVoValue.flatMap(String.init)
        daLabel.text = char.busDaValue.flatMap(String.init)
        viLabel.text = char.busViValue.flatMap(String.init)
        totalLabel.text = char.busTotalValue.flatMap(String.init)
    }
    
}


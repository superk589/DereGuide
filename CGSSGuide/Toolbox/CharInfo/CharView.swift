//
//  CharView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/13.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class CharView: UIView {
    
    var iconView: CGSSCharIconView!
    var kanaSpacedLabel: UILabel!
    var nameLabel: UILabel!
    var cvLabel: UILabel!
    var sortingPropertyLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    fileprivate func prepare() {
        
        iconView = CGSSCharIconView()
        iconView.isUserInteractionEnabled = false
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.height.width.equalTo(48)
            make.bottom.equalTo(-10)
        }
        
        kanaSpacedLabel = UILabel()
        kanaSpacedLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(kanaSpacedLabel)
        kanaSpacedLabel.adjustsFontSizeToFitWidth = true
        kanaSpacedLabel.baselineAdjustment = .alignCenters
        kanaSpacedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(9)
        }
        
        sortingPropertyLabel = UILabel()
        sortingPropertyLabel.font = UIFont.systemFont(ofSize: 10)
        addSubview(sortingPropertyLabel)
        sortingPropertyLabel.textAlignment = .right
        sortingPropertyLabel.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(kanaSpacedLabel.snp.right).offset(5)
            make.right.equalTo(-10)
            make.top.equalTo(kanaSpacedLabel)
        }
        
        sortingPropertyLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        kanaSpacedLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(-10)
            make.top.equalTo(kanaSpacedLabel.snp.bottom).offset(3)
        }
        
        cvLabel = UILabel()
        cvLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(cvLabel)
        cvLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.lastBaseline.equalTo(iconView.snp.bottom)
        }
    }
    
    func setupWith(char: CGSSChar, sorter: CGSSSorter) {
        nameLabel.text = "\(char.kanjiSpaced!)  \(char.conventional!)"
        if char.voice == "" {
            cvLabel.text = "CV: \(NSLocalizedString("未付声", comment: "角色信息页面"))"
        } else {
            cvLabel.text = "CV: \(char.voice!)"
        }
        iconView.charId = char.charaId
        kanaSpacedLabel.text = "\(char.kanaSpaced!)"
        
        if !["sName", "sCharaId"].contains(sorter.property) {
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
    }
    
}


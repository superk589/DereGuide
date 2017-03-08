//
//  CardAppealView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardAppealView: UIView {

    var titleLabel: UILabel!
    var appealGridLabel: CGSSGridLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 属性表格
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = NSLocalizedString("卡片属性", comment: "卡片详情页") + ":"
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        appealGridLabel = CGSSGridLabel.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width - 20, height: 90), rows: 5, columns: 6)
        addSubview(appealGridLabel)
        appealGridLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(90)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with card: CGSSCard) {
        // 设置属性列表
        var appealGridStrings = [[String]]()
        appealGridStrings.append(["  ", "HP", "Vocal", "Dance", "Visual", "Total"])
        appealGridStrings.append(["Lv.1", String(card.hpMin), String(card.vocalMin), String(card.danceMin), String(card.visualMin), String(card.overallMin)])
        appealGridStrings.append(["Lv.\(card.rarity.baseMaxLevel!)", String(card.hpMax), String(card.vocalMax), String(card.danceMax), String(card.visualMax), String(card.overallMax)])
        appealGridStrings.append(["Bonus", String(card.bonusHp), String(card.bonusVocal), String(card.bonusDance), String(card.bonusVisual), String(card.overallBonus)])
        appealGridStrings.append(["Total", String(card.life), String(card.vocal), String(card.dance), String(card.visual), String(card.overall)])
        
        appealGridLabel.setGridContent(appealGridStrings)
        
        let colorArray = [Color.allType, Color.life, Color.vocal, Color.dance, Color.visual, Color.allType]
        let colors = [[UIColor]].init(repeating: colorArray, count: 6)
        appealGridLabel.setGridColor(colors)
        
        var fonts = [[UIFont]]()
        let fontArray = [UIFont].init(repeating: CGSSGlobal.alphabetFont, count: 6)
        var fontArray2 = [UIFont].init(repeating: CGSSGlobal.numberFont!, count: 6)
        fontArray2[0] = CGSSGlobal.alphabetFont
        fonts.append(fontArray)
        fonts.append(fontArray2)
        fonts.append(fontArray2)
        fonts.append(fontArray2)
        fonts.append(fontArray2)
        appealGridLabel.setGridFont(fonts)
    }
    
}

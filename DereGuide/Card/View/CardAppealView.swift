//
//  CardAppealView.swift
//  DereGuide
//
//  Created by zzk on 2017/3/7.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardAppealView: UIView {

    let titleLabel = UILabel()
    let appealGridLabel = GridLabel(rows: 5, columns: 6)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 属性表格
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = NSLocalizedString("卡片属性", comment: "卡片详情页")
        titleLabel.textColor = .black
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(10)
        }
        
        addSubview(appealGridLabel)
        appealGridLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
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
        
        appealGridLabel.setContents(appealGridStrings)
        
        let colorArray = [UIColor.allType, .life, .vocal, .dance, .visual, .allType]
        let colors = [[UIColor]](repeating: colorArray, count: 6)
        appealGridLabel.setColors(colors)
        
        var fonts = [[UIFont]]()
        let fontArray = [UIFont](repeating: CGSSGlobal.alphabetFont, count: 6)
        var fontArray2 = [UIFont](repeating: CGSSGlobal.numberFont!, count: 6)
        fontArray2[0] = CGSSGlobal.alphabetFont
        fonts.append(fontArray)
        fonts.append(fontArray2)
        fonts.append(fontArray2)
        fonts.append(fontArray2)
        fonts.append(fontArray2)
        appealGridLabel.setFonts(fonts)
    }
    
}

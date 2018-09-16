//
//  NoteScoreTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/3/29.
//  Copyright © 2017 zzk. All rights reserved.
//


import UIKit
import SnapKit

class NoteScoreLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustsFontSizeToFitWidth = true
        textAlignment = .center
        baselineAdjustment = .alignCenters
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NoteScoreTableViewCell: UITableViewCell {
    
    let comboIndexLabel = NoteScoreLabel()
    let perfectBonusLabel = NoteScoreLabel()
    let comboBonusLabel = NoteScoreLabel()
    let skillBoostLabel = NoteScoreLabel()
    let finalScoreLabel = NoteScoreLabel()
    let totalScoreLabel = NoteScoreLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        comboIndexLabel.textColor = .allType
        
        perfectBonusLabel.textColor = .vocal
        perfectBonusLabel.numberOfLines = 2
        
        comboBonusLabel.textColor = .visual
        comboBonusLabel.numberOfLines = 2
        
        skillBoostLabel.textColor = .cute
        
        finalScoreLabel.textColor = .allType
        
        totalScoreLabel.textColor = .parade
        
        contentView.addSubview(comboIndexLabel)
        contentView.addSubview(perfectBonusLabel)
        contentView.addSubview(comboBonusLabel)
        contentView.addSubview(skillBoostLabel)
        contentView.addSubview(finalScoreLabel)
        contentView.addSubview(totalScoreLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 5
        let width = (contentView.bounds.width - 7 * space) / 6
        let height = contentView.bounds.size.height
        comboIndexLabel.frame = CGRect(x: space, y: 0, width: width, height: height)
        perfectBonusLabel.frame = CGRect(x: space + comboIndexLabel.frame.maxX, y: 0, width: width, height: height)
        comboBonusLabel.frame = CGRect(x: space + perfectBonusLabel.frame.maxX, y: 0, width: width, height: height)
        skillBoostLabel.frame = CGRect(x: space + comboBonusLabel.frame.maxX, y: 0, width: width, height: height)
        finalScoreLabel.frame = CGRect(x: space + skillBoostLabel.frame.maxX, y: 0, width: width, height: height)
        totalScoreLabel.frame = CGRect(x: space + finalScoreLabel.frame.maxX, y: 0, width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(with log: LSLog) {
        
        let attributeStr = NSMutableAttributedString(string: String(format: "%d", log.noteIndex), attributes: [NSAttributedString.Key.foregroundColor: UIColor.allType])
        if log.comboFactor > 1 {
            attributeStr.append(NSAttributedString(string: String(format: "(x%.1f)", log.comboFactor), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]))
        }
        comboIndexLabel.attributedText = attributeStr
        
        if log.perfectBonus == 100 {
            perfectBonusLabel.text = "-"
        } else {
            perfectBonusLabel.text = "\(log.perfectBonus - 100)%"
        }
        
        if log.comboBonus == 100 {
            comboBonusLabel.text = "-"
        } else {
            comboBonusLabel.text = "\(log.comboBonus - 100)%"
        }
        
        if log.skillBoost == 1000 {
            skillBoostLabel.text = "-"
        } else {
            skillBoostLabel.text = "\((log.skillBoost - 1000) / 10)%"
        }
        
        finalScoreLabel.text = String(format: "%d", log.score)
        
        totalScoreLabel.text = String(log.sum)
        
        if log.currentLife == 0 {
            backgroundColor = UIColor.lightGray.lighter()
        } else {
            backgroundColor = .white
        }
    }

}

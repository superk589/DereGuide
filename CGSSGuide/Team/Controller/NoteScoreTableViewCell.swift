//
//  NoteScoreTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/29.
//  Copyright © 2017年 zzk. All rights reserved.
//


import UIKit
import SnapKit

class NoteScoreLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
        self.baselineAdjustment = .alignCenters
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NoteScoreTableViewCell: UITableViewCell {
    
    var comboIndexLabel: UILabel!
    var perfectBonusLabel: UILabel!
    var comboBonusLabel: UILabel!
    var skillBoostLabel: UILabel!
    var finalScoreLabel: UILabel!
    var totalScoreLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        comboIndexLabel = NoteScoreLabel()
        comboIndexLabel.textColor = Color.allType
        
        perfectBonusLabel = NoteScoreLabel()
        perfectBonusLabel.textColor = Color.vocal
        perfectBonusLabel.numberOfLines = 2
        
        comboBonusLabel = NoteScoreLabel()
        comboBonusLabel.textColor = Color.visual
        comboBonusLabel.numberOfLines = 2
        
        skillBoostLabel = NoteScoreLabel()
        skillBoostLabel.textColor = Color.cute
        
        finalScoreLabel = NoteScoreLabel()
        finalScoreLabel.textColor = Color.allType
        
        totalScoreLabel = NoteScoreLabel()
        totalScoreLabel.textColor = Color.parade
        
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
        comboIndexLabel.frame = CGRect.init(x: space, y: 0, width: width, height: height)
        perfectBonusLabel.frame = CGRect.init(x: space + comboIndexLabel.frame.maxX, y: 0, width: width, height: height)
        comboBonusLabel.frame = CGRect.init(x: space + perfectBonusLabel.frame.maxX, y: 0, width: width, height: height)
        skillBoostLabel.frame = CGRect.init(x: space + comboBonusLabel.frame.maxX, y: 0, width: width, height: height)
        finalScoreLabel.frame = CGRect.init(x: space + skillBoostLabel.frame.maxX, y: 0, width: width, height: height)
        totalScoreLabel.frame = CGRect.init(x: space + finalScoreLabel.frame.maxX, y: 0, width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(with detail: NoteScoreDetail) {
        
        let attributeStr = NSMutableAttributedString.init(string: String.init(format: "%d", detail.noteIndex), attributes: [NSForegroundColorAttributeName: Color.allType])
        if detail.comboFactor > 1 {
            attributeStr.append(NSAttributedString.init(string: String.init(format: "(x%.1f)", detail.comboFactor), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10)]))
        }
        comboIndexLabel.attributedText = attributeStr
        
        if detail.perfectBonus == 100 {
            perfectBonusLabel.text = "-"
        } else {
            perfectBonusLabel.text = "\(detail.perfectBonus - 100)%"
        }
        
        if detail.comboBonus == 100 {
            comboBonusLabel.text = "-"
        } else {
            comboBonusLabel.text = "\(detail.comboBonus - 100)%"
        }
            //        } else {
//            comboBonusLabel.text = "\(Float(detail.baseComboBonus) / 100)\n→\(Float(detail.comboBonus) / 100)"
//        }
        
        if detail.skillBoost == 1000 {
            skillBoostLabel.text = "-"
        } else {
            skillBoostLabel.text = "\((detail.skillBoost - 1000) / 10)%"
        }
        
        finalScoreLabel.text = String.init(format: "%d", detail.score)
        
        totalScoreLabel.text = String(detail.sum)
    }

}

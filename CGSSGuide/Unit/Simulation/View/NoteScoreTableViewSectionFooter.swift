//
//  NoteScoreTableViewSectionFooter.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class NoteScoreTableViewSectionFooter: UITableViewHeaderFooterView {

    var baseScoreLabel: UILabel!
    
    var totalScoreLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        baseScoreLabel = UILabel()
        baseScoreLabel.adjustsFontSizeToFitWidth = true
        baseScoreLabel.textAlignment = .right
        baseScoreLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(baseScoreLabel)
        
        totalScoreLabel = UILabel()
        totalScoreLabel.adjustsFontSizeToFitWidth = true
        totalScoreLabel.textAlignment = .right
        totalScoreLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(totalScoreLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(baseScore: Double, totalScore: Int) {
        baseScoreLabel.text = NSLocalizedString("基础分", comment: "") + ": " + String.init(format: "%.2f", baseScore)
        let attStr = NSMutableAttributedString.init(string: NSLocalizedString("总分", comment: "") + ": ", attributes: nil)
        attStr.append(NSAttributedString.init(string: String(totalScore), attributes: [NSAttributedStringKey.foregroundColor: Color.cute]))
        totalScoreLabel.attributedText = attStr
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseScoreLabel.frame = CGRect.init(x: 5, y: 0, width: fwidth / 2 - 10, height: fheight)
        totalScoreLabel.frame = CGRect.init(x: baseScoreLabel.frame.maxX + 10, y: 0, width: fwidth / 2 - 10, height: fheight)
    }
}

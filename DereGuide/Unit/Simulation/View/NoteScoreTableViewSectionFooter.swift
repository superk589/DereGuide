//
//  NoteScoreTableViewSectionFooter.swift
//  DereGuide
//
//  Created by zzk on 2017/3/31.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class NoteScoreTableViewSectionFooter: UITableViewHeaderFooterView {

    let baseScoreLabel = UILabel()
    
    let totalScoreLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        baseScoreLabel.adjustsFontSizeToFitWidth = true
        baseScoreLabel.textAlignment = .right
        baseScoreLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(baseScoreLabel)
        
        totalScoreLabel.adjustsFontSizeToFitWidth = true
        totalScoreLabel.textAlignment = .right
        totalScoreLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(totalScoreLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(baseScore: Double, totalScore: Int) {
        baseScoreLabel.text = NSLocalizedString("基础分", comment: "") + ": " + String(format: "%.2f", baseScore)
        let attStr = NSMutableAttributedString(string: NSLocalizedString("总分", comment: "") + ": ", attributes: nil)
        attStr.append(NSAttributedString(string: String(totalScore), attributes: [NSAttributedStringKey.foregroundColor: UIColor.cute]))
        totalScoreLabel.attributedText = attStr
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseScoreLabel.frame = CGRect(x: 5, y: 0, width: fwidth / 2 - 10, height: fheight)
        totalScoreLabel.frame = CGRect(x: baseScoreLabel.frame.maxX + 10, y: 0, width: fwidth / 2 - 10, height: fheight)
    }
}

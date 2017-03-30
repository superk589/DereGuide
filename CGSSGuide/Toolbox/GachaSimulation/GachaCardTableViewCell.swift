//
//  GachaCardTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/30.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class GachaCardTableViewCell: CardTableViewCell {

    override func prepare() {
        super.prepare()
        cardView.titleLabel.textColor = Color.vocal
    }
    
    func setupWith(_ card: CGSSCard, _ odds: Int) {
        super.setup(with: card)
        cardView.titleLabel.text = NSLocalizedString("出现率", comment: "") + ": " + String.init(format: "%.3f%%", Double(odds / 10) / 1000 )
    }
}

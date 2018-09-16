//
//  GachaCardTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/3/30.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class GachaCardTableViewCell: CardTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardView.titleLabel.textColor = .vocal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(_ card: CGSSCard, _ odds: Int) {
        super.setup(with: card)
        cardView.titleLabel.text = NSLocalizedString("出现率", comment: "") + ": " + String.init(format: "%.3f%%", Double(odds / 10) / 1000)
    }
}

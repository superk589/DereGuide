//
//  GachaDetailGuaranteesCell.swift
//  DereGuide
//
//  Created by zzk on 19/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class GachaDetailGuaranteesCell: CardDetailRelatedCardsCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        rightLabel.isHidden = true
        leftLabel.text = NSLocalizedString("天井", comment: "模拟抽卡页面")
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

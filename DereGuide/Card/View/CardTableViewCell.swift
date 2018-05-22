//
//  CardTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 16/6/30.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardTableViewCell: UITableViewCell {
    
    let cardView = CardView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(readableContentGuide)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(with card: CGSSCard) {
        cardView.setup(with: card)
    }

}

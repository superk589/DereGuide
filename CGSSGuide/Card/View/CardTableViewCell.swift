//
//  CardTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardTableViewCell: ReadableWidthTableViewCell {
    
    var cardView: CardView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardView = CardView()
        readableContentView.addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(with card: CGSSCard) {
        cardView.setup(with: card)
    }

}

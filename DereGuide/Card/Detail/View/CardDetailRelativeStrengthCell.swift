//
//  CardDetailRelativeStrengthCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CardDetailRelativeStrengthCell: UITableViewCell {
    
    let rankingView = CardRankingView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(rankingView)
        rankingView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(readableContentGuide)
        }
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardDetailRelativeStrengthCell: CardDetailSetable {
    func setup(with card: CGSSCard) {
        rankingView.setup(with: card)
    }
}

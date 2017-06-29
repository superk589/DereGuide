//
//  CardDetailRelativeStrengthCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class CardDetailRelativeStrengthCell: UITableViewCell {
    
    var rankingView: CardRankingView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        rankingView = CardRankingView()
        contentView.addSubview(rankingView)
        rankingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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

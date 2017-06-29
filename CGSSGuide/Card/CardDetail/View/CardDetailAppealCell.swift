//
//  CardDetailAppealCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class CardDetailAppealCell: UITableViewCell {
    
    var appealView: CardAppealView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        appealView = CardAppealView()
        contentView.addSubview(appealView)
        appealView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardDetailAppealCell: CardDetailSetable {
    func setup(with card: CGSSCard) {
        appealView.setup(with: card)
    }
}

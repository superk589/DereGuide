
//
//  CardDetailSpreadImageCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol CardDetailSetable {
    func setup(with card: CGSSCard)
}

class CardDetailSpreadImageCell: UITableViewCell {
    
    var spreadImageView: SpreadImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        spreadImageView = SpreadImageView()
        contentView.addSubview(spreadImageView)
        spreadImageView.snp.makeConstraints({ (make) in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(spreadImageView.snp.width).multipliedBy(824.0 / 1280.0)
            make.bottom.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardDetailSpreadImageCell: CardDetailSetable {
    func setup(with card: CGSSCard) {
        if let url = card.spreadImageURL {
            spreadImageView.setImage(with: url)
        }
    }
}


//
//  EventCardView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class EventCardView: UIView {

    var cardView: CardView!
    
    var descLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        descLabel = UILabel()
        addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        descLabel.font = Font.content
        descLabel.textColor = UIColor.darkGray
        
        cardView = CardView()
        addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(-2)
            make.height.equalTo(68)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(card: CGSSCard, desc:String) {
        self.descLabel.text = desc
        self.cardView.setup(with: card)
    }
}

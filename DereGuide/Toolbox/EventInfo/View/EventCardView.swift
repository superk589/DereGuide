
//
//  EventCardView.swift
//  DereGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class EventCardView: UIView {

    let cardView = CardView()
    
    let descLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        descLabel.font = .systemFont(ofSize: 16)
        descLabel.textColor = .black
        
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

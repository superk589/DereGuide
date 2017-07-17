//
//  GachaCardView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class GachaCardView: UIView {
    
    var icon: CGSSCardIconView
    var oddsLabel: UILabel
    
    override init(frame: CGRect) {
        icon = CGSSCardIconView()
        oddsLabel = UILabel()
        oddsLabel.adjustsFontSizeToFitWidth = true
        oddsLabel.font = UIFont.systemFont(ofSize: 12)
        oddsLabel.textColor = Color.vocal
        
        super.init(frame: frame)
        addSubview(oddsLabel)
        addSubview(icon)
        
        oddsLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(14.5)
            make.bottom.equalToSuperview()
        }
        
        icon.snp.makeConstraints { (make) in
            make.right.left.top.equalToSuperview()
            make.height.equalTo(snp.width)
            make.bottom.equalTo(oddsLabel.snp.top)
        }
   }
    
    func setupWith(card: CGSSCard, odds: Int?) {
        icon.cardId = card.id
        if let odds = odds, odds != 0 {
            oddsLabel.text = String(format: "%.3f%%", Double(odds / 10) / 1000)
        } else {
            oddsLabel.text = "n/a"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

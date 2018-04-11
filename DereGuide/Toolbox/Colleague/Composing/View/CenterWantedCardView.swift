//
//  CenterWantedCardView.swift
//  DereGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CenterWantedCardView: UIView {

    var icon: CGSSCardIconView
    var minLevelLabel: UILabel
    
    override init(frame: CGRect) {
        
        icon = CGSSCardIconView()
        minLevelLabel = UILabel()
        
        super.init(frame: frame)
        addSubview(icon)
        addSubview(minLevelLabel)
        
        minLevelLabel.font = UIFont.systemFont(ofSize: 12)
        minLevelLabel.textColor = UIColor.darkGray
        minLevelLabel.adjustsFontSizeToFitWidth = true
        minLevelLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.top.equalToSuperview()
        }
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(minLevelLabel.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(snp.width)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func setupWith(cardID: Int, minLevel: Int) {
        icon.cardID = cardID
        minLevelLabel.text = "≥" + String(minLevel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

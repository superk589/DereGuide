//
//  ProfileCardView.swift
//  DereGuide
//
//  Created by zzk on 2017/8/3.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class MyCenterCardView: UIView {

    var icon: CGSSCardIconView
    var potentialLabel: PotentialLabel
    
    override init(frame: CGRect) {
        potentialLabel = PotentialLabel()
        potentialLabel.adjustsFontSizeToFitWidth = true
        
        icon = CGSSCardIconView()
       
        super.init(frame: frame)
        addSubview(icon)
        addSubview(potentialLabel)
        
        potentialLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.top.equalToSuperview()
        }
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(potentialLabel.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(snp.width)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupWith(cardID: Int, potential: CGSSPotential) {
        icon.cardId = cardID
        potentialLabel.setup(with: potential)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

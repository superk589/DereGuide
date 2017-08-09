//
//  CenterWantedCardView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class CenterWantedCardView: UIView {

    var icon: CGSSCardIconView
    
    override init(frame: CGRect) {
        
        icon = CGSSCardIconView()
        
        super.init(frame: frame)
        addSubview(icon)
      
        icon.snp.makeConstraints { (make) in
            make.right.top.left.equalToSuperview()
            make.height.equalTo(snp.width)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupWith(cardID: Int) {
        icon.cardId = cardID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

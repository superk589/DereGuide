//
//  CardCollectionViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardCollectionViewCell: UICollectionViewCell {
    
    var icon: CGSSCardIconView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        icon = CGSSCardIconView()
        icon.isUserInteractionEnabled = false
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalTo(48)
        }
    }
    
    func setup(with card: CGSSCard) {
        icon.cardID = card.id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

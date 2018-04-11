//
//  UnitLeaderSkillView.swift
//  DereGuide
//
//  Created by zzk on 2017/4/1.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitLeaderSkillView: TipView {
    
    let descLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        descLabel.numberOfLines = 0
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    }
    
    func setupWith(text: String, backgroundColor: UIColor) {
        descLabel.text = text
        contentColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

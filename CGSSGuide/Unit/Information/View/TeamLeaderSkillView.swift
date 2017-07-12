//
//  TeamLeaderSkillView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/4/1.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class TeamLeaderSkillView: TipView {
    
    var descLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        descLabel = UILabel()
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFont(ofSize: 14)
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
        self.contentColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

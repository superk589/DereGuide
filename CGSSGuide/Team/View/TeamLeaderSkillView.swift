//
//  TeamLeaderSkillView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/4/1.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class TeamLeaderSkillView: TipView {
    
    var descLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        descLabel = UILabel()
        descLabel.numberOfLines = 3
        descLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(descLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descLabel.frame = self.contentView.bounds.insetBy(dx: 10, dy: 0)
    }
    
    func setupWith(text: String, backgroundColor: UIColor) {
        descLabel.text = text
        self.contentColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

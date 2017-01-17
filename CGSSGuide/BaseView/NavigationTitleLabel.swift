//
//  NavigationTitleLabel.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class NavigationTitleLabel: UILabel {

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        numberOfLines = 2
        font = UIFont.systemFont(ofSize: 12)
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

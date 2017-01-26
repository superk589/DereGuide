//
//  TimeStatusIndicator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/26.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
enum TimeStatusIndicatorStyle {
    case past
    case now
    case future
}

class TimeStatusIndicator: StatusIndicator {

    
    var style: TimeStatusIndicatorStyle = .now {
        didSet {
            switch style {
            case .past:
                color = UIColor.red
            case .now:
                color = UIColor.green
            case .future:
                color = UIColor.orange
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        color = UIColor.green
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

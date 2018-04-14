//
//  TimeStatusIndicator.swift
//  DereGuide
//
//  Created by zzk on 2017/1/26.
//  Copyright © 2017 zzk. All rights reserved.
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
                color = .red
            case .now:
                color = .green
            case .future:
                color = .orange
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        color = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  TeamSimulationSwitchOption.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class TeamSimulationSwitchOption: UIControl {

    let `switch`: UISwitch
    let label: UILabel
    
    override init(frame: CGRect) {
        `switch` = UISwitch()
        label = UILabel()
        super.init(frame: frame)
        
        `switch`.isOn = false
        addSubview(`switch`)
        `switch`.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        addSubview(label)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(`switch`)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(`switch`.snp.left)
        }
        
        `switch`.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
    
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controllEvents: UIControlEvents) {
        `switch`.addTarget(target, action: action, for: controllEvents)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

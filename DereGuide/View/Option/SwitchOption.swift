//
//  SwitchOption.swift
//  DereGuide
//
//  Created by zzk on 2017/5/31.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class SwitchOption: UIControl {

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
        label.baselineAdjustment = .alignCenters
        label.font = UIFont.systemFont(ofSize: 14)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(`switch`)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(`switch`.snp.left)
        }
        
        `switch`.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
    
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controllEvents: UIControl.Event) {
        `switch`.addTarget(target, action: action, for: controllEvents)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  TextFieldOption.swift
//  DereGuide
//
//  Created by zzk on 2017/5/31.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class TextFieldOption: UIControl {

    let label: UILabel
    let textField: UnitSimulationAppealInputTextField
    
    
    override init(frame: CGRect) {
        label = UILabel()
        textField = UnitSimulationAppealInputTextField()
        
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).offset(-10)
        }
        
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.font = UIFont.systemFont(ofSize: 14)
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.height.greaterThanOrEqualTo(24)
            make.right.lessThanOrEqualTo(textField.snp.left).offset(-5)
        }
        
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        textField.addTarget(target, action: action, for: controlEvents)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

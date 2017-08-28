//
//  TextFieldOption.swift
//  DereGuide
//
//  Created by zzk on 2017/5/31.
//  Copyright © 2017年 zzk. All rights reserved.
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
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(24)
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.bottom.equalToSuperview()
        }
        
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(textField)
            make.left.equalToSuperview()
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

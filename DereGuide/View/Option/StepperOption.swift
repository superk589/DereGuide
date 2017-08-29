//
//  StepperOption.swift
//  DereGuide
//
//  Created by zzk on 2017/8/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class StepperOption: UIControl {
    
    var leftLabel: UILabel!
    
    var stepper: ValueStepper!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        stepper = ValueStepper()
        stepper.tintColor = Color.dance
        stepper.numberFormatter.maximumFractionDigits = 0
        stepper.stepValue = 1
        addSubview(stepper)
        stepper.snp.makeConstraints { (make) in
            make.width.equalTo(140)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        stepper.valueLabel.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        leftLabel = UILabel()
        addSubview(leftLabel)
        leftLabel.numberOfLines = 2
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.baselineAdjustment = .alignCenters
        leftLabel.textColor = UIColor.darkGray
        leftLabel.font = UIFont.systemFont(ofSize: 14)
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(stepper)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(stepper.snp.left)
        }
        
        stepper.descriptionLabel.removeFromSuperview()
    }
    
    func setup(title: String, minValue: Double, maxValue: Double, currentValue: Double) {
        self.leftLabel.text = title
        stepper.minimumValue = minValue
        stepper.maximumValue = maxValue
        stepper.value = currentValue
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controllEvents: UIControlEvents) {
        stepper.addTarget(target, action: action, for: controllEvents)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

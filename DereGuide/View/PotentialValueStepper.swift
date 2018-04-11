//
//  PotentialValueStepper.swift
//  DereGuide
//
//  Created by zzk on 2017/8/3.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class PotentialValueStepper: ValueStepper {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        maximumValue = 10
        minimumValue = 0
        stepValue = 1
        numberFormatter.maximumFractionDigits = 0
    }
    
    convenience init(type: CGSSAttributeTypes) {
        self.init(frame: .zero)
        numberFormatter.positivePrefix = type.short + " +"
        tintColor = type.color
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

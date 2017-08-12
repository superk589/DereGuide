//
//  ValueStepperCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol ValueStepperCellDelegate: class {
    func valueStepperCell(_ valueStepperCell: ValueStepperCell, didChangeTo newValue: Double)
}

class ValueStepperCell: UITableViewCell {
    
    weak var delegate: ValueStepperCellDelegate?
    
    var leftLabel: UILabel!
    
    var stepper: ValueStepper!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel = UILabel()
        contentView.addSubview(leftLabel)
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        stepper = ValueStepper()
        stepper.tintColor = Color.parade
        stepper.numberFormatter.maximumFractionDigits = 0
        stepper.stepValue = 1
        contentView.addSubview(stepper)
        stepper.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.height.equalTo(34)
            make.width.equalTo(140)
        }
        
        stepper.valueLabel.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
        }
        stepper.descriptionLabel.removeFromSuperview()
        stepper.addTarget(self, action: #selector(handleValueChanged(_:)), for: .valueChanged)
        selectionStyle = .none
    }
    
    func setup(title: String, minValue: Double, maxValue: Double, currentValue: Double) {
        self.leftLabel.text = title
        stepper.minimumValue = minValue
        stepper.maximumValue = maxValue
        stepper.value = currentValue
    }
    
    func handleValueChanged(_ stepper: ValueStepper) {
        delegate?.valueStepperCell(self, didChangeTo: stepper.value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

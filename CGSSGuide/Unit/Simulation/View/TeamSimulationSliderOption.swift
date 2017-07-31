//
//  TeamSimulationSliderOption.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/31.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class TeamSimulationSliderOption: UIControl {

    let slider: UISlider
    let label: UILabel
    let sliderDescriptionLabel: UILabel
    
    var currentValue: Int {
        get {
            return Int(round(slider.value))
        }
        set {
            slider.value = Float(newValue)
            sliderDescriptionLabel.text = String(newValue)
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        
        slider = UISlider()
        label = UILabel()
        sliderDescriptionLabel = UILabel()
        super.init(frame: frame)
        
        addSubview(slider)
        addSubview(label)
        addSubview(sliderDescriptionLabel)
        
        slider.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalTo(-5)
            make.width.equalTo(self.snp.width).dividedBy(2)
            make.bottom.equalToSuperview()
        }

        sliderDescriptionLabel.snp.makeConstraints { (make) in
            make.right.equalTo(slider.snp.left)
            make.width.equalTo(50)
            make.centerY.equalToSuperview()
        }
        sliderDescriptionLabel.textColor = Color.parade
        sliderDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        sliderDescriptionLabel.textAlignment = .left
        
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(slider)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(sliderDescriptionLabel.snp.left)
        }
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        sliderDescriptionLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controllEvents: UIControlEvents) {
        slider.addTarget(target, action: action, for: controllEvents)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        sliderDescriptionLabel.text = String(currentValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

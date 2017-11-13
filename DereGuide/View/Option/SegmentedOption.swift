//
//  SegmentedOption.swift
//  DereGuide
//
//  Created by zzk on 13/11/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class SegmentedOption: UIControl {

    let segmentedControll: UISegmentedControl
    let label: UILabel
    
    override init(frame: CGRect) {
        
        segmentedControll = UISegmentedControl()
        label = UILabel()
        super.init(frame: frame)
        
        addSubview(segmentedControll)
        segmentedControll.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addSubview(label)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(segmentedControll)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(segmentedControll.snp.left)
        }
        
        segmentedControll.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controllEvents: UIControlEvents) {
        segmentedControll.addTarget(target, action: action, for: controllEvents)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  UnitAdvanceCalculationResultView.swift
//  DereGuide
//
//  Created by zzk on 2017/6/21.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitAdvanceCalculationResultView: UIView {
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftLabel)
        addSubview(rightLabel)
        
        rightLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(24)
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.bottom.equalToSuperview()
        }
        rightLabel.textColor = .cute
        rightLabel.textAlignment = .right
        rightLabel.font = .systemFont(ofSize: 14)
        rightLabel.adjustsFontSizeToFitWidth = true
        
        let line = LineView()
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(rightLabel.snp.bottom)
            make.left.right.equalTo(rightLabel)
        }
        
        leftLabel.numberOfLines = 2
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.baselineAdjustment = .alignCenters
        leftLabel.font = .systemFont(ofSize: 14)
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(rightLabel)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(rightLabel.snp.left).offset(-5)
        }
        leftLabel.text = NSLocalizedString("计算结果", comment: "")
    }
    
    func setup(result: String) {
        rightLabel.text = result
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

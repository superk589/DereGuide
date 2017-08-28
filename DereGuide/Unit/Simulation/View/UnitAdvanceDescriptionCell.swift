//
//  UnitAdvanceDescriptionCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/21.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitAdvanceDescriptionCell: UITableViewCell {

    var leftLabel: UILabel!
    var rightLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftLabel = UILabel()
        contentView.addSubview(leftLabel)
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.baselineAdjustment = .alignCenters
        
        rightLabel = UILabel()
        contentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.left.equalTo(leftLabel.snp.right)
        }
        rightLabel.font = UIFont.systemFont(ofSize: 16)
        rightLabel.textColor = UIColor.darkGray
        
        leftLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        leftLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        rightLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        selectionStyle = .none
    }
    
    func setupWith(leftString: String, rightString: String) {
        leftLabel.text = leftString
        rightLabel.text = rightString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

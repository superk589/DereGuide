//
//  WipeTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/11.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class WipeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let tl1 = textLabel, let tl2 = detailTextLabel {
            tl1.fwidth = tl2.fx - 10 - tl1.fx
        }
        textLabel?.adjustsFontSizeToFitWidth = true
        textLabel?.baselineAdjustment = .alignCenters
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

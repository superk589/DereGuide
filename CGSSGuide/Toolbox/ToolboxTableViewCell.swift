//
//  ToolboxTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class ToolboxTableViewCell: UITableViewCell {
    
    var icon: CGSSCardIconView!
    var descLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        icon = CGSSCardIconView.init(frame: CGRect(x: 10, y: 10, width: 48, height: 48))
        icon.isUserInteractionEnabled = false
        descLabel = UILabel.init(frame: CGRect(x: 68, y: 25, width: CGSSGlobal.width - 78, height: 18))
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.textAlignment = .left
        descLabel.backgroundColor = UIColor.white
        contentView.addSubview(icon)
        contentView.addSubview(descLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

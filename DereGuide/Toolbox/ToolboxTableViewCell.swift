//
//  ToolboxTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import SnapKit

class ToolboxTableViewCell: UITableViewCell {
    
    let icon = CGSSCardIconView(frame: CGRect(x: 10, y: 10, width: 48, height: 48))
    let descLabel = UILabel(frame: CGRect(x: 68, y: 25, width: CGSSGlobal.width - 78, height: 18))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        icon.isUserInteractionEnabled = false

        descLabel.font = .systemFont(ofSize: 16)
        descLabel.textAlignment = .left
        descLabel.backgroundColor = .white
        contentView.addSubview(icon)
        contentView.addSubview(descLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

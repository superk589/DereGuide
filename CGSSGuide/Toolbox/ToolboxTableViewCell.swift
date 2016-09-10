//
//  ToolboxTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class ToolboxTableViewCell: UITableViewCell {
    var icon: CGSSCardIconView!
    var descLabel: UILabel!
    var asView: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    func prepare() {
        icon = CGSSCardIconView.init(frame: CGRectMake(10, 10, 48, 48))
        descLabel = UILabel.init(frame: CGRectMake(68, 25, CGSSGlobal.width - 78, 18))
        descLabel.font = UIFont.systemFontOfSize(16)
        descLabel.textAlignment = .Left
        
//        let asView = UIImageView.init(frame: CGRectMake(0, 0, 10, 20))
//        asView.image = UIImage.init(named: "766-arrow-right-toolbar-selected")!.imageWithRenderingMode(.AlwaysTemplate)
//        asView.tintColor = UIColor.lightGrayColor()
//        self.accessoryView = asView
        self.accessoryType = .DisclosureIndicator
        
        contentView.addSubview(icon)
        contentView.addSubview(descLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

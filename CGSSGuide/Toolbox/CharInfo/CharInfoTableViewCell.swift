//
//  CharInfoTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CharInfoTableViewCell: UITableViewCell {
    
    var charIconView: CGSSCharIconView!
    var kanaSpacedLabel: UILabel!
    var charNameLabel: UILabel!
    var charCVLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func prepare() {
        
        charIconView = CGSSCharIconView(frame: CGRectMake(10, 10, 48, 48))
        kanaSpacedLabel = UILabel.init(frame: CGRectMake(68, 10, CGSSGlobal.width - 78, 10))
        kanaSpacedLabel.font = UIFont.systemFontOfSize(10)
        
        charNameLabel = UILabel()
        charNameLabel.frame = CGRectMake(68, 25, CGSSGlobal.width - 78, 16)
        charNameLabel.font = UIFont.systemFontOfSize(16)
        charNameLabel.adjustsFontSizeToFitWidth = true
        
        charCVLabel = UILabel.init(frame: CGRectMake(68, 46, CGSSGlobal.width - 78, 12))
        charCVLabel.font = UIFont.systemFontOfSize(12)
        
        contentView.addSubview(kanaSpacedLabel)
        contentView.addSubview(charNameLabel)
        contentView.addSubview(charCVLabel)
        contentView.addSubview(charIconView)
    }
    
    func setup(char: CGSSChar) {
        charNameLabel.text = "\(char.kanjiSpaced)  \(char.conventional)"
        if char.voice == "" {
            charCVLabel.text = "CV: 未付声"
        } else {
            charCVLabel.text = "CV: \(char.voice)"
        }
        charIconView.setWithCharId(char.charaId)
        kanaSpacedLabel.text = "\(char.kanaSpaced)"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

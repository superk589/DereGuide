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
    
    fileprivate func prepare() {
        
        charIconView = CGSSCharIconView(frame: CGRect(x: 10, y: 10, width: 48, height: 48))
        charIconView.isUserInteractionEnabled = false
        kanaSpacedLabel = UILabel.init(frame: CGRect(x: 68, y: 10, width: CGSSGlobal.width - 78, height: 10))
        kanaSpacedLabel.font = UIFont.systemFont(ofSize: 10)
        
        charNameLabel = UILabel()
        charNameLabel.frame = CGRect(x: 68, y: 25, width: CGSSGlobal.width - 78, height: 16)
        charNameLabel.font = UIFont.systemFont(ofSize: 16)
        charNameLabel.adjustsFontSizeToFitWidth = true
        charNameLabel.baselineAdjustment = .alignCenters
        
        charCVLabel = UILabel.init(frame: CGRect(x: 68, y: 46, width: CGSSGlobal.width - 78, height: 12))
        charCVLabel.font = UIFont.systemFont(ofSize: 12)
        
        contentView.addSubview(kanaSpacedLabel)
        contentView.addSubview(charNameLabel)
        contentView.addSubview(charCVLabel)
        contentView.addSubview(charIconView)
    }
    
    func setup(_ char: CGSSChar) {
        charNameLabel.text = "\(char.kanjiSpaced!)  \(char.conventional!)"
        if char.voice == "" {
            charCVLabel.text = "CV: \(NSLocalizedString("未付声", comment: "角色信息页面"))"
        } else {
            charCVLabel.text = "CV: \(char.voice!)"
        }
        charIconView.charId = char.charaId
        kanaSpacedLabel.text = "\(char.kanaSpaced!)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

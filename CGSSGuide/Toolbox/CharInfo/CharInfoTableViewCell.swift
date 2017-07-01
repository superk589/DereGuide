//
//  CharInfoTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CharInfoTableViewCell: UITableViewCell {
    
    var iconView: CGSSCharIconView!
    var kanaSpacedLabel: UILabel!
    var nameLabel: UILabel!
    var cvLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func prepare() {
        
        iconView = CGSSCharIconView() // frame: CGRect(x: 10, y: 10, width: 48, height: 48))
        iconView.isUserInteractionEnabled = false
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.height.width.equalTo(48)
            make.bottom.equalTo(-10)
        }
        
        kanaSpacedLabel = UILabel() //.init(frame: CGRect(x: 68, y: 10, width: CGSSGlobal.width - 78, height: 10))
        kanaSpacedLabel.font = UIFont.systemFont(ofSize: 10)
        contentView.addSubview(kanaSpacedLabel)
        kanaSpacedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalTo(9)
            make.right.lessThanOrEqualTo(-10)
        }
        
        nameLabel = UILabel()
//        charNameLabel.frame = CGRect(x: 68, y: 25, width: CGSSGlobal.width - 78, height: 16)
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(-10)
            make.top.equalTo(kanaSpacedLabel.snp.bottom).offset(3)
        }
        
        cvLabel = UILabel() // .init(frame: CGRect(x: 68, y: 46, width: CGSSGlobal.width - 78, height: 12))
        cvLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(cvLabel)
        cvLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.lastBaseline.equalTo(iconView.snp.bottom)
        }
    }
    
    func setup(_ char: CGSSChar) {
        nameLabel.text = "\(char.kanjiSpaced!)  \(char.conventional!)"
        if char.voice == "" {
            cvLabel.text = "CV: \(NSLocalizedString("未付声", comment: "角色信息页面"))"
        } else {
            cvLabel.text = "CV: \(char.voice!)"
        }
        iconView.charId = char.charaId
        kanaSpacedLabel.text = "\(char.kanaSpaced!)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

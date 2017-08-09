//
//  ColleagueBaseCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class ColleagueBaseCell: UITableViewCell {

    var leftLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        leftLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(leftLabel)
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
        }
    }
    
    func setTitle(_ title: String) {
        self.leftLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

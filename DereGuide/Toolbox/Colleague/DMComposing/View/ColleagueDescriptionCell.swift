//
//  ColleagueDescriptionCell.swift
//  DereGuide
//
//  Created by zzk on 01/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class ColleagueDescriptionCell: ColleagueBaseCell {

    let rightLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.snp.remakeConstraints { (remake) in
            remake.left.equalTo(10)
            remake.centerY.equalToSuperview()
        }
        
        rightLabel.font = UIFont.systemFont(ofSize: 16)
        rightLabel.textColor = UIColor.darkGray
        contentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(leftLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(detail: String) {
        rightLabel.text = detail
    }
}

//
//  ColleagueFilterCardCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/15.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class ColleagueFilterCardCell: UITableViewCell {

    let cardIcon = CGSSCardIconView()
    
    let leftLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(cardIcon)
        cardIcon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
            make.bottom.equalTo(-10)
        }
        cardIcon.isUserInteractionEnabled = false
        
        contentView.addSubview(leftLabel)
        leftLabel.font = .systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("添加一名偶像", comment: "")
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
        }
        leftLabel.textColor = .darkGray
        
        accessoryType = .disclosureIndicator
    }
    
    func setup(cardID: Int) {
        cardIcon.cardID = cardID
        leftLabel.isHidden = true
    }
    
    func setupWithoutCard() {
        cardIcon.image = nil
        leftLabel.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

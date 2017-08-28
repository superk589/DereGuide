//
//  ColleagueFilterCardCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ColleagueFilterCardCell: UITableViewCell {

    var cardIcon: CGSSCardIconView!
//    var cardNameLabel: UILabel!
    
    var leftLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardIcon = CGSSCardIconView()
        contentView.addSubview(cardIcon)
        cardIcon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
        }
        cardIcon.isUserInteractionEnabled = false
        
//        cardNameLabel = UILabel()
//        contentView.addSubview(cardNameLabel)
//        cardNameLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(cardIcon.snp.right).offset(10)
//            make.centerY.equalTo(cardIcon)
//        }
//        cardNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        leftLabel = UILabel()
        contentView.addSubview(leftLabel)
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("添加一名偶像", comment: "")
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        leftLabel.textColor = UIColor.darkGray
        
        accessoryType = .disclosureIndicator
    }
    
    func setup(cardID: Int) {
        cardIcon.cardId = cardID
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

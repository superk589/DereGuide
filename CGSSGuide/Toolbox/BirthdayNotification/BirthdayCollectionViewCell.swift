//
//  BirthdayCollectionViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol BirthdayCollectionViewCellDelegate: class {
    func charIconClick(icon: CGSSCharIconView)
}

class BirthdayCollectionViewCell: UICollectionViewCell {
    var charIcon: CGSSCharIconView!
    var desc: UILabel!
    weak var delegate: BirthdayCollectionViewCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        charIcon = CGSSCharIconView.init(frame: CGRectMake(10, 10, 48, 48))
        charIcon.delegate = self
        desc = UILabel.init(frame: CGRectMake(10, 63, 48, 16))
        desc.font = UIFont.systemFontOfSize(14)
        desc.textColor = UIColor.darkGrayColor()
        desc.textAlignment = .Center
        contentView.addSubview(charIcon)
        contentView.addSubview(desc)
    }
    
    func initWithChar(char: CGSSChar) {
        charIcon.setWithCharId(char.charaId!)
        desc.text = "\(char.birthMonth!)-\(char.birthDay!)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BirthdayCollectionViewCell: CGSSIconViewDelegate {
    func iconClick(iv: CGSSIconView) {
        delegate?.charIconClick(iv as! CGSSCharIconView)
    }
}

//
//  BirthdayCollectionViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol BirthdayCollectionViewCellDelegate: class {
    func charIconClick(_ icon: CGSSCharIconView)
}

class BirthdayCollectionViewCell: UICollectionViewCell {
    var charIcon: CGSSCharIconView!
    var desc: UILabel!
    weak var delegate: BirthdayCollectionViewCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        charIcon = CGSSCharIconView.init(frame: CGRect(x: 10, y: 10, width: 48, height: 48))
        charIcon.delegate = self
        desc = UILabel.init(frame: CGRect(x: 10, y: 63, width: 48, height: 16))
        desc.font = UIFont.systemFont(ofSize: 14)
        desc.textColor = UIColor.darkGray
        desc.textAlignment = .center
        contentView.addSubview(charIcon)
        contentView.addSubview(desc)
    }
    
    func initWithChar(_ char: CGSSChar) {
        charIcon.charId = char.charaId
        desc.text = "\(char.birthMonth!)-\(char.birthDay!)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BirthdayCollectionViewCell: CGSSIconViewDelegate {
    func iconClick(_ iv: CGSSIconView) {
        delegate?.charIconClick(iv as! CGSSCharIconView)
    }
}

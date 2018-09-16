//
//  ColleagueMessageCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class ColleagueMessageCell: ColleagueBaseCell {

    var messageView = UITextView()
    
    var countLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(messageView)
        contentView.addSubview(countLabel)
        
        messageView.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.equalTo(85)
        }
        messageView.delegate = self
        messageView.font = UIFont.systemFont(ofSize: 14)
        messageView.layer.borderColor = UIColor.lightGray.cgColor
        messageView.layer.borderWidth = 1 / Screen.scale
        messageView.layer.cornerRadius = 6
        messageView.layer.masksToBounds = true
        
        countLabel.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(-15)
        }
        countLabel.isUserInteractionEnabled = false
        countLabel.textColor = UIColor.lightGray
        countLabel.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    func setup(with message: String) {
        messageView.text = message
        countLabel.text = String(Config.maxCharactersOfMessage - messageView.text.count)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ColleagueMessageCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= Config.maxCharactersOfMessage
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = String(Config.maxCharactersOfMessage - textView.text.count)
    }
}

//
//  DonationQAView.swift
//  DereGuide
//
//  Created by zzk on 2017/1/3.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class DonationQAView: UIView {

    let questionLabel = UILabel()
    let answerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.equalTo(16)
        }
        questionLabel.font = .systemFont(ofSize: 14)
        
        addSubview(answerLabel)
        answerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(questionLabel)
            make.right.equalToSuperview()
            make.top.equalTo(questionLabel.snp.bottom).offset(6)
        }
        answerLabel.textColor = .darkGray
        answerLabel.font = .systemFont(ofSize: 12)
        answerLabel.numberOfLines = 0
        
        let line = UIView()
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(questionLabel)
            make.right.equalToSuperview()
            make.top.equalTo(answerLabel.snp.bottom).offset(10)
            make.height.equalTo(1 / Screen.scale)
            make.bottom.equalToSuperview()
        }
        line.backgroundColor = .lightGray
    }
    
    func setup(question: String, answer:String) {
        questionLabel.text = question
        answerLabel.text = answer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

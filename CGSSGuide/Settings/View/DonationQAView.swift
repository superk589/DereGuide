//
//  DonationQAView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/3.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class DonationQAView: UIView {

    var questionLabel: UILabel!
    var answerLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        questionLabel = UILabel()
        addSubview(questionLabel)
        questionLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.equalTo(16)
        }
        questionLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        answerLabel = UILabel()
        addSubview(answerLabel)
        answerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(questionLabel)
            make.right.equalToSuperview()
            make.top.equalTo(questionLabel.snp.bottom).offset(6)
        }
        answerLabel.textColor = UIColor.darkGray
        answerLabel.font = UIFont.systemFont(ofSize: 12)
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
        line.backgroundColor = UIColor.lightGray
        
    }
    
    
    func setup(question: String, answer:String) {
        self.questionLabel.text = question
        self.answerLabel.text = answer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

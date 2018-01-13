//
//  DonationCell.swift
//  DereGuide
//
//  Created by zzk on 2017/1/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class DonationCell: UICollectionViewCell {
    
    var borderView: UIView!
    
    var descLabel: UILabel!
    
    var amountLabel: UILabel!
    
    var borderColor: CGColor? {
        set {
            self.borderView.layer.borderColor = newValue
        }
        get {
            return self.borderView.layer.borderColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        borderView = UIView()
        contentView.addSubview(borderView)
        borderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 1, bottom: 10, right: 1))
        }
        borderView.layer.borderWidth = 1 / Screen.scale
        borderView.layer.cornerRadius = 10
        borderView.layer.masksToBounds = true
        
        amountLabel = UILabel()
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        amountLabel.font = UIFont.systemFont(ofSize: 16)
        
        descLabel = UILabel()
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.centerX.equalToSuperview()
        }
        descLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func setup(amount:String, desc:String) {
        self.amountLabel.text = amount
        self.descLabel.text = desc
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

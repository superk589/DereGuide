//
//  DonationCell.swift
//  DereGuide
//
//  Created by zzk on 2017/1/4.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class DonationCell: UICollectionViewCell {
    
    let borderView = UIView()
    
    let descLabel = UILabel()
    
    let amountLabel = UILabel()
    
    var borderColor: CGColor? {
        set {
            borderView.layer.borderColor = newValue
        }
        get {
            return borderView.layer.borderColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(borderView)
        borderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 1, bottom: 10, right: 1))
        }
        borderView.layer.borderWidth = 1 / Screen.scale
        borderView.layer.cornerRadius = 10
        borderView.layer.masksToBounds = true
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        amountLabel.font = .systemFont(ofSize: 16)
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.centerX.equalToSuperview()
        }
        descLabel.font = .systemFont(ofSize: 14)
    }
    
    func setup(amount: String, desc: String) {
        amountLabel.text = amount
        descLabel.text = desc
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

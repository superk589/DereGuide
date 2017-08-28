//
//  UnitTemplateCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/12.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitTemplateCell: UnitTableViewCell {
    
    var titleLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
        }
        
        iconStackView.snp.remakeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.greaterThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-10)
            // make the view as wide as possible
            make.right.equalTo(-10).priority(900)
            make.left.equalTo(10).priority(900)
            //
            make.bottom.equalTo(-10)
            make.width.lessThanOrEqualTo(96 * 6 + 25)
            make.centerX.equalToSuperview()
        })
        
        accessoryType = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with name: String, unit: Unit) {
        titleLabel.text = name
        super.setup(with: unit)
    }
}

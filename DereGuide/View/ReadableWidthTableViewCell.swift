//
//  ReadableWidthTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ReadableWidthTableViewCell: UITableViewCell {
    
    var readableContentView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    func prepare() {
        readableContentView = UIView()
        contentView.addSubview(readableContentView)
        readableContentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(768)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.left.equalToSuperview().priority(900)
            make.right.equalToSuperview().priority(900)
            make.centerX.equalToSuperview()
        }
        let line = LineView()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(readableContentView)
            make.bottom.equalToSuperview()
        }
    }
    
}


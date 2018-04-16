//
//  ReadableWidthTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/17.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class ReadableWidthTableViewCell: UITableViewCell {
    
    let readableContentView = UIView()
    
    var maxReadableWidth: CGFloat {
        return 768
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    private func prepare() {
        contentView.addSubview(readableContentView)
        readableContentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(maxReadableWidth)
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

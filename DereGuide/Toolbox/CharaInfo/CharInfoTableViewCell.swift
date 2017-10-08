//
//  CharInfoTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CharInfoTableViewCell: UITableViewCell {
    
    var charView: CharView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    private func prepare() {
        charView = CharView()
        contentView.addSubview(charView)
        charView.snp.makeConstraints { (make) in
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
            make.left.right.equalTo(charView)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupWith(char: CGSSChar, sorter: CGSSSorter) {
        charView.setupWith(char: char, sorter: sorter)
    }

}

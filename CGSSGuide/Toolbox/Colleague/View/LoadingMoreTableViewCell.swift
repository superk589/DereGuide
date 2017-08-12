//
//  LoadingMoreTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class LoadingMoreTableViewCell: UITableViewCell {

    var indicator: UIActivityIndicatorView!
    var label: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        label = UILabel()
        label.text = NSLocalizedString("正在加载更多", comment: "")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(10)
        }
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.top.equalTo(5)
            make.right.equalTo(label.snp.left).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  GachaDetailLoadingCell.swift
//  DereGuide
//
//  Created by zzk on 19/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class GachaDetailLoadingCell: UITableViewCell {
    
    let leftLabel = UILabel()
    
    let loadingView = LoadingView()
    
    weak var delegate: LoadingViewDelegate? {
        didSet {
            loadingView.delegate = delegate
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("模拟抽卡", comment: "")
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        contentView.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(8)
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
            make.bottom.equalTo(-20)
        }
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

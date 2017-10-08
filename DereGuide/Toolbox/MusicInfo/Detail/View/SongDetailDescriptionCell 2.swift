//
//  SongDetailDescriptionCell.swift
//  DereGuide
//
//  Created by zzk on 28/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class SongDetailDescriptionCell: ReadableWidthTableViewCell {

    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        readableContentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
            make.top.equalTo(10)
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
    }
    
    func setup(text: String) {
        label.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

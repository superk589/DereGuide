//
//  SongDetailHeaderCell.swift
//  DereGuide
//
//  Created by zzk on 28/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class SongDetailHeaderCell: ReadableWidthTableViewCell {

    let nameLabel = UILabel()
    
    let typeIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        readableContentView.addSubview(typeIcon)
        typeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        readableContentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.lessThanOrEqualTo(10)
            make.top.equalTo(typeIcon.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        
    }
    
    func setup(song: CGSSSong) {
        typeIcon.image = song.icon
        nameLabel.text = song.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

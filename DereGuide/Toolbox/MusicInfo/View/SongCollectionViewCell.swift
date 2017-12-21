//
//  SongCollectionViewCell.swift
//  DereGuide
//
//  Created by zzk on 04/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class SongCollectionViewCell: UICollectionViewCell {
    
    let jacketImageView = BannerView()
    
    let nameLabel = UILabel()
    
    let typeIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(jacketImageView)
        jacketImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(132)
            make.width.equalTo(132)
        }
        
        contentView.addSubview(typeIcon)
        typeIcon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(jacketImageView.snp.bottom).offset(10)
            make.height.width.equalTo(20)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(typeIcon.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
            make.left.greaterThanOrEqualTo(5)
            make.right.lessThanOrEqualTo(-5)
        }
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func setup(song: CGSSSong) {
        jacketImageView.sd_setImage(with: song.jacketURL)
        nameLabel.text = song.name
        nameLabel.textColor = song.color
        typeIcon.image = song.icon
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

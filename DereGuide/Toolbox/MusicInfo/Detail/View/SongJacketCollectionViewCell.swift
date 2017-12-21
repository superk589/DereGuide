//
//  SongJacketCollectionViewCell.swift
//  DereGuide
//
//  Created by zzk on 01/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class SongJacketCollectionViewCell: UICollectionViewCell {
    
    let jacketImageView = BannerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(jacketImageView)
        jacketImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(132)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(song: CGSSSong) {
        jacketImageView.sd_setImage(with: song.jacketURL)
    }
    
}

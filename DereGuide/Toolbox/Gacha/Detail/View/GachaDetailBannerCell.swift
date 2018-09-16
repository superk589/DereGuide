//
//  GachaDetailBannerCell.swift
//  DereGuide
//
//  Created by zzk on 18/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class GachaDetailBannerCell: UITableViewCell {

    let banner = BannerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.greaterThanOrEqualTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.center.equalToSuperview()
            make.width.equalTo(banner.snp.height).multipliedBy(824.0 / 212.0)
        }
        
        selectionStyle = .none
    }
    
    func setup(bannerURL: URL) {
        banner.sd_setImage(with: bannerURL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

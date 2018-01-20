//
//  GachaDetailBannerCell.swift
//  DereGuide
//
//  Created by zzk on 18/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class GachaDetailBannerCell: ReadableWidthTableViewCell {

    let banner = BannerView()
    
    override var maxReadableWidth: CGFloat {
        return 824
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        readableContentView.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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

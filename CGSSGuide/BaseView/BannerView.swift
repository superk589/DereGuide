//
//  BannerView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class BannerView: UIImageView {

    var indicator: UIActivityIndicatorView?
    
    override func sd_setImage(with url: URL!) {
        indicator = UIActivityIndicatorView.init()
        indicator?.tintColor = UIColor.lightGray
        addSubview(indicator!)
        indicator?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
        indicator?.startAnimating()
        sd_setImage(with: url) { [weak indicator = self.indicator] (image, error, cacheType, url) in
            indicator?.stopAnimating()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

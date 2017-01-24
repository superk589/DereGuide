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

// 用于SDWebImage加载时显示Indicator的ImageView
class BannerView: UIImageView {

    var indicator: UIActivityIndicatorView?
    
    override func sd_setImage(with url: URL!) {
        showIndicator()
        super.sd_setImage(with: url) { [weak indicator = self.indicator] (image, error, cacheType, url) in
            indicator?.stopAnimating()
        }
    }
    
    private func showIndicator() {
        indicator = UIActivityIndicatorView.init()
        indicator?.activityIndicatorViewStyle = .gray
        addSubview(indicator!)
        indicator?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
        indicator?.startAnimating()
        
    }
    override func sd_setImage(with url: URL!, completed completedBlock: SDWebImageCompletionBlock!) {
        showIndicator()
        super.sd_setImage(with: url) { [weak indicator = self.indicator] (image, error, cacheType, url) in
            indicator?.stopAnimating()
            completedBlock(image, error, cacheType, url)
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

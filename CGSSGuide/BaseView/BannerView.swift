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

enum BannerLoadingStyle {
    case system
    case custom
}

// 用于SDWebImage加载时显示Indicator的ImageView
class BannerView: UIImageView {
    
    var style: BannerLoadingStyle = .system
    
    var indicator: UIActivityIndicatorView?
    
    var indicator2: LoadingImageView?
    
    override func sd_setImage(with url: URL!) {
        showIndicator()
        super.sd_setImage(with: url) { [weak self] (image, error, cacheType, url) in
            self?.indicator?.stopAnimating()
            self?.indicator2?.stopAnimating()
        }
    }
    
    private func showIndicator() {
        if style == .system {
            indicator = UIActivityIndicatorView.init()
            indicator?.activityIndicatorViewStyle = .gray
            addSubview(indicator!)
            indicator?.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
            })
            indicator?.startAnimating()

        } else {
            indicator2 = LoadingImageView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            addSubview(indicator2!)
            indicator2?.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
                make.width.height.equalTo(50)
            })
            indicator2?.startAnimating()
            
        }
    }
    override func sd_setImage(with url: URL!, completed completedBlock: SDWebImageCompletionBlock!) {
        showIndicator()
        super.sd_setImage(with: url) { [weak self] (image, error, cacheType, url) in
            self?.indicator?.stopAnimating()
            self?.indicator2?.stopAnimating()
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

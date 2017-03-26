//
//  BannerView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SDWebImage

enum BannerLoadingStyle {
    case system
    case custom
}

// 用于SDWebImage加载时显示Indicator的ImageView
class BannerView: UIImageView {
    
    var style: BannerLoadingStyle = .system
    
    var indicator: UIActivityIndicatorView?
    
    var indicator2: LoadingImageView?
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            indicator?.startAnimating()

        } else {
            indicator2 = LoadingImageView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            addSubview(indicator2!)
            indicator2?.startAnimating()
        }
    }
    
    override func sd_setImage(with url: URL?, completed completedBlock: SDExternalCompletionBlock? = nil) {
        showIndicator()
        super.sd_setImage(with: url) { [weak self] (image, error, cacheType, url) in
            self?.indicator?.stopAnimating()
            self?.indicator2?.stopAnimating()
            completedBlock?(image, error, cacheType, url)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator?.center = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
        indicator2?.center = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
    }
}

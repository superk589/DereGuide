//
//  BannerView.swift
//  DereGuide
//
//  Created by zzk on 2017/5/24.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SDWebImage

// 用于SDWebImage加载时显示Indicator的ImageView
class BannerView: UIImageView {
    
    var indicator: UIActivityIndicatorView?
    
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
    
    private func createIndicatorIfNeeded() {
        if indicator == nil {
            indicator = UIActivityIndicatorView.init()
            indicator?.activityIndicatorViewStyle = .gray
            addSubview(indicator!)
        }
    }
    
    private func showIndicator() {
        createIndicatorIfNeeded()
        indicator?.startAnimating()
    }
    
    func setImage(with url: URL?, options: SDWebImageOptions) {
        showIndicator()
        sd_setImage(with: url, placeholderImage: nil, options: options) { [weak self] (image, error, cacheType, url) in
            self?.indicator?.stopAnimating()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator?.center = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
    }
}

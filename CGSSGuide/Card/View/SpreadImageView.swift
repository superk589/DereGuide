//
//  SpreadImageView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class SpreadImageView: UIImageView {
    
    var progressIndicator: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        backgroundColor = UIColor.black
    
        progressIndicator = UIProgressView()
        addSubview(progressIndicator)
        progressIndicator.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    private func hideIndicator() {
        progressIndicator.isHidden = true
    }
    
    private func showIndicator() {
        progressIndicator.isHidden = false
    }
    
    func setImage(with url: URL, shouldShowIndicator: Bool = true) {
        if shouldShowIndicator {
            showIndicator()
        }
        sd_setImage(with: url, placeholderImage: nil, options: [.retryFailed, .progressiveDownload], progress: { [weak self] (current, total, url) in
            DispatchQueue.main.async {
                self?.progressIndicator.progress = Float(current) / Float(total)
            }
        }) { (image, error, cacheType, url) in
            DispatchQueue.main.async {
                self.progressIndicator.progress = 1
                self.hideIndicator()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

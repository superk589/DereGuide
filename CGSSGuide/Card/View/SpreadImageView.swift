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
import ImageViewer

class SpreadImageView: UIImageView, UIGestureRecognizerDelegate, DisplaceableView {
    
    var progressIndicator: UIProgressView!
    
    var url: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        clipsToBounds = true
        backgroundColor = UIColor.black
    
        progressIndicator = UIProgressView()
        addSubview(progressIndicator)
        progressIndicator.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        doubleTap.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer is UITapGestureRecognizer
    }
    
    @objc func handleDoubleTap(_ tap: UITapGestureRecognizer) {
        if let url = self.url {
            if let key = SDWebImageManager.shared().cacheKey(for: url) {
                SDImageCache.shared().removeImage(forKey: key, withCompletion: {
                    self.setImage(with: url)
                })
            }
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func hideIndicator() {
        progressIndicator.isHidden = true
    }
    
    private func showIndicator() {
        progressIndicator.isHidden = false
    }
    
    func setImage(with url: URL, shouldShowIndicator: Bool = true) {
        
        self.url = url
        
        SDWebImageManager.shared().cachedImageExists(for: url) { [weak self] (isInCache) in
            if !UserDefaults.standard.shouldCacheFullImage && CGSSGlobal.isMobileNet() && !isInCache {
                return
            } else {
                if shouldShowIndicator {
                    self?.showIndicator()
                } else {
                    self?.hideIndicator()
                }
                self?.sd_setImage(with: url, placeholderImage: nil, options: [.retryFailed, .progressiveDownload], progress: { (current, total, url) in
                    DispatchQueue.main.async {
                        self?.progressIndicator.progress = Float(current) / Float(total)
                    }
                }) { (image, error, cacheType, url) in
                    DispatchQueue.main.async {
                        self?.progressIndicator.progress = 1
                        self?.hideIndicator()
                    }
                }
            }
        }
    }
}

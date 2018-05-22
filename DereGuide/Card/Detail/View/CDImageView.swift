//
//  CDImageView.swift
//  DereGuide
//
//  Created by zzk on 2018/5/22.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SDWebImage

class CDImageView: UIImageView {
    
    let indicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override var intrinsicContentSize: CGSize {
        if image == nil {
            return CGSize(width: CDImageTableViewCell.imageHeight * 3 / 2, height: CDImageTableViewCell.imageHeight)
        } else {
            return image!.size
        }
    }
    
    var url: URL?
    
    func configure(for url: URL, completion: (() -> Void)? = nil) {
        self.url = url
        indicator.startAnimating()
        sd_setImage(with: url, placeholderImage: nil, options: .scaleDownLargeImages) { [weak self] (image, error, _, _) in
            self?.indicator.stopAnimating()
            completion?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  WideLoadingButton.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/19.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class WideLoadingButton: WideButton {

    private(set) var isLoading = false
    var indicator: UIActivityIndicatorView!
    var normalTitle = "" {
        didSet {
            if !isLoading {
                setTitle(normalTitle, for: .normal)
            }
        }
    }
    
    var loadingTitle = "" {
        didSet {
            if isLoading {
                setTitle(loadingTitle, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.hidesWhenStopped = true
        addSubview(indicator)
        
        if titleLabel != nil {
            indicator.snp.makeConstraints { (make) in
                make.right.equalTo(titleLabel!.snp.left)
                make.centerY.equalToSuperview()
            }
        } else {
            indicator.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }
        indicator.isHidden = true
    }
    
    func setup(normalTitle: String, loadingTitle: String) {
        self.normalTitle = normalTitle
        self.loadingTitle = loadingTitle
    }
    
    func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
        if isLoading {
            isUserInteractionEnabled = false
            setTitle(loadingTitle, for: .normal)
            indicator.startAnimating()
            indicator.isHidden = false
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        } else {
            isUserInteractionEnabled = true
            setTitle(normalTitle, for: .normal)
            indicator.stopAnimating()
            titleEdgeInsets = .zero
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

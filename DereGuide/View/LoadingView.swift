//
//  LoadingView.swift
//  DereGuide
//
//  Created by zzk on 19/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

enum LoadingViewStatus {
    case loading
    case failed
}

protocol LoadingViewDelegate: class {
    func retry(loadingView: LoadingView)
}

class LoadingView: UIView {

    var status: LoadingViewStatus = .loading {
        didSet {
            if status == .loading {
                indicator.isHidden = false
                loadingLabel.isHidden = false
                retryButton.isHidden = true
                failureLabel.isHidden = true
                indicator.startAnimating()
            } else {
                indicator.isHidden = true
                loadingLabel.isHidden = true
                retryButton.isHidden = false
                failureLabel.isHidden = false
            }
        }
    }
    
    let indicator = LoadingImageView()
    
    let loadingLabel = UILabel()
    
    let retryButton = WideButton()
    
    let failureLabel = UILabel()
    
    weak var delegate: LoadingViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loadingLabel)
        loadingLabel.font = UIFont.systemFont(ofSize: 16)
        loadingLabel.textColor = .darkGray
        loadingLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(15)
        }
        loadingLabel.text = NSLocalizedString("获取数据中...", comment: "")
        
        addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(loadingLabel.snp.left)
        }
        indicator.startAnimating()
        
        addSubview(failureLabel)
        failureLabel.font = UIFont.systemFont(ofSize: 16)
        failureLabel.textColor = .darkGray
        failureLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-44)
        }
        failureLabel.text = NSLocalizedString("获取数据失败", comment: "")
        failureLabel.isHidden = true
        
        addSubview(retryButton)
        retryButton.snp.makeConstraints { (make) in
            make.left.equalTo(failureLabel.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        retryButton.backgroundColor = .vocal
        retryButton.setTitle(NSLocalizedString("重试", comment: ""), for: .normal)
        retryButton.isHidden = true
        retryButton.addTarget(self, action: #selector(retry), for: .touchUpInside)
    }
    
    @objc private func retry() {
        delegate?.retry(loadingView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

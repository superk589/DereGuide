//
//  UpdateStatusView.swift
//  DereGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol UpdateStatusViewDelegate: class {
    func cancelUpdate()
}

class UpdateStatusView: UIView {
    
    weak var delegate: UpdateStatusViewDelegate?
//    var progressView: UIProgressView!
    var statusLabel: UILabel!
//    var descriptionLabel: UILabel!
    // var activityIndicator: UIActivityIndicatorView!
    var loadingView: LoadingImageView!
    var cancelButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.layer.cornerRadius = 10
//        // self.layer.masksToBounds = true
//        progressView = UIProgressView()
//        progressView.progressTintColor = UIColor.clear
//        progressView.trackTintColor = UIColor.white
//        progressView.frame = CGRect(x: 0, y: frame.size.height - 2, width: frame.size.width, height: 0)
//        addSubview(progressView)
//        progressView.snp.makeConstraints { (make) in
//            make.
//        }
        
        loadingView = LoadingImageView()
        loadingView.hideWhenStopped = true
        addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        cancelButton = UIButton()
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cancelButton.setImage(UIImage.init(named: "433-x")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        cancelButton.tintColor = UIColor.white
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector(cancelUpdate), for: .touchUpInside)
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
            make.right.equalTo(-5)
        }
        
        statusLabel = UILabel()
        statusLabel.textColor = UIColor.white
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualTo(loadingView.snp.right)
            make.right.lessThanOrEqualTo(-5)
        }
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.boldSystemFont(ofSize: 17)
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.baselineAdjustment = .alignCenters
        
//        descriptionLabel = UILabel()
//        descriptionLabel.textColor = UIColor.white
//        descriptionLabel.frame = CGRect(x: 20, y: 0, width: frame.size.width - 40, height: frame.size.height / 2)
//        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        descriptionLabel.adjustsFontSizeToFitWidth = true
//        descriptionLabel.baselineAdjustment = .alignCenters
//        descriptionLabel.textAlignment = .center
        
        
//        wloadingView.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 4 * 3)
//        activityIndicator = UIActivityIndicatorView()
//        activityIndicator.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 4 * 3)
//        activityIndicator.hidesWhenStopped = true
        
        // self.addSubview(statusLabel)
        // self.addSubview(descriptionLabel)
        // 暂时取消进度条
        // self.addSubview(progressView)
        // self.addSubview(activityIndicator)
        // self.addSubview(loadingView)
        // self.addSubview(cancelButton)
    }
    
    func setContent(_ text: String, hasProgress: Bool = false ) {
        self.layer.removeAllAnimations()
        self.alpha = 1
        self.isHidden = false
        statusLabel.text = text
        loadingView.startAnimating()
//        if !hasProgress {
//            // activityIndicator.startAnimating()
//            loadingView.fx = (fwidth - loadingView.fwidth) / 2
//        } else {
//            loadingView.fx = 5
//            // activityIndicator.stopAnimating()
//            // loadingView.stopAnimating()
//        }
        // statusLabel.text = ""
        // statusLabel.isHidden = !hasProgress
//        progressView.isHidden = !hasProgress
    }
    
    func setContent(_ text: String, total: Int) {
        setContent(text, hasProgress: true)
        statusLabel.text = "0/\(total)"
    }
    
    func updateProgress(_ a: Int, b: Int) {
        self.layer.removeAllAnimations()
        self.alpha = 1
        statusLabel.isHidden = false
//        progressView.isHidden = false
        statusLabel.text = "\(a)/\(b)"
//        progressView.progress = Float(a) / Float(b)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelUpdate() {
        // activityIndicator.stopAnimating()
        loadingView.stopAnimating()
        self.isHidden = true
        delegate?.cancelUpdate()
    }
    
}

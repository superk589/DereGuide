//
//  UpdateStatusView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol UpdateStatusViewDelegate: class {
    func cancelUpdate()
}

class UpdateStatusView: UIView {
    weak var delegate: UpdateStatusViewDelegate?
    var progressView: UIProgressView!
    var statusLabel: UILabel!
    var descriptionLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    
    var cancelButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.layer.cornerRadius = 10
        // self.layer.masksToBounds = true
        progressView = UIProgressView()
        progressView.progressTintColor = UIColor.clear
        progressView.trackTintColor = UIColor.white
        progressView.frame = CGRect(x: 0, y: frame.size.height - 2, width: frame.size.width, height: 0)
        statusLabel = UILabel()
        statusLabel.textColor = UIColor.white
        statusLabel.frame = CGRect(x: 0, y: frame.size.height / 2, width: frame.size.width, height: frame.size.height / 2)
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.frame = CGRect(x: 20, y: 0, width: frame.size.width - 40, height: frame.size.height / 2)
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.textAlignment = .center
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 4 * 3)
        activityIndicator.hidesWhenStopped = true
        
        cancelButton = UIButton.init(frame: CGRect(x: frame.size.width - 20, y: 0, width: 20, height: 20))
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        cancelButton.setImage(UIImage.init(named: "433-x")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        cancelButton.tintColor = UIColor.white
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        // cancelButton.layer.borderColor = UIColor.whiteColor().CGColor
        // cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector(cancelUpdate), for: .touchUpInside)
        self.addSubview(statusLabel)
        self.addSubview(descriptionLabel)
        // 暂时取消进度条
        // self.addSubview(progressView)
        self.addSubview(activityIndicator)
        self.addSubview(cancelButton)
    }
    
    func setContent(_ s: String, hasProgress: Bool) {
        self.layer.removeAllAnimations()
        self.alpha = 1
        self.isHidden = false
        descriptionLabel.text = s
        if !hasProgress {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        statusLabel.text = ""
        statusLabel.isHidden = !hasProgress
        progressView.isHidden = !hasProgress
    }
    
    func setContent(_ s: String, total: Int) {
        setContent(s, hasProgress: true)
        statusLabel.text = "0/\(total)"
    }
    
    func updateProgress(_ a: Int, b: Int) {
        self.layer.removeAllAnimations()
        self.alpha = 1
        statusLabel.isHidden = false
        progressView.isHidden = false
        statusLabel.text = "\(a)/\(b)"
        progressView.progress = Float(a) / Float(b)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelUpdate() {
        activityIndicator.stopAnimating()
        self.isHidden = true
        delegate?.cancelUpdate()
    }
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}

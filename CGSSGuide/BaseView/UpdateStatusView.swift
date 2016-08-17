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
        self.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        self.layer.cornerRadius = 10
        // self.layer.masksToBounds = true
        progressView = UIProgressView()
        progressView.progressTintColor = UIColor.clearColor()
        progressView.trackTintColor = UIColor.whiteColor()
        progressView.frame = CGRectMake(0, frame.size.height - 2, frame.size.width, 0)
        statusLabel = UILabel()
        statusLabel.textColor = UIColor.whiteColor()
        statusLabel.frame = CGRectMake(0, frame.size.height / 2, frame.size.width, frame.size.height / 2)
        statusLabel.textAlignment = .Center
        statusLabel.font = UIFont.boldSystemFontOfSize(17)
        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height / 2)
        descriptionLabel.font = UIFont.boldSystemFontOfSize(17)
        descriptionLabel.textAlignment = .Center
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = CGPointMake(frame.size.width / 2, frame.size.height / 4 * 3)
        activityIndicator.hidesWhenStopped = true
        
        cancelButton = UIButton.init(frame: CGRectMake(frame.size.width - 20, 0, 20, 20))
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        cancelButton.setImage(UIImage.init(named: "433-x")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        cancelButton.tintColor = UIColor.whiteColor()
        cancelButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
        // cancelButton.layer.borderColor = UIColor.whiteColor().CGColor
        // cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector(cancelUpdate), forControlEvents: .TouchUpInside)
        self.addSubview(statusLabel)
        self.addSubview(descriptionLabel)
        // 暂时取消进度条
        // self.addSubview(progressView)
        self.addSubview(activityIndicator)
        self.addSubview(cancelButton)
    }
    
    func setContent(s: String, hasProgress: Bool) {
        self.hidden = false
        descriptionLabel.text = s
        if !hasProgress {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        statusLabel.text = ""
        statusLabel.hidden = !hasProgress
        progressView.hidden = !hasProgress
    }
    
    func setContent(s: String, total: Int) {
        setContent(s, hasProgress: true)
        statusLabel.text = "0/\(total)"
    }
    
    func updateProgress(a: Int, b: Int) {
        statusLabel.hidden = false
        progressView.hidden = false
        statusLabel.text = "\(a)/\(b)"
        progressView.progress = Float(a) / Float(b)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelUpdate() {
        activityIndicator.stopAnimating()
        self.hidden = true
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

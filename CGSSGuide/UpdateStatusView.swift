//
//  UpdateStatusView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class UpdateStatusView: UIView {

    var progressView: UIProgressView!
    var statusLabel: UILabel!
    var descriptionLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        progressView = UIProgressView()
        progressView.progressTintColor = UIColor.clearColor()
        progressView.trackTintColor = UIColor.whiteColor()
        progressView.frame = CGRectMake(0, frame.size.height - 2, frame.size.width, 0)
        statusLabel = UILabel()
        statusLabel.textColor = UIColor.whiteColor()
        statusLabel.frame = CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2)
        statusLabel.textAlignment = .Center
        statusLabel.font = UIFont.boldSystemFontOfSize(17)
        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2)
        descriptionLabel.font = UIFont.boldSystemFontOfSize(17)
        descriptionLabel.textAlignment = .Center
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = CGPointMake(frame.size.width/2, frame.size.height/4*3)
        activityIndicator.hidesWhenStopped = true
        
        self.addSubview(statusLabel)
        self.addSubview(descriptionLabel)
        //暂时取消进度条
        //self.addSubview(progressView)
        self.addSubview(activityIndicator)
    }
    
    func setContent(s:String, hasProgress:Bool) {
        self.hidden = false
        descriptionLabel.text = s
        if !hasProgress {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        statusLabel.hidden = !hasProgress
        progressView.hidden = !hasProgress
    }
    func updateProgress(a:Int, b:Int) {
        statusLabel.hidden = false
        progressView.hidden = false
        statusLabel.text = "\(a)/\(b)"
        progressView.progress = Float(a) / Float(b)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

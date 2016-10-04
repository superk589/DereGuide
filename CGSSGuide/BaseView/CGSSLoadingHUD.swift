//
//  CGSSLoadingHUD.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/3.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit


class CGSSLoadingHUD: UIView {

    var iv: UIImageView!
    var titleLable:UILabel!
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        self.isUserInteractionEnabled = true
        let contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 120))
        contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        contentView.center = self.center
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        self.addSubview(contentView)
        iv = UIImageView.init(frame: CGRect.init(x: 35, y: 20, width: 50, height: 50))
        titleLable = UILabel.init(frame: CGRect.init(x: 0, y: 75, width: 120, height: 25))
        titleLable.textAlignment = .center
        titleLable.adjustsFontSizeToFitWidth = true
        titleLable.text = NSLocalizedString("处理中...", comment: "耗时任务处理过程提示框")
        iv.image = UIImage.init(named: "loading")
        contentView.addSubview(iv)
        contentView.addSubview(titleLable)
        self.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func becomeActive() {
        if self.alpha == 1 {
            iv.layer.removeAnimation(forKey: "rotate")
            self.startAnimate()
        }
    }
    
    func startAnimate() {
        superview?.bringSubview(toFront: self)
        self.alpha = 1
        let rotateAni = CABasicAnimation.init(keyPath: "transform.rotation")
        rotateAni.fromValue = 0
        rotateAni.toValue = M_PI * 2
        rotateAni.duration = 4
        rotateAni.repeatCount = 1e50
        iv.layer.add(rotateAni, forKey: "rotate")
        
    }
    func stopAnimate() {
        self.alpha = 0
        iv.layer.removeAnimation(forKey: "rotate")
    }
    
    func setTitle(title:String) {
        self.titleLable.text = title
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

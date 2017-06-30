//
//  CGSSLoadingHUD.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/3.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class LoadingImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = #imageLiteral(resourceName: "loading")
        startAnimating()
    }
    
    var isRotating = false
    var hideWhenStopped = true
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimating() {
        if isRotating {
            return
        }
        let rotateAni = CABasicAnimation.init(keyPath: "transform.rotation")
        rotateAni.fromValue = 0
        rotateAni.toValue = .pi * 2.0
        rotateAni.duration = 2
        rotateAni.repeatCount = .infinity
        // make the animation not removed when the application returns to active
        rotateAni.isRemovedOnCompletion = false
        self.layer.add(rotateAni, forKey: "rotate")
        isRotating = true
        isHidden = false
    }
    
    override func stopAnimating() {
        super.stopAnimating()
        if hideWhenStopped {
            self.isHidden = true
        }
        self.layer.removeAnimation(forKey: "rotate")
        isRotating = false
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: 50, height: 50)
    }
    
    func show(to view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        startAnimating()
    }
    
    func hide() {
        self.removeFromSuperview()
    }

}


class CGSSLoadingHUD: UIView {

    var iv: LoadingImageView!
    var titleLable:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.isUserInteractionEnabled = true
        let contentView = UIView()
        contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        contentView.center = self.center
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-120)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        iv = LoadingImageView.init(frame: CGRect.init(x: 35, y: 20, width: 50, height: 50))
        titleLable = UILabel.init(frame: CGRect.init(x: 0, y: 75, width: 120, height: 25))
        titleLable.textAlignment = .center
        titleLable.adjustsFontSizeToFitWidth = true
        titleLable.baselineAdjustment = .alignCenters
        titleLable.font = UIFont.boldSystemFont(ofSize: 17)
        titleLable.textColor = UIColor.white
        titleLable.text = NSLocalizedString("处理中...", comment: "耗时任务处理过程提示框")
        iv.image = UIImage.init(named: "loading")
        contentView.addSubview(iv)
        contentView.addSubview(titleLable)
        self.alpha = 0
    }
    
    func setTitle(title:String) {
        self.titleLable.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CGSSLoadingHUDManager {
    
    static let `default` = CGSSLoadingHUDManager()
    var hud: CGSSLoadingHUD!

    // 小于0.1秒不显示
    var debouncer: Debouncer!
    
    private init () {
        hud = CGSSLoadingHUD()
        debouncer = Debouncer.init(interval: 0.1)
    }
    
    private lazy var showClosure: (() -> Void)? = { [unowned self] in
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self.hud)
        self.hud.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        for subview in window?.subviews ?? [UIView]() {
            if subview is UpdateStatusView {
                window?.bringSubview(toFront: subview)
            }
        }
        self.hud.alpha = 1
    }
    
    func show() {
        debouncer.callback = showClosure
        debouncer.call()
    }
    
    func hide() {
        debouncer.callback = nil
        hud.alpha = 0
        hud.removeFromSuperview()
    }
}

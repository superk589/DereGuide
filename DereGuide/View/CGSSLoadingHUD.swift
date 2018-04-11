//
//  CGSSLoadingHUD.swift
//  DereGuide
//
//  Created by zzk on 2016/10/3.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import SnapKit

class LoadingImageView: UIImageView {
    
    var isRotating = false
    var hideWhenStopped = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = #imageLiteral(resourceName: "loading")
        startAnimating()
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimating() {
        super.startAnimating()
        let rotateAni = CABasicAnimation.init(keyPath: "transform.rotation")
        rotateAni.fromValue = 0
        rotateAni.toValue = .pi * 2.0
        rotateAni.duration = 2
        rotateAni.repeatCount = .infinity
        // make the animation not removed when the application returns to active
        rotateAni.isRemovedOnCompletion = false
        layer.add(rotateAni, forKey: "rotate")
        isRotating = true
        isHidden = false
    }
    
    override func stopAnimating() {
        super.stopAnimating()
        if hideWhenStopped {
            isHidden = true
        }
        layer.removeAnimation(forKey: "rotate")
        isRotating = false
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func show(to view: UIView) {
        view.addSubview(self)
        snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        startAnimating()
    }
    
    func hide() {
        removeFromSuperview()
    }

}


class CGSSLoadingHUD: UIView {

    let imageView = LoadingImageView(frame: CGRect(x: 35, y: 20, width: 50, height: 50))
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 75, width: 120, height: 25))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        isUserInteractionEnabled = true
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = .white
        titleLabel.text = NSLocalizedString("处理中...", comment: "耗时任务处理过程提示框")
        imageView.image = #imageLiteral(resourceName: "loading")
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CGSSLoadingHUDManager {
    
    static let `default` = CGSSLoadingHUDManager()
    let hud = CGSSLoadingHUD()

    // 小于0.1秒不显示
    let debouncer = Debouncer(interval: 0.1)
    
    private init () {
        
    }
    
    private lazy var showClosure: (() -> Void)? = { [unowned self] in
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.hud)
            self.hud.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            for subview in window.subviews {
                if subview is UpdatingStatusView {
                    window.bringSubview(toFront: subview)
                }
            }
            self.hud.alpha = 1
        }
    }
    
    func show(text: String? = nil) {
        if let text = text {
            hud.titleLabel.text = text
        } else {
            hud.titleLabel.text = NSLocalizedString("处理中...", comment: "耗时任务处理过程提示框")
        }
        debouncer.callback = showClosure
        debouncer.call()
    }
    
    func hide() {
        debouncer.callback = nil
        hud.alpha = 0
        hud.removeFromSuperview()
    }
}

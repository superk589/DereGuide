//
//  UpdatingStatusView.swift
//  DereGuide
//
//  Created by zzk on 16/7/22.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol UpdatingStatusViewDelegate: class {
    func cancelUpdate(updateStatusView: UpdatingStatusView)
}

class UpdatingStatusView: UIView {
    
    weak var delegate: UpdatingStatusViewDelegate?
    let statusLabel = UILabel()
    private let loadingView = LoadingImageView()
    let cancelButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        layer.cornerRadius = 10
        
        loadingView.hideWhenStopped = true
        addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cancelButton.setImage(#imageLiteral(resourceName: "433-x").withRenderingMode(.alwaysTemplate), for: UIControlState())
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        cancelButton.addTarget(self, action: #selector(cancelUpdate), for: .touchUpInside)
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
            make.right.equalTo(-5)
        }
        
        statusLabel.textColor = .white
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(loadingView.snp.right)
            make.right.equalTo(cancelButton.snp.left)
        }
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.boldSystemFont(ofSize: 17)
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.baselineAdjustment = .alignCenters
    }
    
    private var isShowing = false
    
    func show() {
        isShowing = true
        stopFading()
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self)
            snp.remakeConstraints { (make) in
                make.width.equalTo(240)
                make.height.equalTo(50)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-95)
            }
        }
    }
    
    func hide(animated: Bool) {
        isShowing = false
        stopAnimating()
        cancelButton.isHidden = true
        if animated {
            layer.removeAllAnimations()
            UIView.animate(withDuration: 2.5, animations: { [weak self] in
                self?.alpha = 0
            }) { [weak self] (finished) in
                self?.alpha = 1
                if let strongSelf = self, !strongSelf.isShowing {
                    self?.removeFromSuperview()
                }
            }
        } else {
            removeFromSuperview()
        }
    }
    
    private var isAnimating = false
    
    private func startAnimating() {
        isAnimating = true
        loadingView.startAnimating()
    }
    
    private func stopAnimating() {
        isAnimating = false
        loadingView.stopAnimating()
    }
    
    private func stopFading() {
        layer.removeAllAnimations()
    }
    
    func setup(_ text: String, animated: Bool, cancelable: Bool) {
        if animated && !isAnimating {
            startAnimating()
        }
        statusLabel.text = text
        cancelButton.isHidden = !cancelable
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelUpdate() {
        stopAnimating()
        hide(animated: false)
        delegate?.cancelUpdate(updateStatusView: self)
    }
    
}

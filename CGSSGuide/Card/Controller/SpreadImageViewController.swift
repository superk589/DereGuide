//
//  SpreadImageViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class SpreadImageViewController: UIViewController {
    
    var imageView = SpreadImageView(frame: CGRect.zero)
    
    var imageURL: URL!
    
    private var statusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statusBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate var customPresentAnimator: SpreadImageViewAnimator = SpreadImageViewAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        transitioningDelegate = self
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.backgroundColor = UIColor.clear
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(_:)))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.setImage(with: imageURL, shouldShowIndicator: false)
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPressGesture(_:)))
        imageView.addGestureRecognizer(longPress)
    }
        
    func handleTapGesture(_ tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func handleLongPressGesture(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            if let image = imageView.image {
                // 作为被分享的内容 不能是可选类型 否则分享项不显示
                let urlArray = [image]
                let location = longPress.location(in: imageView)
                let activityVC = UIActivityViewController.init(activityItems: urlArray, applicationActivities: nil)
                let excludeActivitys:[UIActivityType] = []
                activityVC.excludedActivityTypes = excludeActivitys
                activityVC.popoverPresentationController?.sourceView = imageView
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: location.x, y: location.y, width: 0, height: 0)
                // 呈现分享界面
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}

extension SpreadImageViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let vc = source as? CardDetailViewController {
            customPresentAnimator.sourceImageView = vc.spreadImageView
            customPresentAnimator.sourceNavigationController = vc.navigationController
        }
        customPresentAnimator.animatorType = . present
        return customPresentAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customPresentAnimator.animatorType = .dismiss
        return customPresentAnimator
    }
}

extension SpreadImageViewController: Transitionable {
    var transitionViews: [String : UIView] {
        return ["spreadImageView": imageView]
    }
}

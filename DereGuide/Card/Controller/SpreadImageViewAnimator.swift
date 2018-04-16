//
//  SpreadImageViewAnimator.swift
//  DereGuide
//
//  Created by zzk on 2017/3/7.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class SpreadImageViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum AnimatorType {
        case present, dismiss
    }
    var sourceImageView: SpreadImageView!
    var sourceNavigationController: UINavigationController?
    
    var orientation: UIDeviceOrientation!
    var animatorType: AnimatorType = .present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if let isAnimated = transitionContext?.isAnimated {
            return isAnimated ? 0.35 : 0
        }
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if animatorType == .present {
            if let toViewController = transitionContext.viewController(forKey: .to) as? SpreadImageViewController, let toView = transitionContext.view(forKey: .to), let sourceImageFrame = sourceImageView.superview?.convert(sourceImageView.frame, to: toView) {
                
                sourceNavigationController?.view.insertSubview(toView, belowSubview: sourceNavigationController!.toolbar)
                
                toView.layoutIfNeeded()
                let imageView = toViewController.imageView
                
                let toFrame = toViewController.view.bounds
                sourceNavigationController?.setToolbarHidden(true, animated: true)
                sourceNavigationController?.setNavigationBarHidden(true, animated: true)
                sourceImageView.isHidden = true
                imageView.frame = sourceImageFrame
                
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
//                    if UIDevice.current.orientation.isPortrait {
//                        imageView.transform = imageView.transform.rotated(by: .pi / 2)
//                    }
                    imageView.frame = toFrame
                    toView.backgroundColor = .black
                }, completion: { [weak self] (finished) in
                    transitionContext.containerView.addSubview(toView)
                    self?.sourceImageView.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
        } else if animatorType == .dismiss {
            if let fromViewController = transitionContext.viewController(forKey: .from) as? SpreadImageViewController,
                let toViewController = transitionContext.viewController(forKey: .to),
                let fromView = transitionContext.view(forKey: .from),
                let toView = transitionContext.view(forKey: .to) {
                toViewController.beginAppearanceTransition(true, animated: false)
                toViewController.endAppearanceTransition()
                toView.layoutIfNeeded()
                transitionContext.containerView.insertSubview(toView, at: 0)
                sourceNavigationController?.view.insertSubview(fromView, belowSubview: sourceNavigationController!.navigationBar)
                let imageView = fromViewController.imageView
                sourceNavigationController?.setToolbarHidden(false, animated: true)
                sourceNavigationController?.setNavigationBarHidden(false, animated: true)
                imageView.isHidden = true
                let sourceImageFrame = sourceImageView.frame
                let destFrame = toView.convert(fromViewController.imageView.frame, to: sourceImageView.superview)
                sourceImageView.frame = destFrame
                fromView.backgroundColor = .clear
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                    [weak self] in
//                    if UIDevice.current.orientation.isPortrait {
//                        imageView.transform = imageView.transform.rotated(by: -.pi / 2)
//                    }
                    self?.sourceImageView.frame = sourceImageFrame
                    fromView.backgroundColor = UIColor.clear
                }, completion: { (finished) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}

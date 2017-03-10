//
//  SpreadImageViewAnimator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class SpreadImageViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum AnimatorType {
        case present, dismiss
    }
    var sourceImageView: SpreadImageView!
    var sourceNavigationController: UINavigationController?
    
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
                
                let imageView = toViewController.imageView
                
                imageView.frame = sourceImageFrame
                let toFrame = toViewController.view.bounds
                sourceNavigationController?.setToolbarHidden(true, animated: true)
                sourceNavigationController?.setNavigationBarHidden(true, animated: true)
                sourceImageView.isHidden = true
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
                    imageView.transform = imageView.transform.rotated(by: .pi / 2)
                    imageView.frame = toFrame
                    toView.backgroundColor = UIColor.black
                }, completion: { [weak self] (finished) in
                    transitionContext.containerView.addSubview(toView)
                    self?.sourceImageView.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
        } else if animatorType == .dismiss {
            if let fromViewController = transitionContext.viewController(forKey: .from) as? SpreadImageViewController,
                let fromView = transitionContext.view(forKey: .from),
                let sourceImageFrame = sourceImageView.superview?.convert(sourceImageView.frame, to: fromView),
                let toView = transitionContext.view(forKey: .to) {
                
                transitionContext.containerView.insertSubview(toView, at: 0)
                sourceNavigationController?.view.insertSubview(fromView, belowSubview: sourceNavigationController!.navigationBar)
                let imageView = fromViewController.imageView
                sourceNavigationController?.setToolbarHidden(false, animated: true)
                sourceNavigationController?.setNavigationBarHidden(false, animated: true)
                sourceImageView.isHidden = true
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
                    imageView.transform = imageView.transform.rotated(by: -.pi / 2)
                    imageView.frame = sourceImageFrame
                    fromView.backgroundColor = UIColor.clear
                }, completion: { [weak self] (finished) in
                    self?.sourceImageView.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}


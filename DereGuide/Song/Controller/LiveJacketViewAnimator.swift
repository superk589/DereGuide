//
//  LiveJacketViewAnimator.swift
//  DereGuide
//
//  Created by zzk on 2017/4/25.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class LiveJacketViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum AnimatorType {
        case pop, push
    }
    
    var sourceBannerView: BannerView!
    
    var animatorType: AnimatorType = .push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if let isAnimated = transitionContext?.isAnimated {
            return isAnimated ? 0.35 : 0
        }
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        var destBanner: BannerView?
        
        var destDetailViews = [UIView]()
        
        if animatorType == .push {
            
            if let toViewController = transitionContext.viewController(forKey: .to) as? EventDetailController {
                destBanner = toViewController.banner
                destDetailViews.append(toViewController.eventDetailView)
            } else if let toViewController = transitionContext.viewController(forKey: .to) as? GachaDetailController {
                destBanner = toViewController.banner
                destDetailViews.append(toViewController.gachaDetailView)
                destDetailViews.append(toViewController.simulationView)
            } else {
                if let toView = transitionContext.view(forKey: .to) {
                    transitionContext.containerView.addSubview(toView)
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }
            
            if let destBanner = destBanner,
                let toView = transitionContext.view(forKey: .to),
                let fromViewController = transitionContext.viewController(forKey: .from),
                let fromNavigationController = fromViewController.navigationController {
                
                fromNavigationController.view.insertSubview(toView, belowSubview: fromNavigationController.navigationBar)
                
                let sourceFrame = sourceBannerView.convert(sourceBannerView.bounds, to: destBanner.superview)
                
                toView.layoutIfNeeded()
                let destFrame = destBanner.frame
                destBanner.frame = sourceFrame
                destBanner.layoutIfNeeded()
                toView.backgroundColor = UIColor.clear
                
                for view in destDetailViews {
                    view.alpha = 0
                    view.transform.ty = 20
                }
                
                sourceBannerView.isHidden = true
                
                let duration = self.transitionDuration(using: transitionContext)
                
                UIView.animate(withDuration: duration * 3 / 4, delay: 0, options: UIViewAnimationOptions.init(rawValue: 0), animations: {
                    destBanner.frame = destFrame
                    toView.backgroundColor = UIColor.white
                    destBanner.layoutIfNeeded()
                }, completion: { (finished) in
                    
                })
                
                UIView.animate(withDuration: duration / 4, delay: duration * 3 / 4, options: .curveEaseOut, animations: {
                    for view in destDetailViews {
                        view.alpha = 1
                        view.transform.ty = 0
                    }
                }, completion: { [weak self] (finished) in
                    self?.sourceBannerView.isHidden = false
                    transitionContext.containerView.addSubview(toView)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
        } else if animatorType == .pop {
            
            if let fromViewController = transitionContext.viewController(forKey: .from) as? EventDetailController {
                destBanner = fromViewController.banner
                destDetailViews.append(fromViewController.eventDetailView)
            } else if let fromViewController = transitionContext.viewController(forKey: .from) as? GachaDetailController {
                destBanner = fromViewController.banner
                destDetailViews.append(fromViewController.gachaDetailView)
                destDetailViews.append(fromViewController.simulationView)
            } else {
                if let toView = transitionContext.view(forKey: .to) {
                    transitionContext.containerView.addSubview(toView)
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }
            
            if let toView = transitionContext.view(forKey: .to),
                let destBanner = destBanner,
                let fromView = transitionContext.view(forKey: .from) {
                
                transitionContext.containerView.insertSubview(toView, at: 0)
                
                let toFrame = sourceBannerView.convert(sourceBannerView.bounds, to: destBanner.superview)
                
                sourceBannerView.isHidden = true
                
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext) / 4, delay: 0, options: .curveEaseIn, animations: {
                    for view in destDetailViews {
                        view.alpha = 0
                        view.transform.ty = 20
                    }
                }, completion: nil)
                
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: self.transitionDuration(using: transitionContext) / 4, options: UIViewAnimationOptions.init(rawValue: 0), animations: {
                    destBanner.frame = toFrame
                    destBanner.layoutIfNeeded()
                    fromView.backgroundColor = UIColor.clear
                }, completion: { [weak self] (finished) in
                    self?.sourceBannerView.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}

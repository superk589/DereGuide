//
//  BannerViewAnimator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/9.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol BannerViewAnimatorProvider: class {
    var bannerViewAnimator: BannerViewAnimator { get set }
}

protocol BannerViewContainerViewController: class {
    var banner: BannerView! { get set }
}

class BannerViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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
                
                transitionContext.containerView.addSubview(toView)
                toView.layoutIfNeeded()
                let sourceFrame: CGRect
                if #available(iOS 11.0, *) {
                    var frame = sourceBannerView.convert(sourceBannerView.bounds, to: destBanner.superview)
                    frame.origin.y -= fromNavigationController.navigationBar.frame.maxY
                    sourceFrame = frame
                } else {
                    sourceFrame = sourceBannerView.convert(sourceBannerView.bounds, to: destBanner.superview)
                }
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
                
                // make sure the frame is the same if orientation changing occurred
                toView.frame = fromView.frame
                toView.layoutIfNeeded()
                
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

fileprivate func * (lhs: CGRect, rhs: CGFloat) -> CGRect {
    return CGRect.init(x: lhs.minX * rhs, y: lhs.minY * rhs, width: lhs.size.width * rhs, height: lhs.size.height * rhs)
}

fileprivate func + (lhs: CGRect, rhs: CGRect) -> CGRect {
    return CGRect.init(x: lhs.minX + rhs.minX, y: lhs.minY + rhs.minY, width: lhs.size.width + rhs.size.width, height: lhs.size.height + rhs.size.height)
}

class BannerViewInteractiveAnimator: NSObject, UIViewControllerInteractiveTransitioning {
    
    var destBanner: BannerView?
    
    var destDetailViews = [UIView]()
    
    var sourceBannerView: BannerView!
    
    var destFrame = CGRect.zero
    
    var sourceFrame = CGRect.zero
    
    var lastProgress: CGFloat = 0
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        if let fromViewController = transitionContext.viewController(forKey: .from) as? EventDetailController {
            destBanner = fromViewController.banner
            destDetailViews.append(fromViewController.eventDetailView)
        } else if let fromViewController = transitionContext.viewController(forKey: .from) as? GachaDetailController {
            destBanner = fromViewController.banner
            destDetailViews.append(fromViewController.gachaDetailView)
            destDetailViews.append(fromViewController.simulationView)
        }

        if let toViewController = transitionContext.viewController(forKey: .to) as? BannerViewAnimatorProvider {
            sourceBannerView = toViewController.bannerViewAnimator.sourceBannerView
        }
        
        if let toView = transitionContext.view(forKey: .to),
            let destBanner = destBanner,
            let fromView = transitionContext.view(forKey: .from) {
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            sourceFrame = destBanner.frame
            destFrame = sourceBannerView.convert(sourceBannerView.bounds, to: destBanner.superview)
            sourceBannerView.isHidden = true
        }
        
        self.transitionContext = transitionContext
    }
    
    func update(_ progress: CGFloat) {
        
        let progress1 = max(min(progress / 0.25, 1), 0)
        let progress2 = max(min((progress - 0.25) / 0.75, 1), 0)
        
        let frame = destFrame * progress2 + sourceFrame * (1 - progress2)
        
        destBanner?.frame = frame
        destBanner?.layoutIfNeeded()
        
        for view in destDetailViews {
            view.alpha = 1 - progress1
            view.transform.ty = 20 * progress1
        }
    
        transitionContext?.view(forKey: .from)?.backgroundColor = UIColor.white.withAlphaComponent(1 - progress2)
    }
    
    func finish() {
        UIView.animate(withDuration: 0.35 * (1 - Double(lastProgress)), animations: { [weak self] in
            self?.update(1)
        }) { [weak self] (finished) in
            self?.sourceBannerView.isHidden = false
            self?.transitionContext?.finishInteractiveTransition()
            self?.transitionContext?.completeTransition(true)
        }
    }
    
    func cancel() {
        UIView.animate(withDuration: 0.35 * (1 - Double(lastProgress)), animations: { [weak self] in
            self?.update(0)
        }) { [weak self] (finished) in
            self?.sourceBannerView.isHidden = false
            self?.transitionContext?.cancelInteractiveTransition()
            self?.transitionContext?.completeTransition(false)
        }
    }
    
}


//
//  BannerViewAnimator.swift
//  DereGuide
//
//  Created by zzk on 2017/3/9.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func distance(to point: CGPoint) -> CGFloat {
        let deltaX = x - point.x
        let deltaY = y - point.y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
    
}

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
}

protocol BannerAnimatorProvider: class {
    var bannerAnimator: BannerAnimator { get set }
}

protocol BannerContainer: class {
    var bannerView: BannerView? { get }
    var otherView: UIView? { get }
}

extension BannerContainer {
    
    var otherView: UIView? {
        return nil
    }
    
}

class BannerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum AnimatorType {
        case pop, push
    }
    
    var animatorType: AnimatorType = .push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if let isAnimated = transitionContext?.isAnimated {
            return isAnimated ? 0.35 : 0
        }
        return 0
    }
    
    var pushUpDuration: TimeInterval = 0.1
    func durationByDistance(_ distance: CGFloat) -> TimeInterval {
        return max(0.3, TimeInterval(distance / 150 * 0.1)) - pushUpDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        var destOtherView: UIView?
        
        var sourceJacketImageView: BannerView!
        
        var tempView: BannerView!
        
        if animatorType == .push {
            
            if let toViewController = transitionContext.viewController(forKey: .to) as? BannerContainer,
                let fromViewController = transitionContext.viewController(forKey: .from) as? (BannerContainer & UIViewController),
                let sourceView = fromViewController.bannerView,
                let toView = transitionContext.view(forKey: .to),
                let fromNavigationController = fromViewController.navigationController,
                let destJacketImageView = toViewController.bannerView {
                destOtherView = toViewController.otherView
                sourceJacketImageView = sourceView
                tempView = BannerView()
                tempView.sd_setImage(with: sourceJacketImageView.url)
                
                fromNavigationController.view.insertSubview(toView, belowSubview: fromNavigationController.navigationBar)
                
                let transparentView = UIView(frame: transitionContext.containerView.bounds)
                transitionContext.containerView.addSubview(transparentView)
                transitionContext.containerView.addSubview(toView)
                toView.layoutIfNeeded()
                let sourceFrame = sourceJacketImageView.convert(sourceJacketImageView.bounds, to: transitionContext.containerView)
                
                let destFrame = destJacketImageView.convert(destJacketImageView.bounds, to: transitionContext.containerView)
                destJacketImageView.isHidden = true
                destJacketImageView.layoutIfNeeded()
                transparentView.backgroundColor = .clear
                
                destOtherView?.alpha = 0
                destOtherView?.transform.ty = 20
                
                sourceJacketImageView.isHidden = true
                
                transitionContext.containerView.addSubview(tempView)
                tempView.frame = sourceFrame
                
                //                let duration = self.transitionDuration(using: transitionContext)
                let duration = durationByDistance(sourceFrame.center.distance(to: destFrame.center))
                
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                    tempView.frame = destFrame
                    transparentView.backgroundColor = .white
                }, completion: { (finished) in
                    
                })
                
                UIView.animate(withDuration: pushUpDuration, delay: duration, options: .curveEaseOut, animations: {
                    destOtherView?.alpha = 1
                    destOtherView?.transform.ty = 0
                }, completion: { (finished) in
                    tempView.removeFromSuperview()
                    transparentView.removeFromSuperview()
                    sourceJacketImageView.isHidden = false
                    destJacketImageView.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            } else {
                if let toView = transitionContext.view(forKey: .to) {
                    transitionContext.containerView.addSubview(toView)
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }
            
        } else if animatorType == .pop {
            
            if let fromViewController = transitionContext.viewController(forKey: .from) as? BannerContainer,
                let toViewController = transitionContext.viewController(forKey: .to) as? (UIViewController & BannerContainer),
                let sourceView = toViewController.bannerView,
                let fromView = transitionContext.view(forKey: .from),
                let destJacketImageView = fromViewController.bannerView,
                let toView = transitionContext.view(forKey: .to) {
                destOtherView = fromViewController.otherView
                sourceJacketImageView = sourceView
                tempView = BannerView()
                tempView.sd_setImage(with: sourceJacketImageView.url)
                
                transitionContext.containerView.insertSubview(toView, at: 0)
                let transparentView = UIView(frame: transitionContext.containerView.bounds)
                transparentView.backgroundColor = .white
                transparentView.alpha = 0
                transitionContext.containerView.addSubview(transparentView)
                transitionContext.containerView.addSubview(tempView)
                // make sure the frame is the same if orientation changing occurred
                //                toView.frame = fromView.frame
                toView.layoutIfNeeded()
                
                let toFrame = sourceJacketImageView.convert(sourceJacketImageView.bounds, to: transparentView)
                let fromFrame = destJacketImageView.convert(destJacketImageView.bounds, to: transparentView)
                sourceJacketImageView.isHidden = true
                destJacketImageView.isHidden = true
                tempView.frame = fromFrame
                
                let duration = durationByDistance(toFrame.center.distance(to: fromFrame.center))
                
                UIView.animate(withDuration: pushUpDuration, delay: 0, options: .curveEaseIn, animations: {
                    transparentView.alpha = 1
                    destOtherView?.transform.ty = 20
                }, completion: { finished in
                    fromView.removeFromSuperview()
                })
                
                UIView.animate(withDuration: duration, delay: pushUpDuration, options: .curveEaseInOut, animations: {
                    tempView.frame = toFrame
                    destJacketImageView.layoutIfNeeded()
                    transparentView.backgroundColor = .clear
                }, completion: { (finished) in
                    sourceJacketImageView.isHidden = false
                    transparentView.removeFromSuperview()
                    tempView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
            } else {
                if let toView = transitionContext.view(forKey: .to) {
                    transitionContext.containerView.addSubview(toView)
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
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

class BannerInteractiveAnimator: NSObject, UIViewControllerInteractiveTransitioning {
    
    var destBannerView: BannerView?
    
    var otherView: UIView?
    
    var sourceBannerView: BannerView!
    
    var destFrame = CGRect.zero
    
    var sourceFrame = CGRect.zero
    
    var lastProgress: CGFloat = 0
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        if let fromViewController = transitionContext.viewController(forKey: .from) as? BannerContainer {
            destBannerView = fromViewController.bannerView
            otherView = fromViewController.otherView
        }
        
        if let toViewController = transitionContext.viewController(forKey: .to) as? BannerContainer {
            sourceBannerView = toViewController.bannerView
        }
        
        if let toView = transitionContext.view(forKey: .to),
            let destBanner = destBannerView,
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
        
        destBannerView?.frame = frame
        destBannerView?.layoutIfNeeded()
        
        otherView?.alpha = 1 - progress1
        otherView?.transform.ty = 20 * progress1
        
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

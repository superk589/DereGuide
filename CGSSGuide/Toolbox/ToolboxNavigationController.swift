//
//  ToolboxNavigationController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/9.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ToolboxNavigationController: BaseNavigationController {
  
    var customGesture: UIScreenEdgePanGestureRecognizer!
    
    var bannerViewInteractiveAnimator: BannerViewInteractiveAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customGesture = UIScreenEdgePanGestureRecognizer()
        view.addGestureRecognizer(customGesture)
        customGesture.edges = .left
        customGesture.addTarget(self, action: #selector(self.handleCustomGesture(gesture:)))
        customGesture.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let vc = fromVC as? BannerViewAnimatorProvider, operation == .push {
            vc.bannerViewAnimator.animatorType = .push
            return vc.bannerViewAnimator
        } else if let vc = toVC as? BannerViewAnimatorProvider, operation == .pop {
            vc.bannerViewAnimator.animatorType = .pop
            return vc.bannerViewAnimator
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is EventDetailController || viewController is GachaDetailController {
            customGesture.isEnabled = true
            interactivePopGestureRecognizer?.isEnabled = false
        } else {
            customGesture.isEnabled = false
            interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return bannerViewInteractiveAnimator
    }
    
    func handleCustomGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        
        var progress = gesture.translation(in: self.view).x / self.view.bounds.size.width
        progress = min(1.0, max(0.0, progress))
        
        switch gesture.state {
        case .began:
            bannerViewInteractiveAnimator = BannerViewInteractiveAnimator()
            self.popViewController(animated: true)
        case .changed:
            bannerViewInteractiveAnimator?.update(progress)
        case .ended, .cancelled:
            if progress > 0.5 {
                bannerViewInteractiveAnimator?.finish()
            } else {
                bannerViewInteractiveAnimator?.cancel()
            }
            bannerViewInteractiveAnimator = nil
        default:
            break
        }
    }
}

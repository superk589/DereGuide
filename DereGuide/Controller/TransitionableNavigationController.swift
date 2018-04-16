//
//  TransitionableNavigationController.swift
//  DereGuide
//
//  Created by zzk on 2017/6/13.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class TransitionableNavigationController: BaseNavigationController {
    
    var customGesture: UIScreenEdgePanGestureRecognizer!
    
    var interactiveAnimator: UIPercentDrivenInteractiveTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customGesture = UIScreenEdgePanGestureRecognizer()
        view.addGestureRecognizer(customGesture)
        customGesture.edges = .left
        customGesture.addTarget(self, action: #selector(self.handleCustomGesture(gesture:)))
        customGesture.isEnabled = false
    }
    
    override func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let type = TransitionTypes.init(operation: operation)
        if let from = fromVC as? Transitionable, let to = toVC as? Transitionable {
            if from.transitionTypes.contains(type) && to.transitionTypes.contains(type) {
                return TransitionAnimatorController(transitionTypes: type)
            }
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let transitionable = viewController as? Transitionable, transitionable.transitionTypes.contains(.interactive) {
            customGesture.isEnabled = true
            interactivePopGestureRecognizer?.isEnabled = false
        } else {
            customGesture.isEnabled = false
            interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator
    }
    
    @objc func handleCustomGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        
        var progress = gesture.translation(in: self.view).x / self.view.bounds.size.width
        progress = min(1.0, max(0.0, progress))
        
        switch gesture.state {
        case .began:
            interactiveAnimator = UIPercentDrivenInteractiveTransition()
            self.popViewController(animated: true)
        case .changed:
            interactiveAnimator?.update(progress)
        case .ended, .cancelled:
            if progress > 0.5 {
                interactiveAnimator?.finish()
            } else {
                interactiveAnimator?.cancel()
            }
            interactiveAnimator = nil
        default:
            break
        }
    }
}

//
//  BaseNavigationController.swift
//  DereGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航控制器背景颜色 防止跳转时页面闪烁
        self.view.backgroundColor = UIColor.white
        // self.navigationBar.tintColor = UIColor.whiteColor()
        // 设置右滑手势代理 防止右滑在修改了左侧导航按钮之后失效
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.delegate = self
        navigationBar.tintColor = .parade
        toolbar.tintColor = .parade
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 解决当视图中存在其他手势时 特别是UIScrollView布满全屏时 导致返回手势失效的问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == self.interactivePopGestureRecognizer
    }
    
    // 如果不实现这个方法, 在根视图的左侧向右滑动几下再点击push新页面会卡死
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return childViewControllers.count > 1
    }
    
    private var showHomeButtonCount = 3
    
    @objc func popToRoot() {

        // 使用自定义动画效果
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.3
        view.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
        popToRootViewController(animated: false)
        
        setToolbarHidden(true, animated: true)
    }
    
    private var flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private var homeItem = UIBarButtonItem(image: #imageLiteral(resourceName: "750-home-toolbar"), style: .plain, target: self, action: #selector(popToRoot))
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count <= showHomeButtonCount {
            if let items = viewController.toolbarItems {
                if items.count > 0 && items.contains(where: { ![flexibleSpaceItem, homeItem].contains($0) }) {
                    setToolbarHidden(false, animated: animated)
                } else {
                    setToolbarHidden(true, animated: animated)
                }
            } else {
                setToolbarHidden(true, animated: animated)
            }
        } else {
            setToolbarHidden(false, animated: animated)
            if let items = viewController.toolbarItems {
                if !items.contains(homeItem) {
                    if items.count > 0 {
                        viewController.toolbarItems?.append(flexibleSpaceItem)
                    }
                    viewController.toolbarItems?.append(homeItem)
                }
            } else {
                viewController.toolbarItems = [homeItem]
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let vc = fromVC as? (BannerAnimatorProvider & BannerContainer), toVC is BannerContainer, operation == .push {
            vc.bannerAnimator.animatorType = .push
            return vc.bannerAnimator
        } else if let vc = toVC as? (BannerContainer & BannerAnimatorProvider), let fromVC = fromVC as? BannerContainer, operation == .pop, vc.bannerView != nil, fromVC.bannerView != nil {
            vc.bannerAnimator.animatorType = .pop
            return vc.bannerAnimator
        }
        return nil
    }
}

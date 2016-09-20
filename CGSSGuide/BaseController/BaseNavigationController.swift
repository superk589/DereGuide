//
//  BaseNavigationController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016年 zzk. All rights reserved.
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
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var showHomeButtonCount = 3
    
    
    func popToRoot() {
        self.popToRootViewController(animated: true)
        setToolbarHidden(true, animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count <= showHomeButtonCount {
            setToolbarHidden(true, animated: true)
        } else {
            setToolbarHidden(false, animated: true)
            let item = UIBarButtonItem.init(image: UIImage.init(named: "750-home-toolbar"), style: .plain, target: self, action: #selector(popToRoot))
            if let items = viewController.toolbarItems, items.count > 0 {
                let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spaceItem.width = 40
                viewController.toolbarItems?.append(spaceItem)
                viewController.toolbarItems?.append(item)
            } else {
                viewController.toolbarItems = [item]
            }
        }
    }
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

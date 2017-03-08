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
    
    // 解决当视图中存在其他手势时 特别是UIScrollView布满全屏时 导致返回手势失效的问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == self.interactivePopGestureRecognizer
    }
    
    private var showHomeButtonCount = 3
    
    func popToRoot() {
        self.popToRootViewController(animated: true)
        setToolbarHidden(true, animated: true)
    }
 
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count <= showHomeButtonCount {
            if let items = viewController.toolbarItems {
                if items.count > 0 {
                    for item in items {
                        if ![1002, 1003].contains(item.tag) {
                            setToolbarHidden(false, animated: true)
                            break
                        }
                    }
                }
            } else {
                setToolbarHidden(true, animated: true)
            }
        } else {
            setToolbarHidden(false, animated: true)
            let item = UIBarButtonItem.init(image: UIImage.init(named: "750-home-toolbar"), style: .plain, target: self, action: #selector(popToRoot))
            item.tag = 1002
            if let items = viewController.toolbarItems, items.count > 0 {
                //如果已经有了返回主页按钮 不再重复添加
                for i in items {
                    if i.tag == 1002 {
                        return
                    }
                }
                let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                spaceItem.tag = 1003
                viewController.toolbarItems?.append(spaceItem)
                viewController.toolbarItems?.append(item)
            } else {
                viewController.toolbarItems = [item]
            }
        }
    }
    
}

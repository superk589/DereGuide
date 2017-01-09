//
//  DrawerController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/7.
//  Copyright © 2017年 zzk. All rights reserved.
//


import UIKit
import SnapKit

public enum DrawerCoverStyle {
    /// 水平平铺 无阴影
    case plain
    /// 上方覆盖 抽屉视图外边缘有阴影
    case cover
    /// 下方插入 主视图外边缘有阴影
    case insert
}

open class DrawerController: UIViewController, DrawerCoverViewDelegate {
    
    /// 作为容器的滚动视图
    open var containerView: DrawerScrollView!
    
    /// 左侧阴影
    var leftShadowView: DrawerShadowView!
    
    /// 右侧阴影
    var rightShadowView: DrawerShadowView!
    
    /// 主视图蒙层
    var mainCoverView: DrawerCoverView!
    
    /// 阴影视图的宽度
    open var shadowWidth: CGFloat = 5 {
        didSet {
            leftShadowView.snp.updateConstraints { (update) in
                update.width.equalTo(shadowWidth)
            }
            rightShadowView.snp.updateConstraints { (update) in
                update.width.equalTo(shadowWidth)
            }
        }
    }
    
    
    /// 主视图控制器
    open var mainVC: UIViewController! {
        didSet {
            oldValue?.view.snp.removeConstraints()
            oldValue?.view.removeFromSuperview()
            
            containerView.addSubview(mainVC.view)
            mainVC.view.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(leftSideVC?.view.snp.right ?? containerView)
                make.right.equalTo(rightSideVC?.view.snp.left ?? containerView)
                make.width.equalToSuperview()
            }
        }
    }
    
    /// 右侧抽屉视图控制器
    open var rightSideVC: UIViewController? {
        didSet {
            oldValue?.view.snp.removeConstraints()
            oldValue?.view.removeFromSuperview()
            if let rightView = rightSideVC?.view {
                containerView.addSubview(rightView)
                rightView.snp.makeConstraints({ (make) in
                    make.top.right.bottom.equalToSuperview()
                    make.height.equalToSuperview()
                    make.width.equalTo(rightSideWidth)
                })
                mainVC.view.snp.updateConstraints({ (update) in
                    update.right.equalTo(-rightSideWidth)
                })
                containerView.bringSubview(toFront: leftShadowView)
                containerView.bringSubview(toFront: rightShadowView)
            } else {
                containerView.rightSideWidth = 0
            }
            
        }
    }
    
    /// 左侧抽屉视图控制器
    open var leftSideVC: UIViewController? {
        didSet {
            oldValue?.view.snp.removeConstraints()
            oldValue?.view.removeFromSuperview()
            if let leftView = leftSideVC?.view {
                containerView.addSubview(leftView)
                leftView.snp.makeConstraints({ (make) in
                    make.top.left.bottom.equalToSuperview()
                    make.height.equalToSuperview()
                    make.width.equalTo(leftSideWidth)
                })
                mainVC.view.snp.updateConstraints({ (update) in
                    update.left.equalTo(leftSideWidth)
                })
                containerView.contentOffset.x = leftSideWidth
                containerView.bringSubview(toFront: leftShadowView)
                containerView.bringSubview(toFront: rightShadowView)
            } else {
                containerView.leftSideWidth = 0
            }
        }
    }
    
    /// 主视图在抽屉出现后的缩放比例
    open var mainScale: CGFloat = 1
    
    
    public init(main: UIViewController, rightSide: UIViewController?, leftSide: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        containerView = DrawerScrollView()
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.addChildViewController(main)
        containerView.delegate = self
        
        self.mainVC = main
        self.rightSideVC = rightSide
        self.leftSideVC = leftSide
        
        containerView.addSubview(main.view)
        
        if let leftView = leftSide?.view {
            containerView.addSubview(leftView)
            leftView.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(leftSideWidth)
                make.right.equalTo(main.view.snp.left)
            })
        } else {
            containerView.leftSideWidth = 0
        }
        
        if let rightView = rightSide?.view {
            containerView.addSubview(rightView)
            rightView.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(rightSideWidth)
                make.left.equalTo(main.view.snp.right)
            })
        } else {
            containerView.rightSideWidth = 0
        }
        
        main.view.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalTo(leftSideWidth)
            make.right.equalTo(-rightSideWidth)
            make.width.equalToSuperview()
        }
        
        mainCoverView = DrawerCoverView()
        main.view.addSubview(mainCoverView)
        mainCoverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mainCoverView.alpha = 0
        mainCoverView.delegate = self
        
        
        leftShadowView = DrawerShadowView()
        leftShadowView.direction = .right
        containerView.addSubview(leftShadowView)
        leftShadowView.snp.makeConstraints { (make) in
            make.right.equalTo(main.view)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(shadowWidth)
        }
        rightShadowView = DrawerShadowView()
        rightShadowView.direction = .left
        containerView.addSubview(rightShadowView)
        rightShadowView.snp.makeConstraints { (make) in
            make.left.equalTo(main.view)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(shadowWidth)
        }
        leftShadowView.alpha = 0
        rightShadowView.alpha = 0
        
        containerView.contentOffset.x = leftSideWidth
        
        // 导航手势失败才可以执行左侧菜单手势
        if let gesture = main.navigationController?.interactivePopGestureRecognizer {
            containerView.panGestureRecognizer.require(toFail: gesture)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func drawerCoverViewDidDismiss(_ view: DrawerCoverView) {
        if isRightShowing {
            self.hideRightSide(animated: true)
        } else if isLeftShowing {
            self.hideLeftSide(animated: true)
        }
    }
    
    
    /// 弹出预先设定好的右侧抽屉ViewController
    ///
    /// - Parameter animated: 是否有过度动画
    open func showRightSide(animated: Bool) {
        if let frame = rightSideVC?.view.frame {
            self.containerView.scrollRectToVisible(frame, animated: animated)
        }
    }
    
    
    /// 传入一个新的ViewController并从右侧弹出
    ///
    /// - Parameters:
    ///   - vc: ViewController
    ///   - animated: 是否有过度动画
    open func showRightSideVC(_ vc: UIViewController, animated: Bool) {
        rightSideVC = vc
        showRightSide(animated: animated)
    }
    
    
    /// 隐藏右侧抽屉
    ///
    /// - Parameter animated: 是否有过度动画
    open func hideRightSide(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.containerView.contentOffset.x = self.leftSideWidth
            }
        } else {
            self.containerView.contentOffset.x = leftSideWidth
        }
    }
    
    /// 弹出预先设定好的左侧抽屉ViewController
    ///
    /// - Parameter animated: 是否有过度动画
    open func showLeftSide(animated: Bool) {
        if let frame = leftSideVC?.view.frame {
            self.containerView.scrollRectToVisible(frame, animated: animated)
        }
    }
    
    
    /// 传入一个新的ViewController并从左侧弹出
    ///
    /// - Parameters:
    ///   - vc: ViewController
    ///   - animated: 是否有过度动画
    open func showLeftSideVC(_ vc: UIViewController, animated: Bool) {
        leftSideVC = vc
        showLeftSide(animated: animated)
    }
    
    /// 隐藏左侧抽屉
    ///
    /// - Parameter animated: 是否有过度动画
    open func hideLeftSide(animated: Bool) {
        hideRightSide(animated: animated)
    }
    
    
}

extension DrawerController: UIScrollViewDelegate {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let offsetX = scrollView.contentOffset.x
        
        let percent: CGFloat = {
            if isLeftShowing {
                return (leftSideWidth - offsetX) / leftSideWidth
            } else if isRightShowing {
                return (width + rightSideWidth - scrollView.contentSize.width + offsetX) / rightSideWidth
            }
            return 0
        }()
        
        let scale: CGFloat = {
            if isLeftShowing {
                return 1 + percent * (mainScale - 1)
            } else if isRightShowing {
                return 1 + percent * (mainScale - 1)
            }
            return 1
        }()
        
        mainVC.view.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        mainCoverView.alpha = percent
        containerView.endEditing(true)
        
        if isLeftShowing {
            switch drawerStyle {
            case .plain:
                mainVC.view.transform.tx = -(1 - scale) * width / 2
            case .cover:
                mainVC.view.transform.tx = (1 - scale) * width / 2 - leftSideWidth * percent
                rightShadowView.alpha = percent
            case .insert:
                leftShadowView.alpha = percent
                mainVC.view.transform.tx = -(1 - scale) * width / 2
            }
        } else if isRightShowing {
            switch drawerStyle {
            case .plain:
                mainVC.view.transform.tx = (1 - scale) * width / 2
            case .cover:
                mainVC.view.transform.tx = -(1 - scale) * width / 2 + rightSideWidth * percent
                leftShadowView.alpha = percent
            case .insert:
                rightShadowView.alpha = percent
                mainVC.view.transform.tx = (1 - scale) * width / 2
            }
        } else {
            mainVC.view.transform.tx = 0
            leftShadowView.alpha = 0
            rightShadowView.alpha = 0
        }
    }
}

extension DrawerController {
    /// 右侧抽屉的宽度
    open var rightSideWidth:CGFloat {
        set {
            containerView.rightSideWidth = newValue
            if let view = rightSideVC?.view {
                view.snp.updateConstraints({ (update) in
                    update.width.equalTo(newValue)
                })
                mainVC.view.snp.makeConstraints { (update) in
                    update.right.equalTo(-newValue)
                }
            }
        }
        get {
            if let _ = rightSideVC {
                return containerView.rightSideWidth
            } else {
                return 0
            }
        }
    }
    
    /// 左侧抽屉的宽度
    open var leftSideWidth: CGFloat {
        set {
            containerView.leftSideWidth = newValue
            if let view = leftSideVC?.view {
                view.snp.updateConstraints({ (update) in
                    update.width.equalTo(newValue)
                })
                mainVC.view.snp.makeConstraints { (update) in
                    update.left.equalTo(newValue)
                }
            }
            
        }
        get {
            if let _ = leftSideVC {
                return containerView.leftSideWidth
            } else {
                return 0
            }
        }
    }
    
    /// 抽屉风格
    open var drawerStyle: DrawerCoverStyle {
        set {
            containerView.drawerStyle = newValue
            switch newValue {
            case .plain:
                rightShadowView.isHidden = true
                leftShadowView.isHidden = true
            case .insert:
                rightShadowView.isHidden = false
                leftShadowView.isHidden = false
                leftShadowView.snp.remakeConstraints { (make) in
                    make.right.equalTo(mainVC.view.snp.left)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
                rightShadowView.snp.remakeConstraints { (make) in
                    make.left.equalTo(mainVC.view.snp.right)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
            case .cover:
                rightShadowView.isHidden = false
                leftShadowView.isHidden = false
                
                leftShadowView.snp.remakeConstraints { (make) in
                    make.right.equalTo(mainVC.view)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
                rightShadowView.snp.remakeConstraints { (make) in
                    make.left.equalTo(mainVC.view)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
            }
        }
        get {
            return containerView.drawerStyle
        }
    }
    
    /// 主视图上用来拉出抽屉的手势生效区域距边缘的宽度
    open var gestureRecognizerWidth: CGFloat {
        set {
            containerView.gestureRecognizerWidth = newValue
        }
        get {
            return containerView.gestureRecognizerWidth
        }
    }
    
    /// 右侧抽屉正在显示出来
    open var isRightShowing: Bool {
        if containerView.contentOffset.x > leftSideWidth {
            return true
        } else {
            return false
        }
    }
    
    /// 左侧抽屉正在显示出来
    open var isLeftShowing: Bool {
        if containerView.contentOffset.x < leftSideWidth {
            return true
        } else {
            return false
        }
    }
    
    open var isCentered: Bool {
        if containerView.contentOffset.x == leftSideWidth {
            return true
        } else {
            return false
        }
    }
    
}

//
//  DrawerScrollView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

public class DrawerScrollView: UIScrollView {

    var rightSideWidth: CGFloat = 300
    
    var leftSideWidth: CGFloat = 300
    
    var mainScale: CGFloat = 1
    
    var drawerStyle: DrawerCoverStyle = .cover
    
    var gestureRecognizerWidth:CGFloat = 40
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isPagingEnabled = true
        self.backgroundColor = UIColor.clear
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //拿到手势生效的坐标点（相对于scrollView的内部空间）
        let point = gestureRecognizer.location(in: self)
        
        if drawerStyle == .cover {
            // 覆盖模式
            if self.contentOffset.x == 0 && leftSideWidth > 0 {
                //当偏移量为0时（左侧菜单完全展示）
                if point.x < leftSideWidth {
                    return true
                }
            } else if self.contentOffset.x == contentSize.width - self.frame.width && rightSideWidth > 0 {
                //当偏移量为contentSize.width时（右侧菜单完全展示）
                if point.x + rightSideWidth > contentSize.width {
                    return true
                }
                
            } else {
                if point.y < 64 {
                    return false
                }
                if point.x < leftSideWidth + gestureRecognizerWidth || point.x > contentSize.width - rightSideWidth - gestureRecognizerWidth {
                    return true
                }
            }

        } else if drawerStyle == .plain || drawerStyle == .insert {
            // 平铺模式
            if self.contentOffset.x == 0 && leftSideWidth > 0 {
                //当偏移量为0时（左侧菜单完全展示）
                if point.x > leftSideWidth {
                    return true
                }
            } else if self.contentOffset.x == contentSize.width - self.frame.width && rightSideWidth > 0 {
                //当偏移量为contentSize.width时（右侧菜单完全展示）
                if point.x + rightSideWidth > contentSize.width {
                    return true
                }
            } else {
                if point.y < 64 {
                    return false
                }
                if point.x < leftSideWidth + gestureRecognizerWidth || point.x > contentSize.width - rightSideWidth - gestureRecognizerWidth {
                    return true
                }
            }

        }
        
        return false
    }
}

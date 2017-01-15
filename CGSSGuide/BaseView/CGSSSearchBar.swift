//
//  CGSSSearchBar.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class CGSSSearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 为了避免push/pop时闪烁,searchBar的背景图设置为透明的
        for sub in self.subviews.first!.subviews {
            if let iv = sub as? UIImageView {
                iv.alpha = 0
            }
        }
        autocapitalizationType = .none
        autocorrectionType = .no
        returnKeyType = .search
        
        enablesReturnKeyAutomatically = false
//        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Screen.width, height: 30))
//        let imageView = UIImageView.init(frame: CGRect.init(x: Screen.width - 22, y: 8, width: 22, height: 22))
//        view.addSubview(imageView)
//        imageView.image = #imageLiteral(resourceName: "764-arrow-down-toolbar-selected")
//        inputAccessoryView = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

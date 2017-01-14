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
        returnKeyType = .done
        // searchBar.showsCancelButton = true
        autocapitalizationType = .none
        autocorrectionType = .no
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

//
//  CGSSIconView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSIconView: UIImageView {
    
    var tap: UITapGestureRecognizer?
    var action: Selector?
    weak var target: AnyObject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
        
    }
    
    func prepare() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        userInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        addGestureRecognizer(tap!)
    }
    
    func setIconImage(urlStr: String) {
        sd_setImageWithURL(NSURL.init(string: urlStr)!, placeholderImage: UIImage.init(named: "icon_placeholder"))
        // sd_setImageWithURL(NSURL.init(string: urlStr)!)
    }
    
    func setAction(target: AnyObject, action: Selector) {
        self.action = action
        self.target = target
    }
    
    func onClick() {
        if action != nil {
            self.target?.performSelector(action!, withObject: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
}

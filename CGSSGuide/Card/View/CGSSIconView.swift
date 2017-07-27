//
//  CGSSIconView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKCornerRadiusView

protocol CGSSIconViewDelegate: class {
    func iconClick(_ iv: CGSSIconView)
}

class CGSSIconView: UIImageView {
    
    var tap: UITapGestureRecognizer?
    var action: Selector?
    weak var target: AnyObject?
    weak var delegate: CGSSIconViewDelegate?
    
    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: 48, height: 48))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    func prepare() {
        isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        addGestureRecognizer(tap!)
    }
    
    func setAction(_ target: AnyObject, action: Selector) {
        self.action = action
        self.target = target
    }
    
    @objc func onClick() {
        delegate?.iconClick(self)
        if action != nil {
            _ = self.target?.perform(action!, with: self)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
}

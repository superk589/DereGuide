//
//  StatusIndicator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/26.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class StatusIndicator: UIView {
    

    var _color: UIColor = UIColor.black
    
    var color: UIColor {
        set {
            _color = newValue
            setNeedsDisplay()
        }
        get {
            return _color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    
    override func draw(_ rect: CGRect) {
        let colors = [color.cgColor, color.withAlphaComponent(0.1).cgColor]
        let gradient = CGGradient.init(colorsSpace: nil, colors: colors as CFArray, locations: nil)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.drawRadialGradient(gradient!, startCenter: CGPoint.init(x: rect.size.width / 2, y: rect.size.height / 2), startRadius: 0, endCenter: CGPoint.init(x: rect.size.width / 2, y: rect.size.height / 2), endRadius: min(rect.size.width / 2, rect.size.height / 2), options: CGGradientDrawingOptions.init(rawValue: 0))
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

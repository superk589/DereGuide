//
//  StatusIndicator.swift
//  DereGuide
//
//  Created by zzk on 2017/1/26.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class StatusIndicator: UIView {
    
    var _color: UIColor = .black
    
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
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let colors = [color.cgColor, color.mixed(withColor: .white, weight: 0.9).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: nil)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.drawRadialGradient(gradient!, startCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), startRadius: 0, endCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), endRadius: min(rect.size.width / 2, rect.size.height / 2), options: [])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 12, height: 12)
    }
}

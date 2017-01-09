//
//  DrawerShadowView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/8.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

enum DrawerShadowDirection {
    case left
    case right
}

class DrawerShadowView: UIView {

    var direction: DrawerShadowDirection = .left
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let locations:[CGFloat] = (direction == .left ? [0, 1] : [1, 0])
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.black.withAlphaComponent(0).cgColor]
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        let startPoint = CGPoint.init(x: 0, y: 0)
        let endPoint = CGPoint.init(x: rect.size.width, y: 0)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.init(rawValue: 0))
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

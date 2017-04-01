//
//  TipView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/4/1.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

enum ArrowDirection {
    case up, left, down, right
}

class ArrowView: UIView {
    
    var color = UIColor.white { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 0, y: bounds.maxY))
        path.addLine(to: CGPoint.init(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint.init(x: bounds.midX, y: 0))
        path.close()
        color.setFill()
        path.fill()
    }
}

class TipView: UIView {
    
    var contentView: UIView!
    
    var arrowView: ArrowView!
    
    var contentColor = UIColor.white {
        didSet {
            arrowView.color = contentColor
            contentView.backgroundColor = contentColor
            updateUI()
        }
    }
    
    var arrowOffset: CGPoint = CGPoint.zero { didSet { updateUI() } }
    
    var arrowDirection: ArrowDirection = .up { didSet { updateUI() } }
    
    var arrowHeight: CGFloat = 10 { didSet { updateUI() } }
    
    var arrowWidth: CGFloat = 10 { didSet { updateUI() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = UIView()
        addSubview(contentView)
        
        arrowView = ArrowView()
        arrowView.backgroundColor = UIColor.clear
        arrowView.contentMode = .redraw
        addSubview(arrowView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch arrowDirection {
        case .up:
            arrowView.frame = CGRect.init(x: arrowOffset.x - arrowWidth / 2, y: 0, width: arrowWidth, height: arrowHeight)
            contentView.frame = CGRect.init(x: 0, y: arrowHeight, width: bounds.size.width, height: bounds.size.height - arrowHeight)
            arrowView.transform = CGAffineTransform.identity
        case .down:
            arrowView.frame = CGRect.init(x: arrowOffset.x - arrowWidth / 2, y: bounds.size.height - arrowHeight, width: arrowWidth, height: arrowHeight)
            contentView.frame = CGRect.init(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - arrowHeight)
            arrowView.transform = CGAffineTransform.init(rotationAngle: .pi)
        case .left:
            arrowView.frame = CGRect.init(x: 0, y: arrowOffset.y - arrowHeight / 2, width: arrowWidth, height: arrowHeight)
            contentView.frame = CGRect.init(x: arrowWidth, y: 0, width: bounds.size.width - arrowWidth, height: bounds.size.height)
            arrowView.transform = CGAffineTransform.init(rotationAngle: -.pi / 2)
        case .right:
            arrowView.frame = CGRect.init(x: bounds.size.width - arrowWidth, y: arrowOffset.y - arrowHeight / 2, width: arrowWidth, height: arrowHeight)
            contentView.frame = CGRect.init(x: 0, y: 0, width: bounds.size.width - arrowWidth, height: bounds.size.height)
            arrowView.transform = CGAffineTransform.init(rotationAngle: .pi / 2)
        }
    }
    
    private func updateUI() {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

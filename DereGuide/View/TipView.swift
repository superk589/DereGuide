//
//  TipView.swift
//  DereGuide
//
//  Created by zzk on 2017/4/1.
//  Copyright © 2017 zzk. All rights reserved.
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
    
    var sourceView: UIView? {
        didSet {
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
    
    private func updateUI() {
        switch arrowDirection {
        case .up:
            arrowView.snp.remakeConstraints({ (make) in
                if let view = sourceView {
                    make.centerX.equalTo(view)
                } else {
                    make.left.equalTo(arrowOffset.x)
                }
                make.width.equalTo(arrowWidth)
                make.height.equalTo(arrowHeight)
                make.top.equalToSuperview()
            })
            contentView.snp.remakeConstraints({ (make) in
                make.left.bottom.right.equalToSuperview()
                make.top.equalTo(arrowView.snp.bottom)
            })
            arrowView.transform = CGAffineTransform.identity
        case .down:
            arrowView.snp.remakeConstraints({ (make) in
                if let view = sourceView {
                    make.centerX.equalTo(view)
                } else {
                    make.left.equalTo(arrowOffset.x)
                }
                make.width.equalTo(arrowWidth)
                make.height.equalTo(arrowHeight)
                make.bottom.equalToSuperview()
            })
            contentView.snp.remakeConstraints({ (make) in
                make.left.top.right.equalToSuperview()
                make.bottom.equalTo(arrowView.snp.top)
            })
            arrowView.transform = CGAffineTransform.init(rotationAngle: .pi)
        case .left:
            arrowView.snp.remakeConstraints({ (make) in
                make.left.equalToSuperview()
                make.width.equalTo(arrowWidth)
                make.height.equalTo(arrowHeight)
                if let view = sourceView {
                    make.centerY.equalTo(view)
                } else {
                    make.top.equalTo(arrowOffset.y)
                }
            })
            contentView.snp.remakeConstraints({ (make) in
                make.bottom.top.right.equalToSuperview()
                make.left.equalTo(arrowView.snp.right)
            })
            arrowView.transform = CGAffineTransform.init(rotationAngle: -.pi / 2)
        case .right:
            arrowView.snp.remakeConstraints({ (make) in
                make.right.equalToSuperview()
                make.width.equalTo(arrowWidth)
                make.height.equalTo(arrowHeight)
                if let view = sourceView {
                    make.centerY.equalTo(view)
                } else {
                    make.top.equalTo(arrowOffset.y)
                }
            })
            contentView.snp.remakeConstraints({ (make) in
                make.bottom.top.left.equalToSuperview()
                make.right.equalTo(arrowView.snp.left)
            })
            arrowView.transform = CGAffineTransform.init(rotationAngle: .pi / 2)
        }
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

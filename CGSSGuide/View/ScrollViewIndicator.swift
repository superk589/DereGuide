//
//  ScrollViewIndicator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ScrollViewIndicator: UIView, UIGestureRecognizerDelegate {
    
    var panGesture: UIPanGestureRecognizer!
    
    var scrollView: UIScrollView? {
        return self.superview as? UIScrollView
    }

    var insets: UIEdgeInsets = UIEdgeInsets.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        backgroundColor = UIColor.clear
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(_:)))
        addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }
    
    var strokeColor: UIColor = UIColor.blue
    
    private var scale: CGFloat = 0.8
    
    private var radius: CGFloat {
        return min(bounds.size.height / 2 - 1, bounds.size.width / 2 - 1) * scale
    }
    
    private var innerCenter: CGPoint {
        return CGPoint.init(x: bounds.midX, y: bounds.midY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        strokeColor.set()
        pathForCircle().stroke()
        pathForTriangle(direction: .down).stroke()
        pathForTriangle(direction: .up).stroke()
    }

    private func pathForCircle() -> UIBezierPath {
        let path = UIBezierPath.init(arcCenter: innerCenter, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        path.lineWidth = 1
        return path
    }
    
    private enum TriangleDirection {
        case up, down
    }
    
    private struct Ratio {
        static let triangle: CGFloat = 2
    }
    
    private func pathForTriangle(direction: TriangleDirection) -> UIBezierPath {
        let path = UIBezierPath.init()
        if direction == .up {
            path.move(to: CGPoint.init(x: innerCenter.x - radius / Ratio.triangle, y: innerCenter.y - radius / Ratio.triangle / 4))
            path.addLine(to: CGPoint.init(x: innerCenter.x + radius / Ratio.triangle, y: innerCenter.y - radius / Ratio.triangle / 4))
            path.addLine(to: CGPoint.init(x: innerCenter.x, y: innerCenter.y - radius + radius / Ratio.triangle / 2))
        } else {
            path.move(to: CGPoint.init(x: innerCenter.x - radius / Ratio.triangle, y: innerCenter.y + radius / Ratio.triangle / 4))
            path.addLine(to: CGPoint.init(x: innerCenter.x + radius / Ratio.triangle, y: innerCenter.y + radius / Ratio.triangle / 4))
            path.addLine(to: CGPoint.init(x: innerCenter.x, y: innerCenter.y + radius - radius / Ratio.triangle / 2))
        }
        path.close()
        path.lineWidth = 1
        return path
    }
    
    func show(to view: UIScrollView) {
        if !view.subviews.contains(self) {
            view.addSubview(self)
        }
        self.alpha = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustFrameInScrollView()
    }
    
    
    var offsetRatio: CGFloat {
        if let scrollView = self.scrollView {
            /*
            if #available(iOS 11.0, *) {
                let indicatorScrollabelHeight = scrollView.bounds.height - scrollView.adjustedContentInset.top - scrollView.adjustedContentInset.bottom - bounds.maxY - insets.top - insets.bottom
                let totalHeight = scrollView.contentSize.height - scrollView.bounds.height + scrollView.adjustedContentInset.top + scrollView.adjustedContentInset.bottom
                return indicatorScrollabelHeight / totalHeight
            } else {
            */
                let indicatorScrollabelHeight = scrollView.bounds.height - scrollView.contentInset.top - scrollView.contentInset.bottom - bounds.maxY - insets.top - insets.bottom
                let totalHeight = scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.top + scrollView.contentInset.bottom
                return indicatorScrollabelHeight / totalHeight
            /*
            }
            */
        }
        return 1
    }
    
    var maxOffsetY: CGFloat {
        if let scrollView = self.scrollView {
            /*
            if #available(iOS 11.0, *) {
                return scrollView.contentOffset.y + scrollView.bounds.height - scrollView.adjustedContentInset.bottom - bounds.midY - insets.bottom
            } else {
            */
                return scrollView.contentOffset.y + scrollView.bounds.height - scrollView.contentInset.bottom - bounds.midY - insets.bottom
            /*
            }
            */
        }
        return 0
    }

    var minOffsetY: CGFloat {
        if let scrollView = self.scrollView {
            /*
            if #available(iOS 11.0, *) {
                return scrollView.contentOffset.y + scrollView.adjustedContentInset.top + bounds.midY + insets.top
            } else {
            */
                return scrollView.contentOffset.y + scrollView.contentInset.top + bounds.midY + insets.top
            /*
            }
            */
        }
        return 0
    }
    
        
    func adjustFrameInScrollView() {
        if let scrollView = self.scrollView {
            center.x = scrollView.bounds.maxX - bounds.midY - 1
            /*
            if #available(iOS 11.0, *) {
                center.y = max(min((scrollView.adjustedContentInset.top + scrollView.contentOffset.y) * (1 + offsetRatio) + bounds.midY + insets.top, maxOffsetY), minOffsetY)
            } else {
            */
                center.y = max(min((scrollView.contentInset.top + scrollView.contentOffset.y) * (1 + offsetRatio) + bounds.midY + insets.top, maxOffsetY), minOffsetY)
            /*
            }
            */
        }
    }
    
    func adjustScrollView() {
        if let scrollView = scrollView {
            /*
            if #available(iOS 11.0, *) {
                let offsetY = frame.minY - scrollView.adjustedContentInset.top - scrollView.contentOffset.y - insets.top
                scrollView.contentOffset.y = offsetY / offsetRatio - scrollView.adjustedContentInset.top
            } else {
            */
                let offsetY = frame.minY - scrollView.contentInset.top - scrollView.contentOffset.y - insets.top
                scrollView.contentOffset.y = offsetY / offsetRatio - scrollView.contentInset.top
            /*
            }
            */
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.alpha = 0
        }
    }
    
    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        //print(pan.state, scrollView?.contentOffset.y)
        switch pan.state {
        case .began:
            if let scrollView = self.scrollView {
                scrollView.setContentOffset(scrollView.contentOffset, animated: false)
            }
        case .changed:
            center.y = max(min(center.y + pan.translation(in: nil).y, maxOffsetY), minOffsetY)
            pan.setTranslation(CGPoint.zero, in: nil)
            adjustScrollView()
        default:
            break
        }
    }
    
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollViewPanGesture = self.scrollView?.panGestureRecognizer, scrollViewPanGesture == otherGestureRecognizer {
            return true
        } else {
            return false
        }
    }
    
}


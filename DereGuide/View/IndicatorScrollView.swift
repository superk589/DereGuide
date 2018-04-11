//
//  IndicatorScrollView.swift
//  DereGuide
//
//  Created by zzk on 2017/6/3.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class IndicatorScrollView: UIScrollView {

    var indicator = ScrollViewIndicator(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    lazy var debouncer: Debouncer = {
        return Debouncer.init(interval: 3, callback: { [weak self] in
            if self?.indicator.panGesture.state == .possible {
                self?.indicator.hide()
            } else {
                self?.debouncer.call()
            }
        })
    }()
    
    override var contentOffset: CGPoint {
        set {
            super.contentOffset = newValue
            debouncer.call()
            indicator.adjustFrameInScrollView()
        }
        get {
            return super.contentOffset
        }
    }
    
    @objc func handlePanGestureInside(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            indicator.show(to: self)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsVerticalScrollIndicator = false
        delaysContentTouches = false
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGestureInside(_:)))
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

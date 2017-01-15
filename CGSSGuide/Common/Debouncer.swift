//
//  Debouncer.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

class Debouncer {
    
    // Callback to be debounced
    // Perform the work you would like to be debounced in this callback.
    var callback: (() -> Void)?
    
    private let interval: TimeInterval // Time interval of the debounce window
    
    init(interval: TimeInterval) {
        self.interval = interval
    }
    
    private var timer: Timer?
    
    // Indicate that the callback should be called. Begins the debounce window.
    func call() {
        // Invalidate existing timer if there is one
        timer?.invalidate()
        // Begin a new timer from now
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
    }
    
    @objc private func handleTimer(_ timer: Timer) {
//        if callback == nil {
//            NSLog("Debouncer timer fired, but callback was nil")
//        } else {
//            NSLog("Debouncer timer fired")
//        }
        callback?()
        callback = nil
    }
    
}

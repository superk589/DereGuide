//
//  CGSSUpdatingHUDManager.swift
//  DereGuide
//
//  Created by zzk on 30/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CGSSUpdatingHUDManager {
    
    static let shared = CGSSUpdatingHUDManager()
    
    let updatingStatusView = UpdatingStatusView()
    
    var cancelAction: (() -> Void)?
    
    private init() {
        updatingStatusView.delegate = self
    }
    
    func show() {
        updatingStatusView.show()
    }
    
    func hide(animated: Bool) {
        updatingStatusView.hide(animated: animated)
    }
    
    func setup(_ text: String, animated: Bool, cancelable: Bool) {
        updatingStatusView.setup(text, animated: animated, cancelable: cancelable)
    }
    
    func setup(current: Int, total: Int, animated: Bool, cancelable: Bool) {
        updatingStatusView.setup("\(current)/\(total)", animated: animated, cancelable: cancelable)
    }
    
}

extension CGSSUpdatingHUDManager: UpdatingStatusViewDelegate {
    
    func cancelUpdate(updateStatusView: UpdatingStatusView) {
        cancelAction?()
    }
    
}

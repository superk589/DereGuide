//
//  UIAlertExtension.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/24.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showConfirmAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    static func showConfirmAlertFromTopViewController(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirmAlert(message: message, in: vc)
        }
    }
    
    static func showHintMessage(_ message: String, title: String = NSLocalizedString("提示", comment: ""), in viewController: UIViewController?, confirm: (() -> ())? = nil) {
        if let vc = viewController ?? UIApplication.shared.keyWindow?.rootViewController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default, handler: { (action) in
                confirm?()
            }))
            vc.present(alert, animated: true)
        }
    }
    
    static func showConfirmAlert(title: String, message: String, confirm: @escaping () -> (), cancel: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .destructive, handler: { (action) in
            confirm()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: { (action) in
            cancel()
        }))
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            vc.present(alert, animated: true)
        }
    }
}

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
    
    static func showHintMessage(_ message: String, title: String = NSLocalizedString("提示", comment: ""), in viewController: UIViewController?) {
        if let vc = viewController ?? UIApplication.shared.keyWindow?.rootViewController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default))
            vc.present(alert, animated: true)
        }
    }
}

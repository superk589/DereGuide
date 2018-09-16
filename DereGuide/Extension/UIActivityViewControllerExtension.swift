//
//  UIActivityViewControllerExtension.swift
//  DereGuide
//
//  Created by zzk on 2017/8/29.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

extension UIActivityViewController {
    
    static func show(images: [UIImage], pointTo barButtonItem: UIBarButtonItem, in viewController: UIViewController?) {
        let urlArray = images
        let activityVC = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = barButtonItem
        let cludeActivitys:[UIActivity.ActivityType] = []
        activityVC.excludedActivityTypes = cludeActivitys
        (viewController ?? UIApplication.shared.keyWindow?.rootViewController)?.present(activityVC, animated: true, completion: nil)
    }

    static func show(images: [UIImage], pointTo view: UIView, rect: CGRect?, in viewController: UIViewController?) {
        let urlArray = images
        let activityVC = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.popoverPresentationController?.sourceRect = rect ?? .zero
        let cludeActivitys:[UIActivity.ActivityType] = []
        activityVC.excludedActivityTypes = cludeActivitys
        (viewController ?? UIApplication.shared.keyWindow?.rootViewController)?.present(activityVC, animated: true, completion: nil)
    }
    
}

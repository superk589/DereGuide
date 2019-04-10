//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by zzk on 2017/5/24.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SDWebImage
import SnapKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    var imageView: BannerView!
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = BannerView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(imageView.snp.width).multipliedBy(429.0 / 614.0)
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualToSuperview()
            make.bottom.right.lessThanOrEqualToSuperview()
        }
        imageView.contentMode = .scaleAspectFit
        
//        let blur = UIBlurEffect(style: .dark)
//        let effectView = UIVisualEffectView(effect: blur)
//        view.insertSubview(effectView, at: 0)
//        effectView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        if let spriteImageRef = notification.request.content.userInfo["cardSpriteImageRef"] as? String {
            imageView.setImage(with: URL.init(string: spriteImageRef)!, options: .progressiveLoad)
        }
        
    }

}

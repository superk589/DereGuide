//
//  CardImageController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/22.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class CardImageController: BaseViewController {

    var card: CGSSCard!
    
    var imageView: BannerView!
    
    var item: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = BannerView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
//            make.width.equalToSuperview()
//            make.height.equalTo(Screen.width * 340 / 272)
            make.center.equalToSuperview()
        }
        prepareToolbar()
        if let url = URL.init(string: card.cardImageRef) {
            imageView.sd_setImage(with: url, completed: { (image, error, cache, url) in
                self.item.isEnabled = true
            })
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func prepareToolbar() {
        item = UIBarButtonItem.init(image: #imageLiteral(resourceName: "702-share-toolbar"), style: .plain, target: self, action: #selector(shareAction(item:)))
        item.isEnabled = false
        toolbarItems = [item]
    }
    
    
    func shareAction(item: UIBarButtonItem) {
        if imageView.image == nil {
            return
        }
        let urlArray = [imageView.image!]
        let activityVC = UIActivityViewController.init(activityItems: urlArray, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = item
        //activityVC.popoverPresentationController?.sourceRect = CGRect(x: item.width / 2, y: 0, width: 0, height: 0)
        // 需要屏蔽的模块
        let cludeActivitys:[UIActivityType] = [
            // 保存到本地相册
            //UIActivityType.saveToCameraRoll,
            
            // 拷贝 复制
            //UIActivityType.copyToPasteboard,
            
            // 打印
            //UIActivityType.print,
            
            // 指定联系人
            //UIActivityTypeAssignToContact,
            
            // Facebook
            //UIActivityType.postToFacebook,
            
            // 微博
            //UIActivityType.postToWeibo,
            
            // 短信
            //UIActivityType.message,
            
            // 邮箱
            //UIActivityType.mail,
            
            // 腾讯微博
            //UIActivityType.postToTencentWeibo,
            
            // twitter
            //UIActivityTypePostToTwitter,
            
            // vimeo
            //UIActivityTypePostToVimeo,
            
            // airDrop
            //UIActivityTypeAirDrop,
            
            //UIActivityTypeAddToReadingList,
            //UIActivityTypePostToFlickr,
            //UIActivityTypeOpenInIBooks, // 9.0
        ]
        // 排除活动类型
        activityVC.excludedActivityTypes = cludeActivitys
        
        // 呈现分享界面
        self.present(activityVC, animated: true, completion: {
            
        })
    }
}

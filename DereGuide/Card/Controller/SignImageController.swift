//
//  CardSignImageController.swift
//  DereGuide
//
//  Created by zzk on 2017/1/22.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension CGSSCard {
    var signImageURL: URL? {
        if self.rarityType == .ssr || self.rarityType == . ssrp {
            return URL.init(string: "https://hoshimoriuta.kirara.ca/sign/\(seriesId!).png")
        } else {
            return nil
        }
    }
}

class CardSignImageController: BaseViewController {

    var card: CGSSCard!
    
    var imageView: BannerView!
    
    var item: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = BannerView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualToSuperview()
            make.top.greaterThanOrEqualTo(topLayoutGuide.snp.bottom)
            make.bottom.lessThanOrEqualTo(bottomLayoutGuide.snp.top)
            make.height.equalTo(imageView.snp.width).multipliedBy(504.0 / 630.0)
            make.center.equalToSuperview()
        }
        imageView.style = .custom
        
        prepareToolbar()
        if let url = card.signImageURL {
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
    
    @objc func shareAction(item: UIBarButtonItem) {
        if imageView.image == nil {
            return
        }
        let urlArray = [imageView.image!]
        let activityVC = UIActivityViewController.init(activityItems: urlArray, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = item
        // activityVC.popoverPresentationController?.sourceRect = CGRect(x: item.width / 2, y: 0, width: 0, height: 0)
        // 需要屏蔽的模块
        let cludeActivitys:[UIActivityType] = []
        
        // 排除活动类型
        activityVC.excludedActivityTypes = cludeActivitys
        
        // 呈现分享界面
        self.present(activityVC, animated: true, completion: nil)
    }
    
}

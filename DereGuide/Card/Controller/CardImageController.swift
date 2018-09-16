//
//  CardImageController.swift
//  DereGuide
//
//  Created by zzk on 2017/1/22.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CardImageController: BaseViewController {
    
    var card: CGSSCard!
    
    let imageView = BannerView()
    
    private(set) lazy var item = UIBarButtonItem(image: #imageLiteral(resourceName: "702-share-toolbar"), style: .plain, target: self, action: #selector(shareAction(item:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualToSuperview()
            make.top.greaterThanOrEqualTo(topLayoutGuide.snp.bottom)
            make.bottom.lessThanOrEqualTo(bottomLayoutGuide.snp.top)
            make.height.equalTo(imageView.snp.width).multipliedBy(340.0 / 272.0)
            make.center.equalToSuperview()
        }
        
        imageView.style = .custom
        
        prepareToolbar()
        if let url = URL(string: card.cardImageRef) {
            imageView.sd_setImage(with: url, completed: { (image, error, cache, url) in
                self.item.isEnabled = true
            })
        }
    }
    
    func prepareToolbar() {
        item.isEnabled = false
        toolbarItems = [item]
    }
    
    @objc func shareAction(item: UIBarButtonItem) {
        guard let image = imageView.image else { return }
        let urlArray = [image]
        let activityVC = UIActivityViewController(activityItems: urlArray, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = item
        // activityVC.popoverPresentationController?.sourceRect = CGRect(x: item.width / 2, y: 0, width: 0, height: 0)
        // 需要屏蔽的模块
        let cludeActivitys:[UIActivity.ActivityType] = []
        // 排除活动类型
        activityVC.excludedActivityTypes = cludeActivitys
        
        // 呈现分享界面
        present(activityVC, animated: true, completion: nil)
    }
}

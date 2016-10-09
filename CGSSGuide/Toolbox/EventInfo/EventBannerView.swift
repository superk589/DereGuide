//
//  EventBannerView.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class EventBannerView: UIImageView {

    var bannerId: Int! {
        didSet {
            self.sd_setImage(with: URL.init(string: String.init(format: "http://game.starlight-stage.jp/image/announce/title/thumbnail_event_%04d.png", bannerId)))
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

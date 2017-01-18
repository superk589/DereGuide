//
//  EventBannerView.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class EventBannerView: BannerView {

    var bannerId: Int! {
        didSet {
            self.sd_setImage(with: URL.init(string: String.init(format: "https://game.starlight-stage.jp/image/announce/title/thumbnail_event_%04d.png", bannerId)))
        }
    }
    
    var preBannerId: Int! {
        didSet {
            self.sd_setImage(with: URL.init(string: String.init(format: "https://games.starlight-stage.jp/image/event/teaser/event_teaser_%04d.png", preBannerId)))
        }
    }
    
    var detailBannerId: Int! {
        didSet {
            self.sd_setImage(with: URL.init(string: String.init(format: "https://games.starlight-stage.jp/image/announce/header/header_event_%04d.png", detailBannerId)))
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

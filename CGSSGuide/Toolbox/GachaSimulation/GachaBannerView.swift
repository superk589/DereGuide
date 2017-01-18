//
//  GachaBannerView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class GachaBannerView: BannerView {
    
    var bannerId: Int! {
        didSet {
            self.sd_setImage(with: URL.init(string: String.init(format: "https://game.starlight-stage.jp/image/announce/title/thumbnail_gacha_%04d.png", bannerId)))
        }
    }
    
    var detailBannerId: Int! {
        didSet {
            self.sd_setImage(with: URL.init(string: String.init(format: "https://games.starlight-stage.jp/image/announce/header/header_gacha_%04d.png", detailBannerId)))
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

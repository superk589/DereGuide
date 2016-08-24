//
//  CGSSCardIconView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/10.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSCardIconView: CGSSIconView {
    
    var cardId: Int?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setWithCardId(id: Int) {
        self.cardId = id
        // let url = NSURL.init(string: CGSSUpdater.URLOfDeresuteApi + "/image/card_\(id)_m.png")
        // 修改图标数据地址服务器为https://hoshimoriuta.kirara.ca
        let url = CGSSUpdater.URLOfImages + "/icon_card/\(id).png"
        self.setIconImage(url)
    }
    
    func setWithCardId(id: Int, target: AnyObject, action: Selector) {
        self.setWithCardId(id)
        self.setAction(target, action: action)
    }
    
}

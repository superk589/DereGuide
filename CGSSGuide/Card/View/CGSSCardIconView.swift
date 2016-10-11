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
    
    func setWithCardId(_ id: Int) {
        self.cardId = id
        self.tintColor = CGSSDAO.sharedDAO.findCardById(id)?.attColor.withAlphaComponent(0.5)
        // 修改图标数据地址服务器为https://hoshimoriuta.kirara.ca
        let url = DataURL.Images + "/icon_card/\(id).png"
        self.setIconImage(url)
    }
    
    func setWithCardId(_ id: Int, target: AnyObject, action: Selector) {
        self.setWithCardId(id)
        self.setAction(target, action: action)
    }
    
}

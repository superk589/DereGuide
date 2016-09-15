//
//  CGSSCharIconView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSCharIconView: CGSSCardIconView {
    
    var charId: Int?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setWithCharId(_ id: Int) {
        self.charId = id
        self.tintColor = CGSSDAO.sharedDAO.findCharById(id)?.attColor.withAlphaComponent(0.5)
        // let url = NSURL.init(string: CGSSUpdater.URLOfDeresuteApi + "/image/card_\(id)_m.png")
        // 修改图标数据地址服务器为https://hoshimoriuta.kirara.ca
        let url = CGSSUpdater.URLOfImages + "/icon_char/\(id).png"
        self.setIconImage(url)
    }
    
    func setWithCharId(_ id: Int, target: AnyObject, action: Selector) {
        self.setWithCharId(id)
        self.setAction(target, action: action)
    }
}

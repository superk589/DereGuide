//
//  CGSSCardIconView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/10.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSCardIconView: UIImageView {

    var cardId:Int?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 6
        layer.masksToBounds = true
        //userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
    
    func setWithCardId(id:Int) {
        let url = NSURL.init(string: CGSSUpdater.URLOfDeresuteApi + "/image/card_\(id)_m.png")
        self.sd_setImageWithURL(url)
    }
    
    func tapped() {
        CGSSNotificationCenter.post("CARDICON_CLICK", object: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

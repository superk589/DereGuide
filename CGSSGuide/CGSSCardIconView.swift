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
    var tap:UITapGestureRecognizer?
    var action:Selector?
    weak var target:AnyObject?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 6
        layer.masksToBounds = true
        userInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        addGestureRecognizer(tap!)
    }
    func setWithCardId(id:Int) {
        self.cardId = id
        let url = NSURL.init(string: CGSSUpdater.URLOfDeresuteApi + "/image/card_\(id)_m.png")
        self.sd_setImageWithURL(url)
    }
    
    func setWithCardId(id:Int, target: AnyObject, action: Selector) {
        self.setWithCardId(id)
        self.setAction(target, action: action)
    }
    
    func setAction(target: AnyObject, action: Selector) {
        self.action = action
        self.target = target
    }
    

    
    func onClick() {
        if action != nil {
            self.target?.performSelector(action!, withObject: self)
        }
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

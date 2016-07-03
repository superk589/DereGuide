//
//  CardDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CGSSFoundation

class CardDetailView: UIScrollView {
    
    var fullImage:UIImageView?
    var cardImage:UIImageView?
    var card:CGSSCard!
    
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(card:CGSSCard) {
        let frame = UIScreen.mainScreen().bounds
        self.init(frame: frame)
        self.card = card
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

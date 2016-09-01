//
//  CharDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol CharDetilViewDelegate: class {
    func CardIconClick()
    
}

class CharDetailView: UIView {
    weak var delegate: CharDetilViewDelegate?
    var charIconView: CGSSCharIconView!
    var kanaSpacedLabel: UILabel!
    var charNameLabel: UILabel!
    var charCVLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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

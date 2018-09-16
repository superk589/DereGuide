//
//  LineView.swift
//  DereGuide
//
//  Created by zzk on 2017/1/18.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class LineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1 / UIScreen.main.scale
        self.layer.borderColor = UIColor.separator.cgColor
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: 1 / Screen.scale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

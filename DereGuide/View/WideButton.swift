//
//  Widebutton.swift
//  DereGuide
//
//  Created by zzk on 2017/8/18.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class WideButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 6
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        titleLabel?.textColor = .white
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

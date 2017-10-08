//
//  CharaProfileContentLabel.swift
//  DereGuide
//
//  Created by zzk on 08/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CharaProfileContentLabel: UILabel {

    var border: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        border = CAShapeLayer()
        border.strokeColor = UIColor.darkGray.cgColor
        border.lineWidth = 1
        border.lineCap = "square"
        border.lineDashPattern = [4, 2]
        layer.addSublayer(border)
        
        adjustsFontSizeToFitWidth = true
        //        baselineAdjustment = .alignCenters
        textColor = UIColor.darkGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: frame.size.height))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        border.frame = bounds
        border.path = path.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

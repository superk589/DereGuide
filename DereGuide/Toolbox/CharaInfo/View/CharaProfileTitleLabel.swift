//
//  CharaProfileTitleLabel.swift
//  DereGuide
//
//  Created by zzk on 08/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

// 带描边的Label
class CharaProfileTitleLabel: UILabel {

    override func drawText(in rect: CGRect) {
        
        let offset = self.shadowOffset
        let color = self.textColor
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(2)
        ctx?.setLineJoin(.round)
        
        ctx?.setTextDrawingMode(.stroke)
        self.textColor = UIColor.darkGray
        super.drawText(in: rect)
        
        ctx?.setTextDrawingMode(.fill)
        self.textColor = color
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in: rect)
        
        self.shadowOffset = offset
    }
}

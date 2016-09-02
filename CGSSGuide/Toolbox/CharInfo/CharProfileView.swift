//
//  CharProfileView.swift
//  CGSSGuide
//
//  Created by zzk on 16/9/1.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZYCornerRadius

//带描边的Label
class CharProfileDescLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        
        let offset = self.shadowOffset
        let color = self.textColor
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(ctx, 2)
        CGContextSetLineJoin(ctx, .Round)
        
        CGContextSetTextDrawingMode(ctx, .Stroke)
        self.textColor = UIColor.darkGrayColor()
        super.drawTextInRect(rect)
        
        CGContextSetTextDrawingMode(ctx, .Fill)
        self.textColor = color
        self.shadowOffset = CGSizeMake(0, 0)
        super.drawTextInRect(rect)
        
        self.shadowOffset = offset
        
    }
}

class CharProfileDescView: UIView {
    var label: CharProfileDescLabel!
    var iv: UIImageView!
    var text: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        iv = UIImageView.init(frame: self.bounds)
        addSubview(iv)
        label = CharProfileDescLabel.init(frame: CGRectMake(5, 0, frame.size.width - 10, frame.size.height))
        label.font = UIFont.boldSystemFontOfSize(16)
        addSubview(label)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        iv.zy_cornerRadiusAdvance(6, rectCornerType: .AllCorners)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//带虚线下划线的Label
class CharProfileContentLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let border = CAShapeLayer()
        border.strokeColor = UIColor.darkGrayColor().CGColor
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, frame.size.height))
        path.addLineToPoint(CGPointMake(frame.size.width, frame.size.height))
        border.path = path.CGPath
        border.frame = self.bounds
        border.lineWidth = 1
        border.lineCap = "square"
        border.lineDashPattern = [4, 2]
        layer.addSublayer(border)
        
        self.adjustsFontSizeToFitWidth = true
        self.textColor = UIColor.darkGrayColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class CharProfileViewCell: UIView {
    var descLabel: CharProfileDescView!
    var contentLabel: CharProfileContentLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        descLabel = CharProfileDescView.init(frame: CGRectMake(0, 0, 60, 30))
        contentLabel = CharProfileContentLabel.init(frame: CGRectMake(65, 0, frame.size.width - 65, 30))
        addSubview(descLabel)
        addSubview(contentLabel)
    }
    
    func setup(desc: String, content: String) {
        descLabel.text = desc
        contentLabel.text = content
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CharProfileView: UIView {
    var nameKanaCell: CharProfileViewCell!
    var heightCell: CharProfileViewCell!
    var ageCell: CharProfileViewCell!
    var weightCell: CharProfileViewCell!
    var birthdayCell: CharProfileViewCell!
    var bloodCell: CharProfileViewCell!
    var handCell: CharProfileViewCell!
    var threeSizeCell: CharProfileViewCell!
    var constellationCell: CharProfileViewCell!
    var homeTownCell: CharProfileViewCell!
    var favoriteCell: CharProfileViewCell!
    var voiceCell: CharProfileViewCell!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let width = frame.size.width
        let height: CGFloat = 30
        let space: CGFloat = 10
        var originY: CGFloat = 0
        nameKanaCell = CharProfileViewCell.init(frame: CGRectMake(0, originY, width, height))
        originY += height + space
        heightCell = CharProfileViewCell.init(frame: CGRectMake(0, originY, width / 2, height))
        ageCell = CharProfileViewCell.init(frame: CGRectMake(width / 2, originY, width / 2, height))
        originY += height + space
        weightCell = CharProfileViewCell.init(frame: CGRectMake(0, originY, width / 2, height))
        birthdayCell = CharProfileViewCell.init(frame: CGRectMake(width / 2, originY, width / 2, height))
        originY += height + space
        bloodCell = CharProfileViewCell.init(frame: CGRectMake(0, originY, width / 2, height))
        handCell = CharProfileViewCell.init(frame: CGRectMake(width / 2, originY, width / 2, height))
        originY += height + space
        threeSizeCell = CharProfileViewCell.init(frame: CGRectMake(0, originY, width, height))
        originY += height + space
        constellationCell = CharProfileViewCell.init(frame: CGRectMake(0, originY, width, height))
        originY += height + space
//        homeTownCell = CharProfileViewCell.init(frame: CGRectMake(0, originY, width, height))
//        originY += height
        favoriteCell = CharProfileViewCell.init(frame: CGRectMake(0, originY, width, height))
        originY += height + space
        voiceCell = CharProfileViewCell.init(frame: CGRectMake(0, originY, width, height))
        
        fheight = voiceCell.fheight + voiceCell.fy
        
        addSubview(nameKanaCell)
        addSubview(heightCell)
        addSubview(ageCell)
        addSubview(weightCell)
        addSubview(birthdayCell)
        addSubview(bloodCell)
        addSubview(handCell)
        addSubview(threeSizeCell)
        addSubview(constellationCell)
        // addSubview(homeTownCell)
        addSubview(favoriteCell)
        addSubview(voiceCell)
    }
    
    func setup(char: CGSSChar) {
        nameKanaCell.setup("姓名假名", content: char.kanaSpaced)
        heightCell.setup("身高", content: "\(char.height)cm")
        ageCell.setup("年龄", content: char.ageToString)
        weightCell.setup("体重", content: "\(char.weight)kg")
        birthdayCell.setup("生日", content: "\(char.birthMonth)月\(char.birthDay)日")
        bloodCell.setup("血型", content: char.bloodTypeToString)
        handCell.setup("习惯用手", content: char.handToString)
        threeSizeCell.setup("三围", content: char.threeSizeToString)
        constellationCell.setup("星座", content: char.constellationToString)
        // homeTownCell.setup("出生地", content: String)
        favoriteCell.setup("兴趣", content: char.favorite)
        voiceCell.setup("CV", content: char.voice)
        for subView in subviews {
            let iv = (subView as! CharProfileViewCell).descLabel.iv
            iv.tintColor = char.attColor.colorWithAlphaComponent(0.5)
            iv.image = UIImage.init(named: "icon_placeholder")?.imageWithRenderingMode(.AlwaysTemplate)
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

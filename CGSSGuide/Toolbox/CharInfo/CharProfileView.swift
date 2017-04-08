//
//  CharProfileView.swift
//  CGSSGuide
//
//  Created by zzk on 16/9/1.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKCornerRadiusView

//带描边的Label
class CharProfileDescLabel: UILabel {
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

class CharProfileDescView: UIView {
    var label: CharProfileDescLabel!
    var iv: ZKCornerRadiusView!
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
        iv = ZKCornerRadiusView.init(frame: self.bounds)
        addSubview(iv)
        label = CharProfileDescLabel.init(frame: CGRect(x: 5, y: 0, width: frame.size.width - 10, height: frame.size.height))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(label)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        iv.zk.cornerRadius = 6
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
        border.strokeColor = UIColor.darkGray.cgColor
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: frame.size.height))
        path.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        border.path = path.cgPath
        border.frame = self.bounds
        border.lineWidth = 1
        border.lineCap = "square"
        border.lineDashPattern = [4, 2]
        layer.addSublayer(border)
        
        self.adjustsFontSizeToFitWidth = true
        self.textColor = UIColor.darkGray
        
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
        descLabel = CharProfileDescView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        contentLabel = CharProfileContentLabel.init(frame: CGRect(x: 65, y: 0, width: frame.size.width - 65, height: 30))
        addSubview(descLabel)
        addSubview(contentLabel)
    }
    
    func setup(_ desc: String, content: String) {
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
        nameKanaCell = CharProfileViewCell.init(frame: CGRect(x: 0, y: originY, width: width, height: height))
        originY += height + space
        heightCell = CharProfileViewCell.init(frame: CGRect(x: 0, y: originY, width: width / 2, height: height))
        ageCell = CharProfileViewCell.init(frame: CGRect(x: width / 2, y: originY, width: width / 2, height: height))
        originY += height + space
        weightCell = CharProfileViewCell.init(frame: CGRect(x: 0, y: originY, width: width / 2, height: height))
        birthdayCell = CharProfileViewCell.init(frame: CGRect(x: width / 2, y: originY, width: width / 2, height: height))
        originY += height + space
        bloodCell = CharProfileViewCell.init(frame: CGRect(x: 0, y: originY, width: width / 2, height: height))
        handCell = CharProfileViewCell.init(frame: CGRect(x: width / 2, y: originY, width: width / 2, height: height))
        originY += height + space
        threeSizeCell = CharProfileViewCell.init(frame: CGRect(x: 0, y: originY, width: width, height: height))
        originY += height + space
        constellationCell = CharProfileViewCell.init(frame: CGRect(x: 0, y: originY, width: width, height: height))
        originY += height + space
        homeTownCell = CharProfileViewCell.init(frame: CGRect(x: 0, y: originY, width: width, height: height))
        originY += height + space
        favoriteCell = CharProfileViewCell.init(frame: CGRect(x: 0, y: originY, width: width, height: height))
        originY += height + space
        voiceCell = CharProfileViewCell.init(frame: CGRect(x: 0, y: originY, width: width, height: height))
        
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
        addSubview(homeTownCell)
        addSubview(favoriteCell)
        addSubview(voiceCell)
    }
    
    func setup(_ char: CGSSChar) {
        nameKanaCell.setup(NSLocalizedString("姓名假名", comment: "角色信息页面"), content: char.kanaSpaced!)
        heightCell.setup(NSLocalizedString("身高", comment: "角色信息页面"), content: "\(char.height!)cm")
        ageCell.setup(NSLocalizedString("年龄", comment: "角色信息页面"), content: char.ageToString)
        weightCell.setup(NSLocalizedString("体重", comment: "角色信息页面"), content: "\(char.weightToString)")
        birthdayCell.setup(NSLocalizedString("生日", comment: "角色信息页面"), content: String.init(format: NSLocalizedString("%d月%d日", comment: "角色信息页面"), char.birthMonth!, char.birthDay!))
        bloodCell.setup(NSLocalizedString("血型", comment: "角色信息页面"), content: char.bloodTypeToString)
        handCell.setup(NSLocalizedString("习惯用手", comment: "角色信息页面"), content: char.handToString)
        threeSizeCell.setup(NSLocalizedString("三围", comment: "角色信息页面"), content: char.threeSizeToString)
        constellationCell.setup(NSLocalizedString("星座", comment: "角色信息页面"), content: char.constellationToString)
        homeTownCell.setup(NSLocalizedString("出生地", comment: "角色信息页面"), content: char.homeTownToString)
        favoriteCell.setup(NSLocalizedString("兴趣", comment: "角色信息页面"), content: char.favorite)
        voiceCell.setup("CV", content: char.voiceFromDB ?? "")
        for subView in subviews {
            let iv = (subView as! CharProfileViewCell).descLabel.iv
            iv?.zk.backgroundColor = char.attColor.withAlphaComponent(0.5)
            iv?.render()
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

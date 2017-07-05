//
//  CharProfileView.swift
//  CGSSGuide
//
//  Created by zzk on 16/9/1.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import ZKCornerRadiusView

// 带描边的Label
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
    var backgoundImageView: ZKCornerRadiusView!
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
        backgoundImageView = ZKCornerRadiusView()
        addSubview(backgoundImageView)
        backgoundImageView.zk.cornerRadius = 6
        backgoundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        label = CharProfileDescLabel.init(frame: CGRect(x: 5, y: 0, width: frame.size.width - 10, height: frame.size.height))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(label)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(5)
            make.right.lessThanOrEqualTo(-5)
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgoundImageView.image = nil
        backgoundImageView.render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 带虚线下划线的Label
class CharProfileContentLabel: UILabel {
    
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

class CharProfileViewCell: UIView {
    
    var descLabel: CharProfileDescView!
    var contentLabel: CharProfileContentLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        descLabel = CharProfileDescView()
        // .init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        contentLabel = CharProfileContentLabel()
        // .init(frame: CGRect(x: 65, y: 0, width: frame.size.width - 65, height: 30))
        addSubview(descLabel)
        addSubview(contentLabel)
        
        descLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel.snp.right).offset(5)
            make.right.top.bottom.equalToSuperview()
        }
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
    
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameKanaCell = CharProfileViewCell()
        
        heightCell = CharProfileViewCell()
        
        ageCell = CharProfileViewCell()
        
        let stackView1 = UIStackView(arrangedSubviews: [heightCell, ageCell])
        stackView1.distribution = .fillEqually
        
        weightCell = CharProfileViewCell()
        birthdayCell = CharProfileViewCell()
        
        let stackView2 = UIStackView(arrangedSubviews: [weightCell, birthdayCell])
        stackView2.distribution = .fillEqually
        
        
        bloodCell = CharProfileViewCell()
        
        handCell = CharProfileViewCell()
        
        let stackView3 = UIStackView(arrangedSubviews: [bloodCell, handCell])
        stackView3.distribution = .fillEqually
        
        
        threeSizeCell = CharProfileViewCell()
        
        constellationCell = CharProfileViewCell()
        
        homeTownCell = CharProfileViewCell()
        
        favoriteCell = CharProfileViewCell()
        
        voiceCell = CharProfileViewCell()
        
        stackView = UIStackView(arrangedSubviews: [nameKanaCell, stackView1, stackView2, stackView3, threeSizeCell, constellationCell, homeTownCell, favoriteCell, voiceCell])
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(30 * 9 + 10 * 8)
        }
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
        
        for subView in stackView.arrangedSubviews {
            if let backgroundImageView = (subView as? CharProfileViewCell)?.descLabel.backgoundImageView {
                backgroundImageView.zk.backgroundColor = char.attColor.lighter()
            } else if let views = (subView as? UIStackView)?.arrangedSubviews {
                for view in views {
                    if let backgroundImageView = (view as? CharProfileViewCell)?.descLabel.backgoundImageView {
                        backgroundImageView.zk.backgroundColor = char.attColor.lighter()
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

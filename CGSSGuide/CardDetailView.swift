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
  
    
    var fullImageView:UIImageView?

    var cardIconView:UIImageView!
    var cardNameLabel:UILabel!
    var rarityLabel:UILabel!
    var titleLabel:UILabel!
    var attGridView:CGSSGridView!
    var rankGridView:CGSSGridView!
    
    var originY:CGFloat!
    
    var skillNameLabel:UILabel!
    var skillDescriptionLabel:UILabel!
    var skillProcGridView:CGSSGridView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.whiteColor()
        //self.bounces = false
        
        //全尺寸大图视图
        let fullImageHeigth = CGSSTool.width/CGSSTool.fullImageWidth*CGSSTool.fullImageHeight
        self.fullImageView = UIImageView()
        fullImageView?.frame = CGRectMake(0, 0, CGSSTool.width, fullImageHeigth)
        addSubview(fullImageView!)

        //人物名称 图标视图
        originY = fullImageHeigth
        cardIconView = UIImageView()
        cardIconView.frame = CGRectMake(5, originY + 5, 48, 48)
        
        rarityLabel = UILabel()
        rarityLabel.frame = CGRectMake(58, originY + 11, 30, 10)
        rarityLabel.textAlignment = .Left
        rarityLabel.font = UIFont.systemFontOfSize(10)
        
//        skillLabel = UILabel()
//        skillLabel.frame = CGRectMake(CGSSTool.width - 150, 5, 140, 10)
//        skillLabel.font = UIFont.systemFontOfSize(10)
//        skillLabel.textAlignment = .Right
        
        cardNameLabel = UILabel()
        cardNameLabel.frame = CGRectMake(58, originY + 26, CGSSTool.width - 68, 16)
        cardNameLabel.font = UIFont.systemFontOfSize(16)
        
        
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(88, originY + 11, CGSSTool.width - 150, 10)
        titleLabel.font = UIFont.systemFontOfSize(10)
//        titleLabel.layer.borderWidth = 1/UIScreen.mainScreen().scale
//        titleLabel.layer.borderColor = UIColor.blackColor().CGColor
        
        addSubview(cardIconView)
        addSubview(rarityLabel)
        addSubview(cardNameLabel)
        addSubview(titleLabel)
        
        //属性表格
        originY = originY + 58
        
        let attContentView = UIView()
        attContentView.frame = CGRectMake(-1, originY, CGSSTool.width+2, 99)
        let descLabel1 = UILabel()
        descLabel1.frame = CGRectMake(10, 5, 80, 14)
        descLabel1.textColor = UIColor.blackColor()
        descLabel1.font = UIFont.systemFontOfSize(14)
        descLabel1.text = "卡片属性:"
        attContentView.addSubview(descLabel1)
        
        attGridView = CGSSGridView(frame: CGRectMake(5, 24, CGSSTool.width - 10, 70), rows: 5, columns: 6)
        //attGridView.layer.borderColor = UIColor.blackColor().CGColor
        //attGridView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        attContentView.addSubview(attGridView)
        attContentView.layer.borderColor = UIColor.blackColor().CGColor
        attContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        addSubview(attContentView)
        originY = originY + 99

        //属性排名表格
        let rankContentView = UIView()
        rankContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 71)
        let descLabel2 = UILabel()
        descLabel2.frame = CGRectMake(10, 5, 80, 14)
        descLabel2.textColor = UIColor.blackColor()
        descLabel2.font = UIFont.systemFontOfSize(14)
        descLabel2.text = "属性排名:"
        rankContentView.addSubview(descLabel2)
        
        rankGridView = CGSSGridView(frame: CGRectMake(5, 24, CGSSTool.width - 10, 42), rows: 3, columns: 5)
        rankContentView.addSubview(rankGridView)
        
        
        rankContentView.layer.borderColor = UIColor.blackColor().CGColor
        rankContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        addSubview(rankContentView)

        
        originY = originY + 71
        
        
        
        
        //
        //originY = originY + 300
        contentSize = CGSizeMake(CGSSTool.width, originY)
        
    }
    
    
    
    convenience init() {
        let frame = CGRectMake(0, 0, CGSSTool.width, CGSSTool.height)
        self.init(frame: frame)
    }
    
    func setWithoutSpreadImage() {
        self.bounds.origin.y -= CGSSTool.fullImageWidth/CGSSTool.width*CGSSTool.fullImageHeight
    }

    
    func setSkillContentView() {
        //主动技能
        let skillContentView = UIView()
        skillContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 71)
        let descLabel3 = UILabel()
        descLabel3.frame = CGRectMake(10, 5, 80, 14)
        descLabel3.textColor = UIColor.blackColor()
        descLabel3.font = UIFont.systemFontOfSize(14)
        descLabel3.text = "主动技能:"
        skillContentView.addSubview(descLabel3)
        
        skillNameLabel = UILabel()
        skillNameLabel.frame = CGRectMake(90, 5, CGSSTool.width-95, 14)
        skillNameLabel.font = UIFont.systemFontOfSize(14)
        skillContentView.addSubview(skillNameLabel)
        
        skillDescriptionLabel = UILabel()
        skillDescriptionLabel.numberOfLines = 2
        skillDescriptionLabel.lineBreakMode = .ByCharWrapping
        skillDescriptionLabel.font = UIFont.systemFontOfSize(12)
        skillDescriptionLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        skillDescriptionLabel.frame = CGRectMake(10, 24, CGSSTool.width-20, 30)
        skillContentView.addSubview(skillDescriptionLabel)
        
        skillProcGridView = CGSSGridView.init(frame: CGRectMake(5, 57, CGSSTool.width-10, 42), rows: 3, columns: 5)
        skillContentView.addSubview(skillProcGridView)
        
        addSubview(skillContentView)
        
        originY = originY + 104
        contentSize = CGSizeMake(CGSSTool.width, originY)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

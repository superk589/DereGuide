//
//  CardDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardDetailView: UIScrollView {
  
    
    var fullImageView:CGSSImageView?

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
    
    var leaderSkillNameLabel:UILabel!
    var leaderSkillDescriptionLabel:UILabel!
    
    var evolutionFromImageView:CGSSCardIconView!
    var evolutionToImageView:CGSSCardIconView!
    
    
    //var skillTypeLabel:UILabel!
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
        fullImageView = CGSSImageView(frame: CGRectMake(0, 0, CGSSTool.width, fullImageHeigth))
        fullImageView?.userInteractionEnabled = true
        addSubview(fullImageView!)

        //人物名称 图标视图
        originY = fullImageHeigth
        cardIconView = UIImageView()
        cardIconView.frame = CGRectMake(5, originY + 5, 48, 48)
        //边角圆滑处理
        cardIconView.layer.cornerRadius = 6
        cardIconView.layer.masksToBounds = true
        
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
        attContentView.frame = CGRectMake(-1, originY, CGSSTool.width+2, 109)
        let descLabel1 = UILabel()
        descLabel1.frame = CGRectMake(10, 10, 80, 14)
        descLabel1.textColor = UIColor.blackColor()
        descLabel1.font = UIFont.systemFontOfSize(14)
        descLabel1.text = "卡片属性:"
        attContentView.addSubview(descLabel1)
        
        attGridView = CGSSGridView(frame: CGRectMake(5, 29, CGSSTool.width - 10, 70), rows: 5, columns: 6)
        //attGridView.layer.borderColor = UIColor.blackColor().CGColor
        //attGridView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        attContentView.addSubview(attGridView)
        attContentView.layer.borderColor = UIColor.blackColor().CGColor
        attContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        addSubview(attContentView)
        originY = originY + 109

        //属性排名表格
        let rankContentView = UIView()
        rankContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 81 + (1 / UIScreen.mainScreen().scale))
        let descLabel2 = UILabel()
        descLabel2.frame = CGRectMake(10, 10, 80, 14)
        descLabel2.textColor = UIColor.blackColor()
        descLabel2.font = UIFont.systemFontOfSize(14)
        descLabel2.text = "属性排名:"
        rankContentView.addSubview(descLabel2)
        
        rankGridView = CGSSGridView(frame: CGRectMake(5, 29, CGSSTool.width - 10, 42), rows: 3, columns: 5)
        rankContentView.addSubview(rankGridView)
        
        
        rankContentView.layer.borderColor = UIColor.blackColor().CGColor
        rankContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        addSubview(rankContentView)

        
        originY = originY + 81
        
        
        
        
        //
        //originY = originY + 300
        contentSize = CGSizeMake(CGSSTool.width, originY)
        
    }
    
    
    
    convenience init() {
        let frame = CGRectMake(0, 64, CGSSTool.width, CGSSTool.height-112)
        self.init(frame: frame)
    }
    
    func setWithoutSpreadImage() {
        self.contentInset = UIEdgeInsetsMake(-(fullImageView?.frame.size.height)!, 0, 0, 0)
        //self.bounds.origin.y += 1000 //CGSSTool.fullImageWidth/CGSSTool.width*CGSSTool.fullImageHeight
        //self.contentSize
    }

    
    func setSkillContentView() {
        //主动技能
        let skillContentView = UIView()
        skillContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 114 + (1 / UIScreen.mainScreen().scale))
        let descLabel3 = UILabel()
        descLabel3.frame = CGRectMake(10, 10, 80, 14)
        descLabel3.textColor = UIColor.blackColor()
        descLabel3.font = UIFont.systemFontOfSize(14)
        descLabel3.text = "主动技能:"
        skillContentView.addSubview(descLabel3)
        
//        let descLabel4 = UILabel()
//        descLabel4.frame = CGRectMake(10, 19, 40, 10)
//        descLabel4.textColor = UIColor.blackColor()
//        descLabel4.font = UIFont.systemFontOfSize(10)
//        descLabel4.text = "类型:"
//        skillContentView.addSubview(descLabel4)

        
        skillNameLabel = UILabel()
        skillNameLabel.frame = CGRectMake(90, 10, CGSSTool.width-95, 14)
        skillNameLabel.font = UIFont.systemFontOfSize(14)
        skillContentView.addSubview(skillNameLabel)
        
//        skillTypeLabel = UILabel()
//        skillTypeLabel.frame = CGRectMake(50, 19, 140, 14)
//        skillTypeLabel.font = UIFont.systemFontOfSize(14)
//        skillTypeLabel.textAlignment = .Left
//        skillContentView.addSubview(skillTypeLabel)
        
        skillDescriptionLabel = UILabel()
        skillDescriptionLabel.numberOfLines = 2
        skillDescriptionLabel.lineBreakMode = .ByCharWrapping
        skillDescriptionLabel.font = UIFont.systemFontOfSize(12)
        skillDescriptionLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        skillDescriptionLabel.frame = CGRectMake(10, 29, CGSSTool.width-20, 30)
        skillContentView.addSubview(skillDescriptionLabel)
        
        skillProcGridView = CGSSGridView.init(frame: CGRectMake(5, 62, CGSSTool.width-10, 42), rows: 3, columns: 5)
        skillContentView.addSubview(skillProcGridView)
        skillContentView.layer.borderColor = UIColor.blackColor().CGColor
        skillContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        addSubview(skillContentView)
        
        originY = originY + 114
        contentSize = CGSizeMake(CGSSTool.width, originY+20)
    }
    
    func setLeaderSkillContentView() {
        //主动技能
        let leaderSkillContentView = UIView()
        leaderSkillContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 69 + (1 / UIScreen.mainScreen().scale))
        let descLabel4 = UILabel()
        descLabel4.frame = CGRectMake(10, 10, 80, 14)
        descLabel4.textColor = UIColor.blackColor()
        descLabel4.font = UIFont.systemFontOfSize(14)
        descLabel4.text = "队长技能:"
        leaderSkillContentView.addSubview(descLabel4)
        
        //        let descLabel4 = UILabel()
        //        descLabel4.frame = CGRectMake(10, 19, 40, 10)
        //        descLabel4.textColor = UIColor.blackColor()
        //        descLabel4.font = UIFont.systemFontOfSize(10)
        //        descLabel4.text = "类型:"
        //        skillContentView.addSubview(descLabel4)
        
        
        leaderSkillNameLabel = UILabel()
        leaderSkillNameLabel.frame = CGRectMake(90, 10, CGSSTool.width-95, 14)
        leaderSkillNameLabel.font = UIFont.systemFontOfSize(14)
        leaderSkillContentView.addSubview(leaderSkillNameLabel)
        
        //        skillTypeLabel = UILabel()
        //        skillTypeLabel.frame = CGRectMake(50, 19, 140, 14)
        //        skillTypeLabel.font = UIFont.systemFontOfSize(14)
        //        skillTypeLabel.textAlignment = .Left
        //        skillContentView.addSubview(skillTypeLabel)
        
        leaderSkillDescriptionLabel = UILabel()
        leaderSkillDescriptionLabel.numberOfLines = 2
        leaderSkillDescriptionLabel.lineBreakMode = .ByCharWrapping
        leaderSkillDescriptionLabel.font = UIFont.systemFontOfSize(12)
        leaderSkillDescriptionLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        leaderSkillDescriptionLabel.frame = CGRectMake(10, 29, CGSSTool.width-20, 30)
        //leaderSkillDescriptionLabel.contentMode = .Top //顶端左对齐
        leaderSkillContentView.addSubview(leaderSkillDescriptionLabel)
        leaderSkillContentView.layer.borderColor = UIColor.blackColor().CGColor
        leaderSkillContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        
        
        originY = originY + 69
        contentSize = CGSizeMake(CGSSTool.width, originY+20)
        addSubview(leaderSkillContentView)
    }

    func setEvolutionContentView() {
        let evolutionContentView = UIView()
        evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 87 + (1 / UIScreen.mainScreen().scale))
        let descLabel4 = UILabel()
        descLabel4.frame = CGRectMake(10, 10, 80, 14)
        descLabel4.textColor = UIColor.blackColor()
        descLabel4.font = UIFont.systemFontOfSize(14)
        descLabel4.text = "进化信息:"
        evolutionContentView.addSubview(descLabel4)
        
        //        let descLabel4 = UILabel()
        //        descLabel4.frame = CGRectMake(10, 19, 40, 10)
        //        descLabel4.textColor = UIColor.blackColor()
        //        descLabel4.font = UIFont.systemFontOfSize(10)
        //        descLabel4.text = "类型:"
        //        skillContentView.addSubview(descLabel4)
        
        evolutionToImageView = CGSSCardIconView(frame: CGRectMake(108, 29, 48, 48))
        evolutionFromImageView = CGSSCardIconView(frame: CGRectMake(5, 29, 48, 48))
        evolutionToImageView.userInteractionEnabled = true
        evolutionContentView.addSubview(evolutionToImageView)
        evolutionContentView.addSubview(evolutionFromImageView)
        
        let descLabel5 = UILabel()
        descLabel5.frame = CGRectMake(53, 29, 50, 48)
        descLabel5.textColor = UIColor.blackColor()
        descLabel5.font = UIFont.systemFontOfSize(24)
        descLabel5.text = " >> "
        descLabel5.textAlignment = .Center
        evolutionContentView.addSubview(descLabel5)        //        skillTypeLabel = UILabel()
        //        skillTypeLabel.frame = CGRectMake(50, 19, 140, 14)
        //        skillTypeLabel.font = UIFont.systemFontOfSize(14)
        //        skillTypeLabel.textAlignment = .Left
        //        skillContentView.addSubview(skillTypeLabel)
        
        
        evolutionContentView.layer.borderColor = UIColor.blackColor().CGColor
        evolutionContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        
        
        originY = originY + 87
        contentSize = CGSizeMake(CGSSTool.width, originY+20)
        addSubview(evolutionContentView)
    }
    
    func setCharInfoContentView() {
//        public var age:Int?
//        //    "age": 20,
//        //    ; If this is ridiculously high, index into category 6
//        //    ; of text_data.
//        public var birth_day:Int?
//        //    "birth_day": 26,
//        public var birth_month:Int?
//        //    "birth_month": 2,
//        public var blood_type:Int?
//        //    "blood_type": 2002,
//        //    ; Category 3 of text_data.
//        public var body_size_1:Int?
//        //    "body_size_1": 86,
//        public var body_size_2:Int?
//        //    "body_size_2": 57,
//        public var body_size_3:Int?
//        //    "body_size_3": 86,
//        public var chara_id:Int?
//        //    "chara_id": 168,
//        public var constellation:Int?
//        //    "constellation": 1005,
//        //    ; Category 4 of text_data.
//        public var conventional:String?
//        //    "conventional": "Kurokawa Chiaki",
//        public var favorite:String?
//        //    "favorite": "クラシック鑑賞",
//        public var hand:Int?
//        //    "hand": 3001,
//        //    ; Category 5 of text_data (subtract 3000 for index).
//        public var height:Int?
//        //    "height": 163,
//        public var home_town:Int?
//        //    "home_town": 12,
//        //    ; Category 2 of text_data.
//        public var kana_spaced:String?
//        //    "kana_spaced": "くろかわ ちあき",
//        public var kanji_spaced:String?
//        //    "kanji_spaced": "黒川 千秋",
//        public var model_bust_id:Int?
//        //    "model_bust_id": 2,
//        public var model_height_id:Int?
//        //    "model_height_id": 2,
//        public var model_skin_id:Int?
//        //    "model_skin_id": 1,
//        public var model_wight_id:Int?
//        //    "model_weight_id": 0,
//        public var name:String?
//        //    "name": "黒川千秋",
//        public var name_kana:String?
//        //    "name_kana": "くろかわちあき",
//        public var personality:Int?
//        //    "personality": 3,
//        public var spine_size:Int?
//        //    "spine_size": 1,
//        public var type:String?
//        //    "type": "cool",
//        //    ; Any of "cool", "cute", "passion", "office"
//        //    ; (last one reserved for Chihiro)
//        //    "valist": [],
//        public var valist:NSMutableArray?
//        public var voice:String?
//        //    "voice": "",
//        //    ; Voice actress name (Japanese)
//        public var weight:Int?
//        //    "weight": 45
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

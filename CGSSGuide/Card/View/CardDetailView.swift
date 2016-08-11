//
//  CardDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardDetailView: UIScrollView {
  
    //滚动视图内容距底部边距
    static let bottomInset:CGFloat = 60
    
    var fullImageView:CGSSImageView?

    var cardIconView:CGSSCardIconView!
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
    
    var priceLabel:UILabel!
    
    
    //var skillTypeLabel:UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var topSpace:CGFloat = 10
    

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
        originY = fullImageHeigth + topSpace
        cardIconView = CGSSCardIconView.init(frame: CGRectMake(10, originY, 48, 48))
            
        rarityLabel = UILabel()
        rarityLabel.frame = CGRectMake(68, originY + 5, 30, 10)
        rarityLabel.textAlignment = .Left
        rarityLabel.font = UIFont.systemFontOfSize(10)
        
//        skillLabel = UILabel()
//        skillLabel.frame = CGRectMake(CGSSTool.width - 150, 5, 140, 10)
//        skillLabel.font = UIFont.systemFontOfSize(10)
//        skillLabel.textAlignment = .Right
        
        cardNameLabel = UILabel()
        cardNameLabel.frame = CGRectMake(68, originY + 27, CGSSTool.width - 78, 16)
        cardNameLabel.font = UIFont.systemFontOfSize(16)
        
        
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(98, originY + 5, CGSSTool.width - 150, 10)
        titleLabel.font = UIFont.systemFontOfSize(10)
//        titleLabel.layer.borderWidth = 1/UIScreen.mainScreen().scale
//        titleLabel.layer.borderColor = UIColor.blackColor().CGColor
        
        addSubview(cardIconView)
        addSubview(rarityLabel)
        addSubview(cardNameLabel)
        addSubview(titleLabel)
        
        //属性表格
        originY = originY + topSpace + 48
        
        //let attContentView = UIView()
        //attContentView.frame = CGRectMake(-1, originY, CGSSTool.width+2, 109)
        let descLabel1 = UILabel()
        descLabel1.frame = CGRectMake(10, originY, 80, 14)
        descLabel1.textColor = UIColor.blackColor()
        descLabel1.font = UIFont.systemFontOfSize(14)
        descLabel1.text = "卡片属性:"
        descLabel1.textColor = UIColor.darkGrayColor()
        //attContentView.addSubview(descLabel1)
        addSubview(descLabel1)
        
        originY = originY + topSpace + 14
        
        attGridView = CGSSGridView(frame: CGRectMake(10, originY, CGSSTool.width - 20, 70), rows: 5, columns: 6)
        //attGridView.layer.borderColor = UIColor.blackColor().CGColor
        //attGridView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        //attContentView.addSubview(attGridView)
        addSubview(attGridView)
        //attContentView.layer.borderColor = UIColor.blackColor().CGColor
        //attContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        //addSubview(attContentView)
        originY = originY + topSpace * 2 + 70

        
        //属性排名表格
        //let rankContentView = UIView()
        //rankContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 81 + (1 / UIScreen.mainScreen().scale))
        let descLabel2 = UILabel()
        descLabel2.frame = CGRectMake(10, originY, 80, 14)
        descLabel2.textColor = UIColor.blackColor()
        descLabel2.font = UIFont.systemFontOfSize(14)
        descLabel2.text = "属性排名:"
        descLabel2.textColor = UIColor.darkGrayColor()
        //rankContentView.addSubview(descLabel2)
        addSubview(descLabel2)
        originY = originY + topSpace + 14
        
        rankGridView = CGSSGridView(frame: CGRectMake(10, originY, CGSSTool.width - 20, 42), rows: 3, columns: 5)
        //rankContentView.addSubview(rankGridView)
        addSubview(rankGridView)
        
        //rankContentView.layer.borderColor = UIColor.blackColor().CGColor
        //rankContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        //addSubview(rankContentView)

        
        originY = originY + topSpace * 2 + 42
        
        
        
        
        //
        //originY = originY + 300
        contentSize = CGSizeMake(CGSSTool.width, originY + CardDetailView.bottomInset)
        
    }
    
    
    
    convenience init() {
        let frame = CGRectMake(0, 64, CGSSTool.width, CGSSTool.height-64)
        self.init(frame: frame)
    }
    
    func setWithoutSpreadImage() {
        self.contentInset = UIEdgeInsetsMake(-(fullImageView?.frame.size.height)!, 0, 0, 0)
        //self.bounds.origin.y += 1000 //CGSSTool.fullImageWidth/CGSSTool.width*CGSSTool.fullImageHeight
        //self.contentSize
    }

    
    func setSkillContentView(skill:CGSSSkill) {
        //let skillContentView = UIView()
        //skillContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 129 + (1 / UIScreen.mainScreen().scale))
        let descLabel3 = UILabel()
        descLabel3.frame = CGRectMake(10, originY, 80, 14)
        descLabel3.textColor = UIColor.blackColor()
        descLabel3.font = UIFont.systemFontOfSize(14)
        descLabel3.text = "主动技能:"
        descLabel3.textColor = UIColor.darkGrayColor()
        //skillContentView.addSubview(descLabel3)
        addSubview(descLabel3)
//        let descLabel4 = UILabel()
//        descLabel4.frame = CGRectMake(10, 19, 40, 10)
//        descLabel4.textColor = UIColor.blackColor()
//        descLabel4.font = UIFont.systemFontOfSize(10)
//        descLabel4.text = "类型:"
//        skillContentView.addSubview(descLabel4)

        
        
        skillNameLabel = UILabel()
        skillNameLabel.frame = CGRectMake(90, originY, CGSSTool.width-95, 14)
        skillNameLabel.font = UIFont.systemFontOfSize(14)
        skillNameLabel.text = skill.skill_name
        //skillContentView.addSubview(skillNameLabel)
        addSubview(skillNameLabel)
//        skillTypeLabel = UILabel()
//        skillTypeLabel.frame = CGRectMake(50, 19, 140, 14)
//        skillTypeLabel.font = UIFont.systemFontOfSize(14)
//        skillTypeLabel.textAlignment = .Left
//        skillContentView.addSubview(skillTypeLabel)
        
        originY = originY + topSpace + 14
        skillDescriptionLabel = UILabel()
        skillDescriptionLabel.numberOfLines = 0
        skillDescriptionLabel.lineBreakMode = .ByCharWrapping
        skillDescriptionLabel.font = UIFont.systemFontOfSize(12)
        skillDescriptionLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        skillDescriptionLabel.frame = CGRectMake(10, originY, CGSSTool.width-20, 45)
        skillDescriptionLabel.text = skill.explain_en
        skillDescriptionLabel.sizeToFit()
        //skillContentView.addSubview(skillDescriptionLabel)
        addSubview(skillDescriptionLabel)
        
        originY = originY + topSpace + skillDescriptionLabel.frame.height
        skillProcGridView = CGSSGridView.init(frame: CGRectMake(10, originY, CGSSTool.width-20, 42), rows: 3, columns: 5)
        //skillContentView.addSubview(skillProcGridView)
        //skillContentView.layer.borderColor = UIColor.blackColor().CGColor
        //skillContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        //addSubview(skillContentView)
        addSubview(skillProcGridView)
        
        var procGridStrings = [[String]]()
        let procChanceMax = Double((skill.proc_chance?.1)!) / 100
        let procChanceMin = Double((skill.proc_chance?.0)!) / 100
        let durationMax = Double((skill.effect_length?.1)!) / 100
        let durationMin = Double((skill.effect_length?.0)!) / 100
        procGridStrings.append(["  ","触发几率%","持续时间s","最大覆盖率%","平均覆盖率%"])
        procGridStrings.append(["Lv.1",String(format: "%.2f", procChanceMin), String(format: "%.2f",durationMin)
            ,String(format:"%.2f", durationMin/Double(skill.condition!)*100),String(format:"%.2f", durationMin/Double(skill.condition!)*procChanceMin)])
        procGridStrings.append(["Lv.10",String(format: "%.2f",procChanceMax), String(format: "%.2f", durationMax)
            ,String(format:"%.2f", durationMax/Double(skill.condition!)*100),String(format:"%.2f", durationMax/Double(skill.condition!)*procChanceMax)])
        skillProcGridView.setGridContent(procGridStrings)

        
        originY = originY + topSpace * 2 + 42
        contentSize = CGSizeMake(CGSSTool.width, originY + CardDetailView.bottomInset)
    }
    
    func setLeaderSkillContentView(leaderSkill:CGSSLeaderSkill) {
        //let leaderSkillContentView = UIView()
        //leaderSkillContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 69 + (1 / UIScreen.mainScreen().scale))
        let descLabel4 = UILabel()
        descLabel4.frame = CGRectMake(10, originY, 80, 14)
        descLabel4.textColor = UIColor.blackColor()
        descLabel4.font = UIFont.systemFontOfSize(14)
        descLabel4.text = "队长技能:"
        descLabel4.textColor = UIColor.darkGrayColor()
        //leaderSkillContentView.addSubview(descLabel4)
        addSubview(descLabel4)
        
        //        let descLabel4 = UILabel()
        //        descLabel4.frame = CGRectMake(10, 19, 40, 10)
        //        descLabel4.textColor = UIColor.blackColor()
        //        descLabel4.font = UIFont.systemFontOfSize(10)
        //        descLabel4.text = "类型:"
        //        skillContentView.addSubview(descLabel4)
        
        
        leaderSkillNameLabel = UILabel()
        leaderSkillNameLabel.frame = CGRectMake(90, originY, CGSSTool.width-100, 14)
        leaderSkillNameLabel.font = UIFont.systemFontOfSize(14)
        leaderSkillNameLabel.text = leaderSkill.name
      
        //leaderSkillContentView.addSubview(leaderSkillNameLabel)
        addSubview(leaderSkillNameLabel)
        //        skillTypeLabel = UILabel()
        //        skillTypeLabel.frame = CGRectMake(50, 19, 140, 14)
        //        skillTypeLabel.font = UIFont.systemFontOfSize(14)
        //        skillTypeLabel.textAlignment = .Left
        //        skillContentView.addSubview(skillTypeLabel)
        
        originY = originY + topSpace + 14
        leaderSkillDescriptionLabel = UILabel()
        leaderSkillDescriptionLabel.numberOfLines = 0
        leaderSkillDescriptionLabel.lineBreakMode = .ByCharWrapping
        leaderSkillDescriptionLabel.font = UIFont.systemFontOfSize(12)
        leaderSkillDescriptionLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        leaderSkillDescriptionLabel.frame = CGRectMake(10, originY, CGSSTool.width-20, 30)
        leaderSkillDescriptionLabel.text = leaderSkill.explain_en
        leaderSkillDescriptionLabel.sizeToFit()

        //leaderSkillDescriptionLabel.contentMode = .Top //顶端左对齐
        //leaderSkillContentView.addSubview(leaderSkillDescriptionLabel)
        //leaderSkillContentView.layer.borderColor = UIColor.blackColor().CGColor
        //leaderSkillContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        addSubview(leaderSkillDescriptionLabel)
        
        originY = originY + topSpace * 2 + leaderSkillDescriptionLabel.frame.size.height
        contentSize = CGSizeMake(CGSSTool.width, originY + CardDetailView.bottomInset)
        //addSubview(leaderSkillContentView)
    }

    //设置进化信息视图
    func setEvolutionContentView() {
        //let evolutionContentView = UIView()
        //evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 92 + (1 / UIScreen.mainScreen().scale))
        let descLabel4 = UILabel()
        descLabel4.frame = CGRectMake(10, originY, 80, 14)
        descLabel4.textColor = UIColor.blackColor()
        descLabel4.font = UIFont.systemFontOfSize(14)
        descLabel4.text = "进化信息:"
        descLabel4.textColor = UIColor.darkGrayColor()
        //evolutionContentView.addSubview(descLabel4)
        addSubview(descLabel4)
        //        let descLabel4 = UILabel()
        //        descLabel4.frame = CGRectMake(10, 19, 40, 10)
        //        descLabel4.textColor = UIColor.blackColor()
        //        descLabel4.font = UIFont.systemFontOfSize(10)
        //        descLabel4.text = "类型:"
        //        skillContentView.addSubview(descLabel4)
        
        originY = originY + topSpace + 14
        
        evolutionToImageView = CGSSCardIconView(frame: CGRectMake(113, originY, 48, 48))
        evolutionFromImageView = CGSSCardIconView(frame: CGRectMake(10, originY, 48, 48))
        //evolutionContentView.addSubview(evolutionToImageView)
        //evolutionContentView.addSubview(evolutionFromImageView)
        addSubview(evolutionToImageView)
        addSubview(evolutionFromImageView)
        let descLabel5 = UILabel()
        descLabel5.frame = CGRectMake(58, originY, 50, 48)
        descLabel5.textColor = UIColor.blackColor()
        descLabel5.font = UIFont.systemFontOfSize(24)
        descLabel5.text = " >> "
        descLabel5.textAlignment = .Center
        //evolutionContentView.addSubview(descLabel5)
        addSubview(descLabel5)
        //evolutionContentView.layer.borderColor = UIColor.blackColor().CGColor
        //evolutionContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        
        originY = originY + topSpace * 2 + 48
        contentSize = CGSizeMake(CGSSTool.width, originY + CardDetailView.bottomInset)
        //addSubview(evolutionContentView)
    }
    
    //设置角色信息视图
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
    
    //设置出售价格视图
    func setPriceContentView() {
        let priceContentView = UIView()
        priceContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSTool.width+2, 51 + (1 / UIScreen.mainScreen().scale))
        let descLabel4 = UILabel()
        descLabel4.frame = CGRectMake(10, 10, 80, 14)
        descLabel4.textColor = UIColor.blackColor()
        descLabel4.font = UIFont.systemFontOfSize(14)
        descLabel4.text = "出售价格:"
        priceContentView.addSubview(descLabel4)
        
        priceLabel = UILabel()
        priceLabel.frame = CGRectMake(10, 29, 100, 12)
        priceLabel.font = UIFont.systemFontOfSize(12)
        priceLabel.textAlignment = .Left
        priceContentView.addSubview(priceLabel)
        
        priceContentView.layer.borderColor = UIColor.blackColor().CGColor
        priceContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        
        originY = originY + 51
        
        contentSize = CGSizeMake(CGSSTool.width, originY + CardDetailView.bottomInset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

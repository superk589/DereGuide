//
//  CardDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol CardDetailViewDelegate: class {
    func iconClick(icon: CGSSCardIconView)
}

class CardDetailView: UIView {
    weak var delegate: CardDetailViewDelegate?
    // 滚动视图内容距底部边距
    static let bottomInset: CGFloat = 60
    
    var fullImageView: CGSSImageView?
    
    var cardIconView: CGSSCardIconView!
    var cardNameLabel: UILabel!
    var rarityLabel: UILabel!
    var titleLabel: UILabel!
    var attGridView: CGSSGridLabel!
    var rankGridView: CGSSGridLabel!
    
    var originY: CGFloat!
    
    var skillNameLabel: UILabel!
    var skillDescriptionLabel: UILabel!
    var skillProcGridView: CGSSGridLabel!
    
    var leaderSkillNameLabel: UILabel!
    var leaderSkillDescriptionLabel: UILabel!
    
    var evolutionFromImageView: CGSSCardIconView!
    var evolutionToImageView: CGSSCardIconView!
    
    var priceLabel: UILabel!
    
    // var skillTypeLabel:UILabel!
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    var topSpace: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        // self.bounces = false
        // 全尺寸大图视图
        let fullImageHeigth = CGSSGlobal.width / CGSSGlobal.fullImageWidth * CGSSGlobal.fullImageHeight
        fullImageView = CGSSImageView(frame: CGRectMake(0, 0, CGSSGlobal.width, fullImageHeigth))
        fullImageView?.userInteractionEnabled = true
        addSubview(fullImageView!)
        
        // 人物名称 图标视图
        originY = fullImageHeigth + topSpace
        cardIconView = CGSSCardIconView.init(frame: CGRectMake(10, originY, 48, 48))
        
        rarityLabel = UILabel()
        rarityLabel.frame = CGRectMake(68, originY + 5, 30, 10)
        rarityLabel.textAlignment = .Left
        rarityLabel.font = UIFont.systemFontOfSize(10)
        
//        skillLabel = UILabel()
//        skillLabel.frame = CGRectMake(CGSSGlobal.width - 150, 5, 140, 10)
//        skillLabel.font = UIFont.systemFontOfSize(10)
//        skillLabel.textAlignment = .Right
        
        cardNameLabel = UILabel()
        cardNameLabel.frame = CGRectMake(68, originY + 27, CGSSGlobal.width - 78, 16)
        cardNameLabel.font = UIFont.systemFontOfSize(16)
        
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(98, originY + 5, CGSSGlobal.width - 150, 10)
        titleLabel.font = UIFont.systemFontOfSize(10)
//        titleLabel.layer.borderWidth = 1/UIScreen.mainScreen().scale
//        titleLabel.layer.borderColor = UIColor.blackColor().CGColor
        
        addSubview(cardIconView)
        addSubview(rarityLabel)
        addSubview(cardNameLabel)
        addSubview(titleLabel)
        
        // 属性表格
        originY = originY + topSpace + 48
        
        // let attContentView = UIView()
        // attContentView.frame = CGRectMake(-1, originY, CGSSGlobal.width+2, 109)
        let descLabel1 = UILabel()
        descLabel1.frame = CGRectMake(10, originY, 80, 14)
        descLabel1.textColor = UIColor.blackColor()
        descLabel1.font = UIFont.systemFontOfSize(14)
        descLabel1.text = "卡片属性:"
        descLabel1.textColor = UIColor.blackColor()
        // attContentView.addSubview(descLabel1)
        addSubview(descLabel1)
        
        originY = originY + topSpace + 14
        
        attGridView = CGSSGridLabel(frame: CGRectMake(10, originY, CGSSGlobal.width - 20, 70), rows: 5, columns: 6)
        // attGridView.layer.borderColor = UIColor.blackColor().CGColor
        // attGridView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        // attContentView.addSubview(attGridView)
        addSubview(attGridView)
        // attContentView.layer.borderColor = UIColor.blackColor().CGColor
        // attContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        // addSubview(attContentView)
        
        originY = originY + topSpace + 70
        drawSectionLine(originY)
        originY = originY + topSpace
        
        // 属性排名表格
        // let rankContentView = UIView()
        // rankContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 81 + (1 / UIScreen.mainScreen().scale))
        let descLabel2 = UILabel()
        descLabel2.frame = CGRectMake(10, originY, 80, 14)
        descLabel2.textColor = UIColor.blackColor()
        descLabel2.font = UIFont.systemFontOfSize(14)
        descLabel2.text = "属性排名:"
        descLabel2.textColor = UIColor.blackColor()
        // rankContentView.addSubview(descLabel2)
        addSubview(descLabel2)
        originY = originY + topSpace + 14
        
        rankGridView = CGSSGridLabel(frame: CGRectMake(10, originY, CGSSGlobal.width - 20, 42), rows: 3, columns: 5)
        // rankContentView.addSubview(rankGridView)
        addSubview(rankGridView)
        
        // rankContentView.layer.borderColor = UIColor.blackColor().CGColor
        // rankContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        // addSubview(rankContentView)
        
        originY = originY + topSpace + 42
        
        prepareSkillContentView()
        prepareLeaderSkillContentView()
        prepareEvolutionContentView()
        //
    }
    
    convenience init() {
        let frame = CGRectMake(0, 64, CGSSGlobal.width, CGSSGlobal.height - 64)
        self.init(frame: frame)
    }
    
    func initWith(card: CGSSCard) {
        if card.hasSpread! {
            fullImageView?.setCustomImageWithURL(NSURL(string: card.spreadImageRef!)!)
        } else {
            setWithoutSpreadImage()
        }
        
        cardNameLabel.text = card.chara!.name + "  " + (card.chara?.conventional)!
        titleLabel.text = card.title
        rarityLabel.text = card.rarity?.rarityString
        cardIconView?.setWithCardId(card.id!)
        
        // 设置属性列表
        var attGridStrings = [[String]]()
        attGridStrings.append(["  ", "HP", "Vocal", "Dance", "Visual", "Total"])
        attGridStrings.append(["Lv.1", String(card.hpMin), String(card.vocalMin), String(card.danceMin), String(card.visualMin), String(card.overallMin)])
        attGridStrings.append(["Lv.\(card.rarity.baseMaxLevel)", String(card.hpMax), String(card.vocalMax), String(card.danceMax), String(card.visualMax), String(card.overallMax)])
        attGridStrings.append(["Bonus", String(card.bonusHp), String(card.bonusVocal), String(card.bonusDance), String(card.bonusVisual), String(card.overallBonus)])
        attGridStrings.append(["Total", String(card.life), String(card.vocal), String(card.dance), String(card.visual), String(card.overall)])
        
        attGridView.setGridContent(attGridStrings)
        
        let colorArray = [CGSSGlobal.allTypeColor, CGSSGlobal.lifeColor, CGSSGlobal.vocalColor, CGSSGlobal.danceColor, CGSSGlobal.visualColor, CGSSGlobal.allTypeColor]
        let colors = [[UIColor]].init(count: 6, repeatedValue: colorArray)
        attGridView.setGridColor(colors)
        
        var fonts = [[UIFont]]()
        let fontArray = [UIFont].init(count: 6, repeatedValue: CGSSGlobal.alphabetFont)
        var fontArray2 = [UIFont].init(count: 6, repeatedValue: CGSSGlobal.numberFont!)
        fontArray2[0] = CGSSGlobal.alphabetFont
        fonts.append(fontArray)
        fonts.append(fontArray2)
        fonts.append(fontArray2)
        fonts.append(fontArray2)
        fonts.append(fontArray2)
        attGridView.setGridFont(fonts)
        
        // 设置属性排名列表
        let dao = CGSSDAO.sharedDAO
        var rankGridStrings = [[String]]()
        let rankInType = dao.getRankInType(card)
        let rankInAll = dao.getRankInAll(card)
        rankGridStrings.append(["  ", "Vocal", "Dance", "Visual", "Total"])
        rankGridStrings.append(["In \(card.attShort)", "#\(rankInType[0])", "#\(rankInType[1])", "#\(rankInType[2])", "#\(rankInType[3])"])
        rankGridStrings.append(["In All", "#\(rankInAll[0])", "#\(rankInAll[1])", "#\(rankInAll[2])", "#\(rankInAll[3])"])
        rankGridView.setGridContent(rankGridStrings)
        
        var colors2 = [[UIColor]]()
        let colorArray2 = [card.attColor, CGSSGlobal.vocalColor, CGSSGlobal.danceColor, CGSSGlobal.visualColor, CGSSGlobal.allTypeColor]
        let colorArray3 = [CGSSGlobal.allTypeColor, CGSSGlobal.vocalColor, CGSSGlobal.danceColor, CGSSGlobal.visualColor, CGSSGlobal.allTypeColor]
        
        colors2.append(colorArray3)
        colors2.append(colorArray2)
        colors2.append(colorArray3)
        rankGridView.setGridColor(colors2)
        
        var fonts2 = [[UIFont]]()
        let fontArray3 = [UIFont].init(count: 5, repeatedValue: CGSSGlobal.alphabetFont)
        var fontArray4 = [UIFont].init(count: 5, repeatedValue: CGSSGlobal.numberFont!)
        fontArray4[0] = CGSSGlobal.alphabetFont
        fonts2.append(fontArray3)
        fonts2.append(fontArray4)
        fonts2.append(fontArray4)
        rankGridView.setGridFont(fonts2)
        
        // 设置主动技能
        if let skill = card.skill {
            prepareSkillContentView()
            setupSkillContentView(skill)
        } else {
            skillContentView.fheight = 0
        }
        skillContentView.fy = rankGridView.fy + rankGridView.fheight + topSpace
        
        // 设置队长技能
        if let leaderSkill = card.leaderSkill {
            prepareLeaderSkillContentView()
            setupLeaderSkillContentView(leaderSkill)
        } else {
            leaderSkillContentView.fheight = 0
        }
        leaderSkillContentView.fy = skillContentView.fy + skillContentView.fheight
        
        // 设置进化信息
        if let evolution_id = card.evolutionId where evolution_id > 0 {
            prepareEvolutionContentView()
            setupEvolutionContentView(card)
        } else {
            evolutionContentView.fheight = 0
        }
        evolutionContentView.fy = leaderSkillContentView.fy + leaderSkillContentView.fheight
        
        // 设置关联卡信息
        
        let cards = CGSSDAO.sharedDAO.findCardsByCharId(card.charaId)
        if cards.count > 0 {
            prepareRelatedCardsContentView()
            setupRelatedCardsContentView(cards)
        }
        relatedCardsContentView.fy = evolutionContentView.fy + evolutionContentView.fheight
        
        // 设置角色信息
        
        // 设置技能升级信息
        
        // 设置推荐组队信息
        
        // 设置出售价格
        
        // 设置饲料经验信息
        
        self.fheight = relatedCardsContentView.fy + relatedCardsContentView.fheight + topSpace + CardDetailView.bottomInset - self.bounds.origin.y
    }
    
    func iconClick(icon: CGSSCardIconView) {
        delegate?.iconClick(icon)
    }
    
    func setWithoutSpreadImage() {
        self.bounds = CGRectMake(0, (fullImageView?.frame.size.height)!, CGSSGlobal.width, 0)
        // self.bounds.origin.y += 1000 //CGSSGlobal.fullImageWidth/CGSSGlobal.width*CGSSGlobal.fullImageHeight
        // self.contentSize
    }
    
    func setWithSpreadImage() {
        self.bounds = CGRectMake(0, 0, CGSSGlobal.width, 0)
    }
    
    var skillContentView: UIView!
    
    func prepareSkillContentView() {
        if skillContentView != nil {
            return
        }
        skillContentView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 0))
        skillContentView.clipsToBounds = true
        skillContentView.drawSectionLine(0)
        var insideY: CGFloat = 10
        // skillContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 129 + (1 / UIScreen.mainScreen().scale))
        let descLabel3 = UILabel()
        descLabel3.frame = CGRectMake(10, insideY, 50, 14)
        descLabel3.textColor = UIColor.blackColor()
        descLabel3.font = UIFont.systemFontOfSize(14)
        descLabel3.text = "特技:"
        descLabel3.textColor = UIColor.blackColor()
        // skillContentView.addSubview(descLabel3)
        skillContentView.addSubview(descLabel3)
        // let descLabel4 = UILabel()
        // descLabel4.frame = CGRectMake(10, 19, 40, 10)
        // descLabel4.textColor = UIColor.blackColor()
        // descLabel4.font = UIFont.systemFontOfSize(10)
        // descLabel4.text = "类型:"
        // skillContentView.addSubview(descLabel4)
        
        skillNameLabel = UILabel()
        skillNameLabel.frame = CGRectMake(90, insideY, CGSSGlobal.width - 95, 14)
        skillNameLabel.font = UIFont.systemFontOfSize(14)
        // skillContentView.addSubview(skillNameLabel)
        skillContentView.addSubview(skillNameLabel)
        // skillTypeLabel = UILabel()
        // skillTypeLabel.frame = CGRectMake(50, 19, 140, 14)
        // skillTypeLabel.font = UIFont.systemFontOfSize(14)
        // skillTypeLabel.textAlignment = .Left
        // skillContentView.addSubview(skillTypeLabel)
        
        insideY += topSpace + 14
        skillDescriptionLabel = UILabel()
        skillDescriptionLabel.numberOfLines = 0
        skillDescriptionLabel.lineBreakMode = .ByCharWrapping
        skillDescriptionLabel.font = UIFont.systemFontOfSize(12)
        skillDescriptionLabel.textColor = UIColor.darkGrayColor()
        skillDescriptionLabel.frame = CGRectMake(10, insideY, CGSSGlobal.width - 20, 45)
        // skillContentView.addSubview(skillDescriptionLabel)
        skillContentView.addSubview(skillDescriptionLabel)
        
        insideY += topSpace + skillDescriptionLabel.frame.height
        skillProcGridView = CGSSGridLabel.init(frame: CGRectMake(10, originY, CGSSGlobal.width - 20, 42), rows: 3, columns: 5)
        // skillContentView.addSubview(skillProcGridView)
        // skillContentView.layer.borderColor = UIColor.blackColor().CGColor
        // skillContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        // addSubview(skillContentView)
        skillContentView.addSubview(skillProcGridView)
        addSubview(skillContentView)
    }
    
    func setupSkillContentView(skill: CGSSSkill) {
        skillNameLabel.text = skill.skillName
        skillDescriptionLabel.text = skill.explainEn
        skillDescriptionLabel.fwidth = CGSSGlobal.width - 20
        skillDescriptionLabel.sizeToFit()
        skillProcGridView.fy = skillDescriptionLabel.fheight + skillDescriptionLabel.fy + topSpace
        
        var procGridStrings = [[String]]()
        let procChanceMax = Double((skill.procChance[1])) / 100
        let procChanceMin = Double((skill.procChance[0])) / 100
        let durationMax = Double((skill.effectLength[1])) / 100
        let durationMin = Double((skill.effectLength[0])) / 100
        procGridStrings.append(["  ", "触发几率%", "持续时间s", "最大覆盖率%", "平均覆盖率%"])
        procGridStrings.append(["Lv.1", String(format: "%.2f", procChanceMin), String(format: "%.2f", durationMin)
            , String(format: "%.2f", durationMin / Double(skill.condition!) * 100), String(format: "%.2f", durationMin / Double(skill.condition!) * procChanceMin)])
        procGridStrings.append(["Lv.10", String(format: "%.2f", procChanceMax), String(format: "%.2f", durationMax)
            , String(format: "%.2f", durationMax / Double(skill.condition!) * 100), String(format: "%.2f", durationMax / Double(skill.condition!) * procChanceMax)])
        skillProcGridView.setGridContent(procGridStrings)
        skillProcGridView[1, 0].font = UIFont.systemFontOfSize(14)
        skillProcGridView[2, 0].font = UIFont.systemFontOfSize(14)
        
        skillContentView.fheight = skillProcGridView.fheight + skillProcGridView.fy + topSpace
    }
    
    var leaderSkillContentView: UIView!
    
    func prepareLeaderSkillContentView() {
        if leaderSkillContentView != nil {
            return
        }
        leaderSkillContentView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 0))
        leaderSkillContentView.clipsToBounds = true
        // leaderSkillContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 69 + (1 / UIScreen.mainScreen().scale))
        leaderSkillContentView.drawSectionLine(0)
        var insideY: CGFloat = 10
        let descLabel4 = UILabel()
        descLabel4.frame = CGRectMake(10, insideY, 80, 14)
        descLabel4.textColor = UIColor.blackColor()
        descLabel4.font = UIFont.systemFontOfSize(14)
        descLabel4.text = "队长技能:"
        descLabel4.textColor = UIColor.blackColor()
        // leaderSkillContentView.addSubview(descLabel4)
        leaderSkillContentView.addSubview(descLabel4)
        
        // let descLabel4 = UILabel()
        // descLabel4.frame = CGRectMake(10, 19, 40, 10)
        // descLabel4.textColor = UIColor.blackColor()
        // descLabel4.font = UIFont.systemFontOfSize(10)
        // descLabel4.text = "类型:"
        // skillContentView.addSubview(descLabel4)
        
        leaderSkillNameLabel = UILabel()
        leaderSkillNameLabel.frame = CGRectMake(90, insideY, CGSSGlobal.width - 100, 14)
        leaderSkillNameLabel.font = UIFont.systemFontOfSize(14)
        
        // leaderSkillContentView.addSubview(leaderSkillNameLabel)
        leaderSkillContentView.addSubview(leaderSkillNameLabel)
        // skillTypeLabel = UILabel()
        // skillTypeLabel.frame = CGRectMake(50, 19, 140, 14)
        // skillTypeLabel.font = UIFont.systemFontOfSize(14)
        // skillTypeLabel.textAlignment = .Left
        // skillContentView.addSubview(skillTypeLabel)
        
        insideY += topSpace + 14
        leaderSkillDescriptionLabel = UILabel()
        leaderSkillDescriptionLabel.numberOfLines = 0
        leaderSkillDescriptionLabel.lineBreakMode = .ByCharWrapping
        leaderSkillDescriptionLabel.font = UIFont.systemFontOfSize(12)
        leaderSkillDescriptionLabel.textColor = UIColor.darkGrayColor()
        leaderSkillDescriptionLabel.frame = CGRectMake(10, insideY, CGSSGlobal.width - 20, 30)
        
        leaderSkillContentView.addSubview(leaderSkillDescriptionLabel)
        addSubview(leaderSkillContentView)
    }
    
    func setupLeaderSkillContentView(leaderSkill: CGSSLeaderSkill) {
        
        leaderSkillNameLabel.text = leaderSkill.name
        
        leaderSkillDescriptionLabel.text = leaderSkill.explainEn
        leaderSkillDescriptionLabel.fwidth = CGSSGlobal.width - 20
        leaderSkillDescriptionLabel.sizeToFit()
        
        leaderSkillContentView.fheight = leaderSkillDescriptionLabel.fheight + leaderSkillDescriptionLabel.fy + topSpace
        
    }
    
    var evolutionContentView: UIView!
    func prepareEvolutionContentView() {
        if evolutionContentView != nil {
            return
        }
        evolutionContentView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 0))
        evolutionContentView.clipsToBounds = true
        evolutionContentView.drawSectionLine(0)
        // evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 92 + (1 / UIScreen.mainScreen().scale))
        var insideY: CGFloat = topSpace
        let descLabel4 = UILabel()
        descLabel4.frame = CGRectMake(10, insideY, 80, 14)
        descLabel4.textColor = UIColor.blackColor()
        descLabel4.font = UIFont.systemFontOfSize(14)
        descLabel4.text = "进化信息:"
        descLabel4.textColor = UIColor.blackColor()
        // evolutionContentView.addSubview(descLabel4)
        evolutionContentView.addSubview(descLabel4)
        // let descLabel4 = UILabel()
        // descLabel4.frame = CGRectMake(10, 19, 40, 10)
        // descLabel4.textColor = UIColor.blackColor()
        // descLabel4.font = UIFont.systemFontOfSize(10)
        // descLabel4.text = "类型:"
        // skillContentView.addSubview(descLabel4)
        
        insideY += topSpace + 14
        
        evolutionToImageView = CGSSCardIconView(frame: CGRectMake(113, insideY, 48, 48))
        evolutionFromImageView = CGSSCardIconView(frame: CGRectMake(10, insideY, 48, 48))
        // evolutionContentView.addSubview(evolutionToImageView)
        // evolutionContentView.addSubview(evolutionFromImageView)
        evolutionContentView.addSubview(evolutionToImageView)
        evolutionContentView.addSubview(evolutionFromImageView)
        let descLabel5 = UILabel()
        descLabel5.frame = CGRectMake(58, insideY, 50, 48)
        descLabel5.textColor = UIColor.darkGrayColor()
        descLabel5.font = UIFont.systemFontOfSize(24)
        descLabel5.text = " >> "
        descLabel5.textAlignment = .Center
        // evolutionContentView.addSubview(descLabel5)
        evolutionContentView.addSubview(descLabel5)
        // evolutionContentView.layer.borderColor = UIColor.blackColor().CGColor
        // evolutionContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        
        insideY += topSpace + 48
        
        addSubview(evolutionContentView)
    }
    
    // 设置进化信息视图
    func setupEvolutionContentView(card: CGSSCard) {
        evolutionFromImageView.setWithCardId(card.id)
        evolutionToImageView.setWithCardId(card.evolutionId, target: self, action: #selector(iconClick))
        evolutionContentView.fheight = evolutionFromImageView.fy + evolutionFromImageView.fheight + topSpace
    }
    
    // 相关卡片
    var relatedCardsContentView: UIView!
    func prepareRelatedCardsContentView() {
        if relatedCardsContentView != nil {
            return
        }
        relatedCardsContentView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 0))
        relatedCardsContentView.clipsToBounds = true
        relatedCardsContentView.drawSectionLine(0)
        // evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 92 + (1 / UIScreen.mainScreen().scale))
        let insideY: CGFloat = topSpace
        let descLabel = UILabel()
        descLabel.frame = CGRectMake(10, insideY, 140, 14)
        descLabel.textColor = UIColor.blackColor()
        descLabel.font = UIFont.systemFontOfSize(14)
        descLabel.text = "同角色其他卡片:"
        descLabel.textColor = UIColor.blackColor()
        relatedCardsContentView.addSubview(descLabel)
        addSubview(relatedCardsContentView)
        
    }
    
    // 设置相关卡片
    func setupRelatedCardsContentView(cards: [CGSSCard]) {
        let column = floor((CGSSGlobal.width - 2 * topSpace) / 50)
        let space = (CGSSGlobal.width - 2 * topSpace - column * 48)
            / (column - 1)
        
        for i in 0..<cards.count {
            let y = CGFloat(i / Int(column)) * (48 + space) + 34
            let x = CGFloat(i % Int(column)) * (48 + space) + topSpace
            let icon = CGSSCardIconView.init(frame: CGRectMake(x, y, 48, 48))
            icon.setWithCardId(cards[i].id, target: self, action: #selector(iconClick))
            relatedCardsContentView.addSubview(icon)
        }
        relatedCardsContentView.fheight = CGFloat((cards.count - 1) / Int(column)) * (48 + space) + 48 + 34 + topSpace
        
    }
    // 设置角色信息视图
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
    
    // 设置出售价格视图
    func setPriceContentView() {
        let priceContentView = UIView()
        priceContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width + 2, 51 + (1 / UIScreen.mainScreen().scale))
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
        
        self.fheight = originY + CardDetailView.bottomInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

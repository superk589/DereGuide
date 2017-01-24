//
//  CardDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol CardDetailViewDelegate: class {
    func iconClick(_ icon: CGSSCardIconView)
    func charInfoClick()
    
//    func show3DModel(cardDetailView: CardDetailView)
//    func showCardImage(cardDetailView: CardDetailView)
//    func showSignImage(cardDetailView: CardDetailView)
}

class CardDetailView: UIView {
    weak var delegate: CardDetailViewDelegate?
    // 滚动视图内容距底部边距
    static let bottomInset: CGFloat = 60
    
    var fullImageView: CGSSImageView?
    
    var imageToolbar: UIToolbar!
    
    var cardIconView: CGSSCardIconView!
    var cardNameLabel: UILabel!
    var rarityLabel: UILabel!
    var titleLabel: UILabel!
    var attGridView: CGSSGridLabel!
    var rankGridView: CGSSGridLabel!
    
    var originY: CGFloat = 0
    
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
        self.backgroundColor = UIColor.white
        // self.bounces = false
        // 全尺寸大图视图
        let fullImageHeigth = CGSSGlobal.width / CGSSGlobal.fullImageWidth * CGSSGlobal.fullImageHeight
        fullImageView = CGSSImageView(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: fullImageHeigth))
        fullImageView?.isUserInteractionEnabled = true
        addSubview(fullImageView!)
        
        originY = fullImageHeigth
//        imageToolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: originY, width: CGSSGlobal.width, height: 44))
//        imageToolbar.isTranslucent = false
//        addSubview(imageToolbar)
//        
//        let item1 = UIBarButtonItem.init(title: NSLocalizedString("3D模型", comment: ""), style: .plain, target: self, action: #selector(show3DModelAction))
//        let spaceItem1 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let item2 = UIBarButtonItem.init(title: NSLocalizedString("角色卡图", comment: ""), style: .plain, target: self, action: #selector(showCardImageAction))
//        let spaceItem2 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let item3 = UIBarButtonItem.init(title: NSLocalizedString("签名图", comment: ""), style: .plain, target: self, action: #selector(showSignImageAction))
//        
//        imageToolbar.items = [item1, spaceItem1, item2, spaceItem2, item3]
//        
        // 人物名称 图标视图
        originY += topSpace
        cardIconView = CGSSCardIconView.init(frame: CGRect(x: 10, y: originY, width: 48, height: 48))
        
        rarityLabel = UILabel()
        rarityLabel.frame = CGRect(x: 68, y: originY + 5, width: 30, height: 10)
        rarityLabel.textAlignment = .left
        rarityLabel.font = UIFont.systemFont(ofSize: 10)
        
//        skillLabel = UILabel()
//        skillLabel.frame = CGRectMake(CGSSGlobal.width - 150, 5, 140, 10)
//        skillLabel.font = UIFont.systemFontOfSize(10)
//        skillLabel.textAlignment = .Right
        
        cardNameLabel = UILabel()
        cardNameLabel.frame = CGRect(x: 68, y: originY + 27, width: CGSSGlobal.width - 78, height: 16)
        cardNameLabel.font = UIFont.systemFont(ofSize: 16)
        
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 98, y: originY + 5, width: CGSSGlobal.width - 150, height: 10)
        titleLabel.font = UIFont.systemFont(ofSize: 10)
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
        descLabel1.frame = CGRect(x: 10, y: originY, width: CGSSGlobal.width - 20, height: 18)
        descLabel1.textColor = UIColor.black
        descLabel1.font = UIFont.systemFont(ofSize: 16)
        descLabel1.text = NSLocalizedString("卡片属性", comment: "卡片详情页") + ":" 
        descLabel1.textColor = UIColor.black
        // attContentView.addSubview(descLabel1)
        addSubview(descLabel1)
        
        originY = originY + topSpace + 16
        
        attGridView = CGSSGridLabel.init(frame: CGRect(x: 10, y: originY, width: CGSSGlobal.width - 20, height: 90), rows: 5, columns: 6)
        // attGridView.layer.borderColor = UIColor.blackColor().CGColor
        // attGridView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        // attContentView.addSubview(attGridView)
        addSubview(attGridView)
        // attContentView.layer.borderColor = UIColor.blackColor().CGColor
        // attContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        // addSubview(attContentView)
        
        originY = originY + topSpace + 90
        drawSectionLine(originY)
        originY = originY + topSpace
        
        // 属性排名表格
        // let rankContentView = UIView()
        // rankContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 81 + (1 / UIScreen.mainScreen().scale))
        let descLabel2 = UILabel()
        descLabel2.frame = CGRect(x: 10, y: originY, width: CGSSGlobal.width - 20, height: 18)
        descLabel2.textColor = UIColor.black
        descLabel2.font = UIFont.systemFont(ofSize: 16)
        descLabel2.text = NSLocalizedString("属性排名", comment: "卡片详情页") + ":"
        descLabel2.textColor = UIColor.black
        // rankContentView.addSubview(descLabel2)
        addSubview(descLabel2)
        originY = originY + topSpace + 16
        
        rankGridView = CGSSGridLabel.init(frame: CGRect(x: 10, y: originY, width: CGSSGlobal.width - 20, height: 54), rows: 3, columns: 5)
        // rankContentView.addSubview(rankGridView)
        addSubview(rankGridView)
        
        // rankContentView.layer.borderColor = UIColor.blackColor().CGColor
        // rankContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        // addSubview(rankContentView)
        
        originY = originY + topSpace + 54
        
        prepareSkillContentView()
        prepareLeaderSkillContentView()
        prepareEvolutionContentView()
        //
    }
    
    convenience init() {
        let frame = CGRect(x: 0, y: 64, width: CGSSGlobal.width, height: CGSSGlobal.height - 64)
        self.init(frame: frame)
    }
    
    func initWith(_ card: CGSSCard) {
        
        if card.hasSpread! {
            fullImageView?.setCustomImageWithURL(URL(string: card.spreadImageRef!)!)
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
        attGridStrings.append(["Lv.\(card.rarity.baseMaxLevel!)", String(card.hpMax), String(card.vocalMax), String(card.danceMax), String(card.visualMax), String(card.overallMax)])
        attGridStrings.append(["Bonus", String(card.bonusHp), String(card.bonusVocal), String(card.bonusDance), String(card.bonusVisual), String(card.overallBonus)])
        attGridStrings.append(["Total", String(card.life), String(card.vocal), String(card.dance), String(card.visual), String(card.overall)])
        
        attGridView.setGridContent(attGridStrings)
        
        let colorArray = [Color.allType, Color.life, Color.vocal, Color.dance, Color.visual, Color.allType]
        let colors = [[UIColor]].init(repeating: colorArray, count: 6)
        attGridView.setGridColor(colors)
        
        var fonts = [[UIFont]]()
        let fontArray = [UIFont].init(repeating: CGSSGlobal.alphabetFont, count: 6)
        var fontArray2 = [UIFont].init(repeating: CGSSGlobal.numberFont!, count: 6)
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
        let colorArray2 = [card.attColor, Color.vocal, Color.dance, Color.visual, Color.allType]
        let colorArray3 = [Color.allType, Color.vocal, Color.dance, Color.visual, Color.allType]
        
        colors2.append(colorArray3)
        colors2.append(colorArray2)
        colors2.append(colorArray3)
        rankGridView.setGridColor(colors2)
        
        var fonts2 = [[UIFont]]()
        let fontArray3 = [UIFont].init(repeating: CGSSGlobal.alphabetFont, count: 5)
        var fontArray4 = [UIFont].init(repeating: CGSSGlobal.numberFont!, count: 5)
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
        if (card.evolutionId) != nil {
            prepareEvolutionContentView()
            setupEvolutionContentView(card)
        } else {
            evolutionContentView.fheight = 0
        }
        evolutionContentView.fy = leaderSkillContentView.fy + leaderSkillContentView.fheight
        
        // 设置角色和关联卡信息
        
        var cards = CGSSDAO.sharedDAO.findCardsByCharId(card.charaId)
        let sorter = CGSSSorter.init(property: "sAlbumId")
        sorter.sortList(&cards)
        if cards.count > 0 {
            prepareRelatedCardsContentView()
            setupRelatedCardsContentView(cards)
        }
        relatedCardsContentView.fy = evolutionContentView.fy + evolutionContentView.fheight
        
        
        // 设置获取来源
        let rarityTypes:CGSSRarityTypes = [.sr, .ssr, .ssrp, .srp]
        if rarityTypes.contains(card.rarityType) {
            prepareAvailableInfoContentView()
            setupAvailableInfoContentView(card: card)
        } else {
            prepareAvailableInfoContentView()
            availableInfoContentView.fheight = 0
        }
        availableInfoContentView.fy = relatedCardsContentView.fy + relatedCardsContentView.fheight
        
        
        // 设置技能升级信息
        
        // 设置推荐组队信息
        
        // 设置出售价格
        
        // 设置饲料经验信息
        
        self.fheight = availableInfoContentView.fy + availableInfoContentView.fheight + topSpace + CardDetailView.bottomInset - self.bounds.origin.y
    }
    
    func iconClick(_ icon: CGSSCardIconView) {
        delegate?.iconClick(icon)
    }
    
    func setWithoutSpreadImage() {
        self.bounds = CGRect(x: 0, y: (fullImageView?.frame.size.height)!, width: CGSSGlobal.width, height: 0)
        // self.bounds.origin.y += 1000 //CGSSGlobal.fullImageWidth/CGSSGlobal.width*CGSSGlobal.fullImageHeight
        // self.contentSize
    }
    
    func setWithSpreadImage() {
        self.bounds = CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0)
    }
    
    var skillContentView: UIView!
    
    func prepareSkillContentView() {
        if skillContentView != nil {
            return
        }
        skillContentView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        skillContentView.clipsToBounds = true
        skillContentView.drawSectionLine(0)
        var insideY: CGFloat = 10
        // skillContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 129 + (1 / UIScreen.mainScreen().scale))
        let descLabel3 = UILabel()
        descLabel3.frame = CGRect(x: 10, y: insideY, width: 50, height: 16)
        descLabel3.textColor = UIColor.black
        descLabel3.font = UIFont.systemFont(ofSize: 16)
        //descLabel3.text = NSLocalizedString("特技", comment: "通用") + ":"
        descLabel3.textColor = UIColor.black
        // skillContentView.addSubview(descLabel3)
        //skillContentView.addSubview(descLabel3)
        // let descLabel4 = UILabel()
        // descLabel4.frame = CGRectMake(10, 19, 40, 10)
        // descLabel4.textColor = UIColor.blackColor()
        // descLabel4.font = UIFont.systemFontOfSize(10)
        // descLabel4.text = "类型:"
        // skillContentView.addSubview(descLabel4)
        
        skillNameLabel = UILabel()
        skillNameLabel.frame = CGRect(x: 10, y: insideY, width: CGSSGlobal.width - 20, height: 18)
        skillNameLabel.font = UIFont.systemFont(ofSize: 16)
        skillNameLabel.adjustsFontSizeToFitWidth = true
        // skillContentView.addSubview(skillNameLabel)
        skillContentView.addSubview(skillNameLabel)
        // skillTypeLabel = UILabel()
        // skillTypeLabel.frame = CGRectMake(50, 19, 140, 14)
        // skillTypeLabel.font = UIFont.systemFontOfSize(14)
        // skillTypeLabel.textAlignment = .Left
        // skillContentView.addSubview(skillTypeLabel)
        
        insideY += topSpace + 16
        skillDescriptionLabel = UILabel()
        skillDescriptionLabel.numberOfLines = 0
        skillDescriptionLabel.lineBreakMode = .byCharWrapping
        skillDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        skillDescriptionLabel.textColor = UIColor.darkGray
        skillDescriptionLabel.frame = CGRect(x: 10, y: insideY, width: CGSSGlobal.width - 20, height: 0)
        // skillContentView.addSubview(skillDescriptionLabel)
        skillContentView.addSubview(skillDescriptionLabel)
        
        insideY += topSpace + skillDescriptionLabel.frame.height
        skillProcGridView = CGSSGridLabel.init(frame: CGRect(x: 10, y: originY, width: CGSSGlobal.width - 20, height: 54), rows: 3, columns: 5)
        // skillContentView.addSubview(skillProcGridView)
        // skillContentView.layer.borderColor = UIColor.blackColor().CGColor
        // skillContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        // addSubview(skillContentView)
        skillContentView.addSubview(skillProcGridView)
        addSubview(skillContentView)
    }
    
    func setupSkillContentView(_ skill: CGSSSkill) {
        skillNameLabel.text = NSLocalizedString("特技", comment: "通用") + ": " + skill.skillName
        skillDescriptionLabel.text = skill.getExplainByLevelRange(1, end: 10, languageType: CGSSGlobal.languageType)
        skillDescriptionLabel.fwidth = CGSSGlobal.width - 20
        skillDescriptionLabel.sizeToFit()
        skillProcGridView.fy = skillDescriptionLabel.fheight + skillDescriptionLabel.fy + topSpace
        
        var procGridStrings = [[String]]()
        let procChanceMax: Float! = skill.procChanceOfLevel(10)
        let procChanceMin: Float! = skill.procChanceOfLevel(1)
        let durationMax: Float! = skill.effectLengthOfLevel(10)
        let durationMin: Float! = skill.effectLengthOfLevel(1)
        procGridStrings.append(["  ", NSLocalizedString("触发几率%", comment: "卡片详情页"), NSLocalizedString("持续时间s", comment: "卡片详情页"), NSLocalizedString("最大覆盖率%", comment: "卡片详情页"), NSLocalizedString("平均覆盖率%", comment: "卡片详情页")])
        procGridStrings.append(["Lv.1", String(format: "%.2f", procChanceMin), String(format: "%.2f", durationMin)
            , String(format: "%.2f", durationMin / Float(skill.condition!) * 100), String(format: "%.2f", durationMin / Float(skill.condition!) * procChanceMin)])
        procGridStrings.append(["Lv.10", String(format: "%.2f", procChanceMax), String(format: "%.2f", durationMax)
            , String(format: "%.2f", durationMax / Float(skill.condition!) * 100), String(format: "%.2f", durationMax / Float(skill.condition!) * procChanceMax)])
        skillProcGridView.setGridContent(procGridStrings)
        
        skillContentView.fheight = skillProcGridView.fheight + skillProcGridView.fy + topSpace
    }
    
    var leaderSkillContentView: UIView!
    
    func prepareLeaderSkillContentView() {
        if leaderSkillContentView != nil {
            return
        }
        leaderSkillContentView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        leaderSkillContentView.clipsToBounds = true
        // leaderSkillContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 69 + (1 / UIScreen.mainScreen().scale))
        leaderSkillContentView.drawSectionLine(0)
        var insideY: CGFloat = 10
        let descLabel4 = UILabel()
        descLabel4.frame = CGRect(x: 10, y: insideY, width: 80, height: 16)
        descLabel4.textColor = UIColor.black
        descLabel4.font = UIFont.systemFont(ofSize: 16)
        //descLabel4.text = NSLocalizedString("队长技能", comment: "通用") + ":"
        descLabel4.textColor = UIColor.black
        // leaderSkillContentView.addSubview(descLabel4)
        //leaderSkillContentView.addSubview(descLabel4)
        
        // let descLabel4 = UILabel()
        // descLabel4.frame = CGRectMake(10, 19, 40, 10)
        // descLabel4.textColor = UIColor.blackColor()
        // descLabel4.font = UIFont.systemFontOfSize(10)
        // descLabel4.text = "类型:"
        // skillContentView.addSubview(descLabel4)
        
        leaderSkillNameLabel = UILabel()
        leaderSkillNameLabel.frame = CGRect(x: 10, y: insideY, width: CGSSGlobal.width - 20, height: 18)
        leaderSkillNameLabel.adjustsFontSizeToFitWidth = true
        leaderSkillNameLabel.font = UIFont.systemFont(ofSize: 16)
        
        // leaderSkillContentView.addSubview(leaderSkillNameLabel)
        leaderSkillContentView.addSubview(leaderSkillNameLabel)
        // skillTypeLabel = UILabel()
        // skillTypeLabel.frame = CGRectMake(50, 19, 140, 14)
        // skillTypeLabel.font = UIFont.systemFontOfSize(14)
        // skillTypeLabel.textAlignment = .Left
        // skillContentView.addSubview(skillTypeLabel)
        
        insideY += topSpace + 16
        leaderSkillDescriptionLabel = UILabel()
        leaderSkillDescriptionLabel.numberOfLines = 0
        leaderSkillDescriptionLabel.lineBreakMode = .byCharWrapping
        leaderSkillDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        leaderSkillDescriptionLabel.textColor = UIColor.darkGray
        leaderSkillDescriptionLabel.frame = CGRect(x: 10, y: insideY, width: CGSSGlobal.width - 20, height: 0)
        
        leaderSkillContentView.addSubview(leaderSkillDescriptionLabel)
        addSubview(leaderSkillContentView)
    }
    
    func setupLeaderSkillContentView(_ leaderSkill: CGSSLeaderSkill) {
        
        leaderSkillNameLabel.text = NSLocalizedString("队长技能", comment: "通用") + ": " + leaderSkill.name
        
        leaderSkillDescriptionLabel.text = leaderSkill.getLocalizedExplain(languageType: CGSSGlobal.languageType)
        leaderSkillDescriptionLabel.fwidth = CGSSGlobal.width - 20
        leaderSkillDescriptionLabel.sizeToFit()
        
        leaderSkillContentView.fheight = leaderSkillDescriptionLabel.fheight + leaderSkillDescriptionLabel.fy + topSpace
        
    }
    
    var evolutionContentView: UIView!
    func prepareEvolutionContentView() {
        if evolutionContentView != nil {
            return
        }
        evolutionContentView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        evolutionContentView.clipsToBounds = true
        evolutionContentView.drawSectionLine(0)
        // evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 92 + (1 / UIScreen.mainScreen().scale))
        var insideY: CGFloat = topSpace
        let descLabel4 = UILabel()
        descLabel4.frame = CGRect(x: 10, y: insideY, width: CGSSGlobal.width - 20, height: 18)
        descLabel4.textColor = UIColor.black
        descLabel4.font = UIFont.systemFont(ofSize: 16)
        descLabel4.text = NSLocalizedString("进化信息", comment: "卡片详情页") + ":"
        descLabel4.textColor = UIColor.black
        // evolutionContentView.addSubview(descLabel4)
        evolutionContentView.addSubview(descLabel4)
        // let descLabel4 = UILabel()
        // descLabel4.frame = CGRectMake(10, 19, 40, 10)
        // descLabel4.textColor = UIColor.blackColor()
        // descLabel4.font = UIFont.systemFontOfSize(10)
        // descLabel4.text = "类型:"
        // skillContentView.addSubview(descLabel4)
        
        insideY += topSpace + 16
        
        evolutionToImageView = CGSSCardIconView(frame: CGRect(x: 113, y: insideY, width: 48, height: 48))
        evolutionFromImageView = CGSSCardIconView(frame: CGRect(x: 10, y: insideY, width: 48, height: 48))
        // evolutionContentView.addSubview(evolutionToImageView)
        // evolutionContentView.addSubview(evolutionFromImageView)
        evolutionContentView.addSubview(evolutionToImageView)
        evolutionContentView.addSubview(evolutionFromImageView)
        let descLabel5 = UILabel()
        descLabel5.frame = CGRect(x: 58, y: insideY, width: 50, height: 48)
        descLabel5.textColor = UIColor.darkGray
        descLabel5.font = UIFont.systemFont(ofSize: 24)
        descLabel5.text = " >> "
        descLabel5.textAlignment = .center
        // evolutionContentView.addSubview(descLabel5)
        evolutionContentView.addSubview(descLabel5)
        // evolutionContentView.layer.borderColor = UIColor.blackColor().CGColor
        // evolutionContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        
        insideY += topSpace + 48
        
        addSubview(evolutionContentView)
    }
    
    // 设置进化信息视图
    func setupEvolutionContentView(_ card: CGSSCard) {
        if card.evolutionId == 0{
            evolutionToImageView.setWithCardId(card.id)
            evolutionFromImageView.setWithCardId(card.id - 1, target: self, action: #selector(iconClick))
        } else {
            evolutionFromImageView.setWithCardId(card.id)
            evolutionToImageView.setWithCardId(card.evolutionId, target: self, action: #selector(iconClick))
        }
        evolutionContentView.fheight = evolutionFromImageView.fy + evolutionFromImageView.fheight + topSpace
    }
    
    // 相关卡片
    var relatedCardsContentView: UIView!
    func prepareRelatedCardsContentView() {
        if relatedCardsContentView != nil {
            return
        }
        relatedCardsContentView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        relatedCardsContentView.clipsToBounds = true
        relatedCardsContentView.drawSectionLine(0)
        // evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 92 + (1 / UIScreen.mainScreen().scale))
        let insideY: CGFloat = topSpace
        let descLabel = UILabel()
        descLabel.frame = CGRect(x: 10, y: insideY, width: 170, height: 18)
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.text = NSLocalizedString("角色所有卡片", comment: "卡片详情页") + ":"
        descLabel.textColor = UIColor.black
        
        let charInfoLabel = UILabel.init(frame: CGRect(x: 100, y: insideY, width: CGSSGlobal.width - 110, height: 18))
        charInfoLabel.text = NSLocalizedString("查看角色详情", comment: "卡片详情页") + " >"
        charInfoLabel.font = UIFont.systemFont(ofSize: 16)
        charInfoLabel.textColor = UIColor.lightGray
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(charInfoClick))
        charInfoLabel.addGestureRecognizer(tap)
        charInfoLabel.textAlignment = .right
        charInfoLabel.isUserInteractionEnabled = true
        
        relatedCardsContentView.addSubview(descLabel)
        relatedCardsContentView.addSubview(charInfoLabel)
        addSubview(relatedCardsContentView)
        
    }
    
    // 设置相关卡片
    func setupRelatedCardsContentView(_ cards: [CGSSCard]) {
        let column = floor((CGSSGlobal.width - 2 * topSpace) / 50)
        let spaceTotal = CGSSGlobal.width - 2 * topSpace - column * 48
        let space = spaceTotal / (column - 1)
        
        for i in 0..<cards.count {
            let y = CGFloat(i / Int(column)) * (48 + space) + 34
            let x = CGFloat(i % Int(column)) * (48 + space) + topSpace
            let icon = CGSSCardIconView.init(frame: CGRect(x: x, y: y, width: 48, height: 48))
            icon.setWithCardId(cards[i].id, target: self, action: #selector(iconClick))
            relatedCardsContentView.addSubview(icon)
        }
        relatedCardsContentView.fheight = CGFloat((cards.count - 1) / Int(column)) * (48 + space) + 48 + 34 + topSpace
        
    }
    
    
    // 获得途径
    var availableInfoContentView: UIView!
    var availableEvent: CGSSCheckBox!
    var availableGacha: CGSSCheckBox!
    var availableLimit: CGSSCheckBox!
    var availableFes: CGSSCheckBox!
    var availableDescLabel:UILabel!
    func prepareAvailableInfoContentView() {
        if availableInfoContentView != nil {
            return
        }
        availableInfoContentView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        availableInfoContentView.clipsToBounds = true
        availableInfoContentView.drawSectionLine(0)
        // evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 92 + (1 / UIScreen.mainScreen().scale))
        var insideY: CGFloat = topSpace
        availableDescLabel = UILabel()
        availableDescLabel.frame = CGRect(x: 10, y: insideY, width: 140, height: 18)
        availableDescLabel.font = UIFont.systemFont(ofSize: 16)
        availableDescLabel.text = NSLocalizedString("获得途径", comment: "卡片详情页") + ":"
        availableDescLabel.textColor = UIColor.black
        
        insideY += topSpace + 16
        
        availableEvent = CGSSCheckBox.init(frame: CGRect(x: 10, y: insideY, width: 70, height: 14))
        availableGacha = CGSSCheckBox.init(frame: CGRect(x: 85, y: insideY, width: 70, height: 14))
        availableLimit = CGSSCheckBox.init(frame: CGRect(x: 160, y: insideY, width: 70, height: 14))
        availableFes = CGSSCheckBox.init(frame: CGRect(x: 235, y: insideY, width: 70, height: 14))
        
        availableEvent.tintColor = Color.cool
        availableGacha.tintColor = Color.cool
        availableLimit.tintColor = Color.cool
        availableFes.tintColor = Color.cool
        
        availableEvent.descLabel.textColor = UIColor.darkGray
        availableGacha.descLabel.textColor = UIColor.darkGray
        availableLimit.descLabel.textColor = UIColor.darkGray
        availableFes.descLabel.textColor = UIColor.darkGray
        
        availableEvent.text = NSLocalizedString("活动", comment: "卡片详情页")
        availableGacha.text = NSLocalizedString("普池", comment: "卡片详情页")
        availableLimit.text = NSLocalizedString("限定", comment: "卡片详情页")
        availableFes.text = NSLocalizedString("FES限定", comment: "卡片详情页")
        
        availableEvent.isChecked = false
        availableLimit.isChecked = false
        availableGacha.isChecked = false
        availableFes.isChecked = false
        
        availableInfoContentView.addSubview(availableDescLabel)
        availableInfoContentView.addSubview(availableEvent)
        availableInfoContentView.addSubview(availableGacha)
        availableInfoContentView.addSubview(availableLimit)
        availableInfoContentView.addSubview(availableFes)
        insideY += topSpace + 14
        availableInfoContentView.fheight = insideY
        addSubview(availableInfoContentView)
        
    }
    func setupAvailableInfoContentView(card:CGSSCard) {
        var types: CGSSAvailableTypes = .free
        if card.evolutionId == 0 {
            availableDescLabel.text = NSLocalizedString("获得途径(进化前)", comment: "卡片详情页") + ":"
            if let cardFrom = CGSSDAO.sharedDAO.findCardById(card.id - 1) {
                types = cardFrom.gachaType
            }
        } else {
            types = card.gachaType
        }
        switch types {
        case CGSSAvailableTypes.fes:
            availableFes.isChecked = true
        case CGSSAvailableTypes.limit:
            availableLimit.isChecked = true
        case CGSSAvailableTypes.event:
            availableEvent.isChecked = true
        case CGSSAvailableTypes.normal:
            availableGacha.isChecked = true
        default:
            break
        }
//        var tuple = (false, false, false, false)
//        if card.evolutionId == 0 {
//            availableDescLabel.text = NSLocalizedString("获得途径(进化前)", comment: "卡片详情页") + ":"
//            if let cardFrom = CGSSDAO.sharedDAO.findCardById(card.id - 1) {
//                tuple = cardFrom.available
//            }
//        } else {
//            tuple = card.available
//        }
//        availableEvent.isChecked =
//        availableFes.isChecked = tuple.3
//        availableLimit.isChecked = tuple.2
//        if tuple.2 || tuple.3 {
//            availableGacha.isChecked = false
//        } else {
//            availableGacha.isChecked = tuple.1
//        }
    }

    
    
    func charInfoClick() {
        delegate?.charInfoClick()
    }
    
    // 设置出售价格视图
    func setPriceContentView() {
        let priceContentView = UIView()
        priceContentView.frame = CGRect(x: -1, y: originY - (1 / UIScreen.main.scale), width: CGSSGlobal.width + 2, height: 51 + (1 / UIScreen.main.scale))
        let descLabel4 = UILabel()
        descLabel4.frame = CGRect(x: 10, y: 10, width: 80, height: 16)
        descLabel4.textColor = UIColor.black
        descLabel4.font = UIFont.systemFont(ofSize: 16)
        descLabel4.text = "出售价格:"
        priceContentView.addSubview(descLabel4)
        
        priceLabel = UILabel()
        priceLabel.frame = CGRect(x: 10, y: 31, width: 100, height: 14)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textAlignment = .left
        priceContentView.addSubview(priceLabel)
        
        priceContentView.layer.borderColor = UIColor.black.cgColor
        priceContentView.layer.borderWidth = 1 / UIScreen.main.scale
        
        originY = originY + 51
        
        self.fheight = originY + CardDetailView.bottomInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

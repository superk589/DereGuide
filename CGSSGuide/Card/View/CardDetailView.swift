//
//  CardDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/24.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol CardDetailViewDelegate: class {
    func seeCharInfo(cardDetailView: CardDetailView)
    func cardDetailView(_ cardDetailView: CardDetailView, didTapOn spreadImageView: SpreadImageView)
}

class CardDetailView: UIView {
    weak var delegate: (CGSSIconViewDelegate & CardDetailViewDelegate)?
    // 滚动视图内容距底部边距
    static let bottomInset: CGFloat = 60
    
    var spreadImageView: SpreadImageView!
    
    var imageToolbar: UIToolbar!
    
    var cardIconView: CGSSCardIconView!
    var cardNameLabel: UILabel!
    var rarityLabel: UILabel!
    var titleLabel: UILabel!
    
    var appealView: CardAppealView!
    
    var rankingView: CardRankingView!
    
    var originY: CGFloat = 0
    
    var skillNameLabel: UILabel!
    var skillDescriptionLabel: UILabel!
    var skillProcGridView: GridLabel!
    
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
        
        spreadImageView = SpreadImageView()
        addSubview(spreadImageView)
        spreadImageView.snp.makeConstraints({ (make) in
            make.top.left.width.equalToSuperview()
            make.height.equalTo(spreadImageView.snp.width).multipliedBy(824.0 / 1280.0)
        })
        
        spreadImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(spreadImageTapAction(tap:)))
        spreadImageView.addGestureRecognizer(tap)
        
        // 人物名称 图标视图
        originY += topSpace
        
        // 属性表格
        originY = originY + topSpace + 48
        
        
        originY = appealView.fbottom
        drawSectionLine(originY)
        originY = originY + topSpace
        
        rankingView = CardRankingView()
        addSubview(rankingView)
        rankingView.snp.makeConstraints { (make) in
            make.top.equalTo(appealView.snp.bottom)
            make.right.left.equalToSuperview()
        }
        
//        layoutIfNeeded()
        
        prepareSkillContentView()
        prepareLeaderSkillContentView()
    }
    
    
    func spreadImageTapAction(tap: UITapGestureRecognizer) {
        delegate?.cardDetailView(self, didTapOn: spreadImageView)
    }
    
    convenience init() {
        let frame = CGRect(x: 0, y: 64, width: CGSSGlobal.width, height: CGSSGlobal.height - 64)
        self.init(frame: frame)
    }
    
    func setup(with card: CGSSCard) {
        
        if card.hasSpread! {
            spreadImageView.setImage(with: (URL(string: card.spreadImageRef!))!)
        } else {
            setWithoutSpreadImage()
        }
        
        
        appealView.setup(with: card)
        
        rankingView.setup(with: card)
        layoutIfNeeded()
        
        // 设置主动技能
        if let skill = card.skill {
            setupSkillContentView(skill)
        } else {
            skillContentView.fheight = 0
        }
        skillContentView.fy = rankingView.fbottom
        
        // 设置队长技能
        if let leaderSkill = card.leaderSkill {
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
        
        var cards = CGSSDAO.shared.findCardsByCharId(card.charaId)
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
    
    func setWithoutSpreadImage() {
        self.bounds = CGRect(x: 0, y: spreadImageView.frame.size.height, width: CGSSGlobal.width, height: 0)
        self.spreadImageView.backgroundColor = UIColor.white
    }
    
    func setWithSpreadImage() {
        self.bounds = CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0)
    }
    
    var skillContentView: UIView!
    
    func prepareSkillContentView() {
        if skillContentView != nil {
            return
        }
        skillContentView = UIView()
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
        skillNameLabel.baselineAdjustment = .alignCenters
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
        skillProcGridView = GridLabel.init(rows: 4, columns: 5)
        skillProcGridView.frame = CGRect(x: 10, y: originY, width: CGSSGlobal.width - 20, height: 72)
        // skillContentView.addSubview(skillProcGridView)
        // skillContentView.layer.borderColor = UIColor.blackColor().CGColor
        // skillContentView.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        // addSubview(skillContentView)
        skillContentView.addSubview(skillProcGridView)
        addSubview(skillContentView)
    }
    
    func setupSkillContentView(_ skill: CGSSSkill) {
        }
    
    var leaderSkillContentView: UIView!
    
    func prepareLeaderSkillContentView() {
        if leaderSkillContentView != nil {
            return
        }
    
    }
    
    func setupLeaderSkillContentView(_ leaderSkill: CGSSLeaderSkill) {
        
       
        
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
            evolutionToImageView.cardId = card.id
            evolutionFromImageView.cardId = card.id - 1
            evolutionFromImageView.delegate = self.delegate
        } else {
            evolutionFromImageView.cardId = card.id
            evolutionToImageView.cardId = card.evolutionId
            evolutionToImageView.delegate = self.delegate
        }
        evolutionContentView.fheight = evolutionFromImageView.fy + evolutionFromImageView.fheight + topSpace
    }
    
    // 相关卡片
    var relatedCardsContentView: UIView!
    func prepareRelatedCardsContentView() {
        if relatedCardsContentView != nil {
            return
        }
        
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
            icon.cardId = cards[i].id
            icon.delegate = self.delegate
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
        
//        var tuple = (false, false, false, false)
//        if card.evolutionId == 0 {
//            availableDescLabel.text = NSLocalizedString("获得途径(进化前)", comment: "卡片详情页") + ":"
//            if let cardFrom = shared.findCardById(card.id - 1) {
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
        delegate?.seeCharInfo(cardDetailView: self)
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

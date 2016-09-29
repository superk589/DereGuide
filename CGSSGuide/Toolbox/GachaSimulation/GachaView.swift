//
//  GachaView.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol GachaViewDelegate: class {
    func iconClick(iv:CGSSCardIconView)
    func didSelect(gachaView: GachaView)
    func seeMoreCard(gachaView: GachaView)
}

class GachaView: UIView {
    var checkButton: UIButton!
    var gachaInfoView: UIView!
    var nameLabel:UILabel!
    var detailLabel:UILabel!
    var ratioLabel:UILabel!
    var timeLabel:UILabel!
    var timeStatusIndicator:UIImageView!
    
    weak var delegate: GachaViewDelegate?
    var cardListView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    private let space:CGFloat = 10
    func prepare() {
        drawSectionLine(0)
        var originY:CGFloat = 10
        checkButton = UIButton.init(frame: CGRect(x: space, y: originY, width: 22, height: 22))
        checkButton.tintColor = CGSSGlobal.coolColor
        checkButton.setImage(UIImage.init(named: "888-checkmark-toolbar")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        let  descLabel = UILabel.init(frame: CGRect.init(x: space + 27, y: originY + 2.5, width: 40, height: 17))
        descLabel.text = NSLocalizedString("卡池", comment: "模拟抽卡页面")  + ": "
        descLabel.textAlignment = .left
        descLabel.font = UIFont.systemFont(ofSize: 16)
        
        nameLabel = UILabel.init(frame: CGRect.init(x: space + 72, y: originY + 2.5, width: CGSSGlobal.width - 40 - space, height: 17))
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        originY += space + 20
        
        ratioLabel = UILabel.init(frame: CGRect.init(x: space, y: originY, width: fwidth - 2 * space, height: 12))
        ratioLabel.font = UIFont.systemFont(ofSize: 12)
        ratioLabel.textAlignment = .left
        ratioLabel.textColor = CGSSGlobal.vocalColor
        
        originY += space + 9.5
        
        
        detailLabel = UILabel.init(frame: CGRect.init(x: space, y: originY, width: CGSSGlobal.width - 2 * space, height: 0))
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.numberOfLines = 0
        detailLabel.textColor = UIColor.darkGray
        
        originY += space
        
        timeStatusIndicator = UIImageView.init(frame: CGRect(x: space, y: originY, width: 12, height: 12))
        timeStatusIndicator.zy_cornerRadiusAdvance(6, rectCornerType: .allCorners)
        
        timeLabel = UILabel.init(frame: CGRect.init(x: space + 22, y: originY, width: CGSSGlobal.width - space * 2 - 22, height: 12))
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = UIColor.darkGray
        
        originY += space
        
        gachaInfoView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: CGSSGlobal.width, height: originY))
        gachaInfoView.addSubview(checkButton)
        gachaInfoView.addSubview(descLabel)
        gachaInfoView.addSubview(nameLabel)
        gachaInfoView.addSubview(ratioLabel)
        gachaInfoView.addSubview(detailLabel)
        gachaInfoView.addSubview(timeLabel)
        gachaInfoView.addSubview(timeStatusIndicator)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectAction))
        self.addGestureRecognizer(tap)
    }
    
    func selectAction() {
        delegate?.didSelect(gachaView: self)
    }
    
    func setupWith(pool: GachaPool) {
        nameLabel.text = pool.name
        ratioLabel.text = "SSR: \(Float(pool.ssrRatio) / 100)%   SR: \(Float(pool.srRatio) / 100)%   R: \(Float(pool.rareRatio) / 100)%"
        detailLabel.text = pool.dicription
        timeLabel.text = "\(pool.startDate) ~ \(pool.endDate)"
        detailLabel.fwidth = CGSSGlobal.width - 2 * space
        detailLabel.sizeToFit()
        timeLabel.fy = detailLabel.fy + detailLabel.fheight + space / 2
        timeStatusIndicator.fy = detailLabel.fy + detailLabel.fheight + space / 2
        gachaInfoView.fheight = timeLabel.fy + timeLabel.fheight + space
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.timeZone = CGSSGlobal.timeZoneOfTyoko
        let start = df.date(from: pool.startDate)!
        let end = df.date(from: pool.endDate)!
        let now = Date()
        if now >= start && now <= end {
            timeStatusIndicator.tintColor = UIColor.green.withAlphaComponent(0.6)
        } else if now < start {
            timeStatusIndicator.tintColor = UIColor.orange.withAlphaComponent(0.6)
        } else if now > end {
            timeStatusIndicator.tintColor = UIColor.red.withAlphaComponent(0.6)
        }
        timeStatusIndicator.image = UIImage.init(named: "icon_placeholder")?.withRenderingMode(.alwaysTemplate)
        self.addSubview(gachaInfoView)
        let dao = CGSSDAO.sharedDAO
        var cards = [CGSSCard]()
        for reward in pool.new {
            if let card = dao.findCardById(reward.cardId) {
                cards.append(card)
            }
        }
        let sorter = CGSSSorter.init(att: "sRarity")
        sorter.sortList(&cards)
        prepareCardListView()
        setupCardListView(cards)
        self.addSubview(cardListView)
        cardListView.fy = gachaInfoView.fy + gachaInfoView.fheight
        self.fheight = cardListView.fy + cardListView.fheight
    }
    
    func setupWithNoPool() {
        self.addSubview(gachaInfoView)
        nameLabel.text = ""
        detailLabel.fwidth = CGSSGlobal.width - 2 * space
        detailLabel.text = NSLocalizedString("未找到有效的卡池数据，请尝试下拉刷新", comment: "模拟抽卡页面")
        detailLabel.sizeToFit()
        gachaInfoView.fheight = detailLabel.fy + detailLabel.fheight
        self.fheight = gachaInfoView.fheight + gachaInfoView.fy + space
    }
    
    func setSelect() {
        checkButton.setImage(UIImage.init(named: "888-checkmark-toolbar-selected")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func setDeselect() {
        checkButton.setImage(UIImage.init(named: "888-checkmark-toolbar")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func prepareCardListView() {
        if cardListView != nil {
            return
        }
        cardListView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        cardListView.clipsToBounds = true
        cardListView.drawSectionLine(0)
        // evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 92 + (1 / UIScreen.mainScreen().scale))
        let insideY: CGFloat = space
        let descLabel = UILabel()
        descLabel.frame = CGRect(x: 10, y: insideY, width: 140, height: 17)
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.text = NSLocalizedString("新卡列表", comment: "模拟抽卡页面") + ":"
        descLabel.textColor = UIColor.black
        
        let moreCardLabel = UILabel.init(frame: CGRect(x: 100, y: insideY, width: CGSSGlobal.width - 110, height: 17))
        moreCardLabel.text = NSLocalizedString("查看完整卡池", comment: "模拟抽卡页面") + " >"
        moreCardLabel.font = UIFont.systemFont(ofSize: 16)
        moreCardLabel.textColor = UIColor.lightGray
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(seeMoreCard))
        moreCardLabel.addGestureRecognizer(tap)
        moreCardLabel.textAlignment = .right
        moreCardLabel.isUserInteractionEnabled = true
        
        cardListView.addSubview(descLabel)
        cardListView.addSubview(moreCardLabel)
        addSubview(cardListView)
        
    }

    func setupCardListView(_ cards: [CGSSCard]) {
        let column = floor((CGSSGlobal.width - 2 * space) / 50)
        let spaceTotal = CGSSGlobal.width - 2 * space - column * 48
        let interSpace = spaceTotal / (column - 1)
        for i in 0..<cards.count {
            let y = CGFloat(i / Int(column)) * (48 + interSpace) + 37
            let x = CGFloat(i % Int(column)) * (48 + interSpace) + space
            let icon = CGSSCardIconView.init(frame: CGRect(x: x, y: y, width: 48, height: 48))
            icon.setWithCardId(cards[i].id, target: self, action: #selector(iconClick))
            cardListView.addSubview(icon)
        }
        if cards.count > 0 {
            cardListView.fheight = ceil(CGFloat(cards.count) / column) * (48 + interSpace) - interSpace + 37 + space
        } else {
            cardListView.fheight = 37
        }
        
    }

    func iconClick(iv:CGSSCardIconView) {
        delegate?.iconClick(iv: iv)
    }
    
    func seeMoreCard() {
        delegate?.seeMoreCard(gachaView: self)
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

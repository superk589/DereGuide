//
//  GachaDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import ZKCornerRadiusView

protocol GachaDetailViewDelegate: class {
    func gachaDetailView(_ view: GachaDetailView, didClick cardIcon:CGSSCardIconView)
    func seeModeCard(gachaDetailView view: GachaDetailView)
}

class GachaDetailView: UIView {
    
    var gachaInfoView: UIView!
    var nameLabel:UILabel!
    var detailLabel:UILabel!
    var ratioLabel:UILabel!
    var timeLabel:UILabel!
    var timeStatusIndicator: TimeStatusIndicator!
    var cardListView: GachaCardWithOddsListView!
    var guaranteesView: CardDetailRelatedCardsCell!
    var simulationView: GachaSimulateView!
    
    weak var delegate: GachaDetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let descLabel = UILabel()
        descLabel.text = NSLocalizedString("卡池", comment: "模拟抽卡页面")
        descLabel.textAlignment = .left
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.sizeToFit()
        addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(8)
        }
        
        nameLabel = UILabel()
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel.snp.right).offset(10)
            make.centerY.equalTo(descLabel)
        }
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        
        ratioLabel = UILabel()
        addSubview(ratioLabel)
        ratioLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(descLabel.snp.bottom).offset(8)
        }
        ratioLabel.font = UIFont.systemFont(ofSize: 12)
        ratioLabel.textAlignment = .left
        ratioLabel.textColor = Color.vocal
        
        
        detailLabel = UILabel()
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(ratioLabel.snp.bottom).offset(8)
        }
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.numberOfLines = 0
        detailLabel.textColor = UIColor.darkGray
        
        
        timeStatusIndicator = TimeStatusIndicator()
        addSubview(timeStatusIndicator)
        timeStatusIndicator.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.height.width.equalTo(12)
            make.top.equalTo(detailLabel.snp.bottom).offset(6)
        }
        
        timeLabel = UILabel()
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeStatusIndicator.snp.right).offset(10)
            make.centerY.equalTo(timeStatusIndicator)
            make.right.lessThanOrEqualTo(-10)
        }
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.baselineAdjustment = .alignCenters
        timeLabel.textColor = UIColor.darkGray
        
        let line1 = LineView()
        addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.height.equalTo(1 / Screen.scale)
        }
        
        let descLabel2 = UILabel()
        addSubview(descLabel2)
        descLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(line1.snp.bottom).offset(8)
        }
        descLabel2.font = UIFont.systemFont(ofSize: 16)
        descLabel2.text = NSLocalizedString("新增卡片", comment: "模拟抽卡页面")
        descLabel2.textColor = UIColor.black
        
        let moreCardLabel = UILabel()
        addSubview(moreCardLabel)
        moreCardLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(line1.snp.bottom).offset(8)
        }
        moreCardLabel.text = NSLocalizedString("查看完整卡池", comment: "模拟抽卡页面") + " >"
        moreCardLabel.font = UIFont.systemFont(ofSize: 16)
        moreCardLabel.textColor = UIColor.lightGray
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(seeMoreCardAction))
        moreCardLabel.addGestureRecognizer(tap)
        moreCardLabel.textAlignment = .right
        moreCardLabel.isUserInteractionEnabled = true
        
        cardListView = GachaCardWithOddsListView()
        addSubview(cardListView)
        cardListView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(moreCardLabel.snp.bottom).offset(5)
        }
        cardListView.delegate = self
        
        let line2 = LineView()
        addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(cardListView.snp.bottom).offset(10)
            make.height.equalTo(1 / Screen.scale)
        }
        
        guaranteesView = CardDetailRelatedCardsCell()
        guaranteesView.rightLabel.isHidden = true
        guaranteesView.leftLabel.text = NSLocalizedString("天井", comment: "模拟抽卡页面")
        addSubview(guaranteesView.contentView)
        guaranteesView.contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(line2.snp.bottom)
        }
        guaranteesView.delegate = self
        
        let line3 = LineView()
        addSubview(line3)
        line3.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(guaranteesView.contentView.snp.bottom)
            make.height.equalTo(1 / Screen.scale)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func setupWith(pool: CGSSGachaPool) {

        nameLabel.text = pool.name
        ratioLabel.text = "SSR: \(Float(pool.ssrRatio) / 100)%   SR: \(Float(pool.srRatio) / 100)%   R: \(Float(pool.rareRatio) / 100)%"
        detailLabel.text = pool.dicription
        timeLabel.text = "\(pool.startDate.toDate().toString(format: "(zzz)yyyy-MM-dd HH:mm:ss", timeZone: TimeZone.current)) ~ \(pool.endDate.toDate().toString(timeZone: TimeZone.current))"
        
        let start = pool.startDate.toDate()
        let end = pool.endDate.toDate()
        let now = Date()
        if now >= start && now <= end {
            timeStatusIndicator.style = .now
        } else if now < start {
            timeStatusIndicator.style = .future
        } else if now > end {
            timeStatusIndicator.style = .past
        }
        
        let dao = CGSSDAO.shared
        var cards = [CGSSCard]()
        for reward in pool.new {
            if let card = dao.findCardById(reward.cardId) {
                cards.append(card)
            }
        }
        let sorter = CGSSSorter.init(property: "sRarity")
        sorter.sortList(&cards)
        cardListView.setupWith(cards: cards, odds: cards.map { pool.rewardTable[$0.id]?.relativeOdds })
        
        guaranteesView.cards = pool.cardsOfguaranteed
    }
    
    @objc func seeMoreCardAction() {
        delegate?.seeModeCard(gachaDetailView: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GachaDetailView: CardDetailRelatedCardsCellDelegate, CGSSIconViewDelegate {
    
    func didClickRightDetail(_ cardDetailRelatedCardsCell: CardDetailRelatedCardsCell) {
        if cardDetailRelatedCardsCell == self.cardListView {
            delegate?.seeModeCard(gachaDetailView: self)
        }
    }
    
    func iconClick(_ iv: CGSSIconView) {
        delegate?.gachaDetailView(self, didClick: iv as! CGSSCardIconView)
    }
    
}

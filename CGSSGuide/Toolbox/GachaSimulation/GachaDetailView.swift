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
    
    var banner: GachaBannerView!
    var gachaInfoView: UIView!
    var nameLabel:UILabel!
    var detailLabel:UILabel!
    var ratioLabel:UILabel!
    var timeLabel:UILabel!
    var timeStatusIndicator:ZKCornerRadiusView!
    var cardListView: UIView!
    var line: UIView!
    
    weak var delegate: GachaDetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        banner = GachaBannerView()
        addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Screen.width * 212 / 824)
        }
        
        let descLabel = UILabel()
        descLabel.text = NSLocalizedString("卡池", comment: "模拟抽卡页面")  + ": "
        descLabel.textAlignment = .left
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.sizeToFit()
        addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(banner.snp.bottom).offset(8)
        }
        
        nameLabel = UILabel()
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel.snp.right).offset(10)
            make.centerY.equalTo(descLabel)
        }
        nameLabel.adjustsFontSizeToFitWidth = true
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
            //.init(frame: CGRect.init(x: space, y: originY, width: CGSSGlobal.width - 2 * space, height: 0))
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(ratioLabel.snp.bottom).offset(8)
        }
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.numberOfLines = 0
        detailLabel.textColor = UIColor.darkGray
        
        
        timeStatusIndicator = ZKCornerRadiusView.init(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        timeStatusIndicator.zk_cornerRadius = 6
        addSubview(timeStatusIndicator)
        timeStatusIndicator.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.height.width.equalTo(12)
            make.top.equalTo(detailLabel.snp.bottom).offset(6)
        }
        
        
        timeLabel = UILabel()
            //.init(frame: CGRect.init(x: space + 22, y: originY, width: CGSSGlobal.width - space * 2 - 22, height: 12))
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeStatusIndicator.snp.right).offset(10)
            make.centerY.equalTo(timeStatusIndicator)
            make.right.lessThanOrEqualTo(-10)
        }
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = UIColor.darkGray
        
        line = UIView()
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.height.equalTo(1 / Screen.scale)
        }
        line.backgroundColor = Color.separator
        
        let descLabel2 = UILabel()
        addSubview(descLabel2)
        descLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(line.snp.bottom).offset(8)
        }
        descLabel2.font = UIFont.systemFont(ofSize: 16)
        descLabel2.text = NSLocalizedString("新卡列表", comment: "模拟抽卡页面") + ":"
        descLabel2.textColor = UIColor.black
        
        let moreCardLabel = UILabel()
        //.init(frame: CGRect(x: 100, y: insideY, width: CGSSGlobal.width - 110, height: 17))
        addSubview(moreCardLabel)
        moreCardLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(descLabel)
        }
        moreCardLabel.text = NSLocalizedString("查看完整卡池", comment: "模拟抽卡页面") + " >"
        moreCardLabel.font = UIFont.systemFont(ofSize: 16)
        moreCardLabel.textColor = UIColor.lightGray
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(seeMoreCardAction))
        moreCardLabel.addGestureRecognizer(tap)
        moreCardLabel.textAlignment = .right
        moreCardLabel.isUserInteractionEnabled = true
        
        cardListView = UIView()
        addSubview(cardListView)
        cardListView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(moreCardLabel.snp.bottom).offset(8)
            make.height.equalTo(0)
        }
        
    }
    
    func setupWith(pool: CGSSGachaPool) {
        nameLabel.text = pool.name
        ratioLabel.text = "SSR: \(Float(pool.ssrRatio) / 100)%   SR: \(Float(pool.srRatio) / 100)%   R: \(Float(pool.rareRatio) / 100)%"
        detailLabel.text = pool.dicription
        timeLabel.text = "\(pool.startDate) ~ \(pool.endDate)"
        
        let start = pool.startDate.toDate()
        let end = pool.endDate.toDate()
        let now = Date()
        if now >= start && now <= end {
            timeStatusIndicator.zk_backgroundColor = UIColor.green.withAlphaComponent(0.6)
        } else if now < start {
            timeStatusIndicator.zk_backgroundColor = UIColor.orange.withAlphaComponent(0.6)
        } else if now > end {
            timeStatusIndicator.zk_backgroundColor = UIColor.red.withAlphaComponent(0.6)
        }
        timeStatusIndicator.zk_render()
        
        let dao = CGSSDAO.sharedDAO
        var cards = [CGSSCard]()
        for reward in pool.new {
            if let card = dao.findCardById(reward.cardId) {
                cards.append(card)
            }
        }
        let sorter = CGSSSorter.init(property: "sRarity")
        sorter.sortList(&cards)
        setupCardListView(cards)
    }
    
    func seeMoreCardAction() {
        delegate?.seeModeCard(gachaDetailView: self)
    }
    
    var cardIcons = [CGSSCardIconView]()
    func setupCardListView(_ cards: [CGSSCard]) {
        
        for icon in cardIcons {
            icon.removeFromSuperview()
        }
        cardIcons.removeAll()
        let column = floor((CGSSGlobal.width - 2 * 10) / 50)
        let spaceTotal = CGSSGlobal.width - 2 * 10 - column * 48
        let interSpace = spaceTotal / (column - 1)
        for i in 0..<cards.count {
            let y = CGFloat(i / Int(column)) * (48 + interSpace) + 37
            let x = CGFloat(i % Int(column)) * (48 + interSpace) + 10
            let icon = CGSSCardIconView.init(frame: CGRect(x: x, y: y, width: 48, height: 48))
            icon.setWithCardId(cards[i].id, target: self, action: #selector(iconClick))
            cardListView.addSubview(icon)
            cardIcons.append(icon)
        }
        
        
        if cards.count > 0 {
            cardListView.snp.updateConstraints { (update) in
                update.height.equalTo(ceil(CGFloat(cards.count) / column) * (48 + interSpace) - interSpace + 10)
            }
        } else {
            cardListView.snp.updateConstraints { (update) in
                update.height.equalTo(0)
            }
        }
        
    }
    
    func iconClick(iv: CGSSCardIconView) {
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

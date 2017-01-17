//
//  EventDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import ZKCornerRadiusView

protocol EventDetailViewDelegate: class {
    func eventDetailView(_ view: EventDetailView, didClick icon: CGSSCardIconView)
    func eventDetailView(_ view: EventDetailView, didSelect live: CGSSLive, of difficulty: Int)
}

class EventDetailView: UIView, CGSSIconViewDelegate, EventSongViewDelegate {

    var banner: EventBannerView!
    
//    var nameLabel: UILabel!
    
    var startToEndLabel: UILabel!
    
    var timeIndicator: ZKCornerRadiusView!
    
    var line1: UIView!
    
    var line2: UIView!
    
    var line3: UIView!
    
    var card1View: EventCardView!
    
    var card2View: EventCardView!
    
    var songDescLabel: UILabel!
    
    var songView: EventSongView!
    
    weak var delegate: EventDetailViewDelegate?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        banner = EventBannerView()
        addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Screen.width * 212 / 824)
        }
        
//        nameLabel = UILabel()
//        addSubview(nameLabel)
//        nameLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.top.equalTo(banner.snp.bottom).offset(8)
//        }
//        nameLabel.font = Font.title
        
        startToEndLabel = UILabel()
        addSubview(startToEndLabel)
        startToEndLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.left.equalTo(22)
            make.top.equalTo(banner.snp.bottom).offset(8)
        }
        startToEndLabel.font = Font.title
        startToEndLabel.textAlignment = .center
        startToEndLabel.adjustsFontSizeToFitWidth = true
        
        timeIndicator = ZKCornerRadiusView.init(frame: CGRect.init(x: 0, y: 0, width: 12, height: 12))
        addSubview(timeIndicator)
        timeIndicator.snp.makeConstraints { (make) in
            make.height.width.equalTo(12)
            make.left.equalTo(10)
            make.centerY.equalTo(startToEndLabel)
        }
        timeIndicator.zk_cornerRadius = 6
        
        line1 = UIView()
        line1.backgroundColor = Color.separator
        addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1 / Screen.scale)
            make.top.equalTo(startToEndLabel.snp.bottom).offset(8)
        }
        
//        cardLabel = UILabel()
//        addSubview(cardLabel)
//        cardLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.top.equalTo(line.snp.bottom).offset(8)
//        }
//        cardLabel.font = Font.title
//        cardLabel.text = NSLocalizedString("活动卡：", comment: "")
//        
        card1View = EventCardView()
        addSubview(card1View)
        card1View.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(line1.snp.bottom)
            make.height.equalTo(94)
        }
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        card1View.addGestureRecognizer(tap1)
    
        line3 = UIView()
        line3.backgroundColor = Color.separator
        addSubview(line3)
        line3.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1 / Screen.scale)
            make.top.equalTo(card1View.snp.bottom)
        }
        
        card2View = EventCardView()
        addSubview(card2View)
        card2View.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview()
            make.top.equalTo(line3.snp.bottom)
            make.height.equalTo(94)
        }
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        card2View.addGestureRecognizer(tap2)
        
        
        line2 = UIView()
        line2.backgroundColor = Color.separator
        addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1 / Screen.scale)
            make.top.equalTo(card2View.snp.bottom)
        }
        
        songDescLabel = UILabel()
        addSubview(songDescLabel)
        songDescLabel.textColor = UIColor.darkGray
        songDescLabel.text = NSLocalizedString("活动曲", comment: "")
        songDescLabel.font = Font.content
        songDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(line2.snp.bottom).offset(8)
        }
        
        songView = EventSongView()
        addSubview(songView)
        songView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(songDescLabel.snp.bottom).offset(-2)
            make.height.equalTo(86)
            make.bottom.equalToSuperview()
        }
        songView.delegate = self
        songView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapAction(tap: UITapGestureRecognizer) {
        if let view = tap.view as? EventCardView {
            delegate?.eventDetailView(self, didClick: view.cardView.cardIconView)
        }
    }
    
    func setup(event: CGSSEvent, bannerId: Int) {
//        if let url = URL.init(string: String.init(format: "https://games.starlight-stage.jp/image/announce/header/header_event_%04d.png", bannerId)) {
//            banner.sd_setImage(with: url)
//            banner.snp.updateConstraints({ (update) in
//                update.height.equalTo(Screen.width * 212 / 824)
//            })
//        } else {
//            banner.snp.updateConstraints({ (update) in
//                update.height.equalTo(0)
//            })
//        }
        
        if event.startDate.toDate() > Date() {
            timeIndicator.zk_backgroundColor = UIColor.orange.withAlphaComponent(0.6)
        } else if event.endDate.toDate() < Date() {
            timeIndicator.zk_backgroundColor = UIColor.red.withAlphaComponent(0.6)
        } else {
            timeIndicator.zk_backgroundColor = UIColor.green.withAlphaComponent(0.6)
        }
        timeIndicator.zk_render()
//        if event.startDate.toDate() > Date() {
//            banner.preBannerId = event.id
//        } else {
//            banner.detailBannerId = bannerId
//        }

        banner.preBannerId = event.id
        // 前两次篷车活动特殊处理
        if event.id == 2001 || event.id == 2002 {
            banner.preBannerId = 2003
        }
        // 前两次传统活动特殊处理
        if event.id == 1001 {
            banner.detailBannerId = 1
        } else if event.id == 1002 {
            banner.detailBannerId = 3
        }
        
//        nameLabel.text = event.name
        if event.startDate.toDate() > Date() {
            startToEndLabel.text = NSLocalizedString("待定", comment: "")
            card1View.isHidden = true
            card2View.isHidden = true
            songView.isHidden = true
            songDescLabel.isHidden = true
            line1.isHidden = true
            line2.isHidden = true
            line3.isHidden = true
            
        } else {
            startToEndLabel.text = "\(event.startDate) ~ \(event.endDate)"
            if event.reward.count >= 2 {
                var rewards = event.reward.sorted(by: { (r1, r2) -> Bool in
                    return r1.rewardRecommand < r2.rewardRecommand
                })
                if let card1 = CGSSDAO.sharedDAO.findCardById(rewards[0].cardId) {
                    card1View.setup(card: card1, desc: NSLocalizedString("上位", comment: ""))
                }
                if let card2 = CGSSDAO.sharedDAO.findCardById(rewards[1].cardId) {
                    card2View.setup(card: card2, desc: NSLocalizedString("下位", comment: ""))
                }
            }
            
            if let live = event.live {
                songView.setup(live: live)
                songView.snp.updateConstraints({ (update) in
                    update.height.equalTo(88)
                })
                songDescLabel.isHidden = false

            } else {
                songView.snp.updateConstraints({ (update) in
                    update.height.equalTo(0)
                })
                songDescLabel.isHidden = true
            }

        }
        
            
    }
    
    func iconClick(_ iv: CGSSIconView) {
        delegate?.eventDetailView(self, didClick: iv as! CGSSCardIconView)
    }
    
    func eventSongView(_ view: EventSongView, didSelect live: CGSSLive, of difficulty: Int) {
        delegate?.eventDetailView(self, didSelect: live, of: difficulty)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

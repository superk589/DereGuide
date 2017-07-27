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
    func eventDetailView(_ view: EventDetailView, didSelect scene: CGSSLiveScene)
    func gotoPtChartView(eventDetailView: EventDetailView)
    func gotoScoreChartView(eventDetailView: EventDetailView)
    func gotoLiveTrendView(eventDetailView: EventDetailView)
    func refreshPtView(eventDetailView: EventDetailView)
    func refreshScoreView(eventDetailView: EventDetailView)
}

class EventDetailView: UIView, CGSSIconViewDelegate {

    var startToEndLabel: UILabel!
    
    var timeIndicator: TimeStatusIndicator!
    
    var line1: UIView!
    
    var line2: UIView!
    
    var line3: UIView!
    
    var card1View: EventCardView!
    
    var card2View: EventCardView!
    
    var songDescLabel: UILabel!
    
    var liveTrendLabel: UILabel!
    
    var liveView: LiveView!
    
    var eventPtContentView: UIView!
    var line4: LineView!
    var eventPtDescLabel: UILabel!
    var gotoPtChartLabel: UILabel!
    var eventPtView: EventPtView!
    
    var eventScoreContentView: UIView!
    var line5: LineView!
    var eventScoreDescLabel: UILabel!
    var gotoScoreChartLabel: UILabel!
    var eventScoreView: EventScoreView!

    
    private struct Height {
        static let ptContentView: CGFloat = 192
        static let scoreContentView: CGFloat = 156
    }
    weak var delegate: EventDetailViewDelegate?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
            make.right.lessThanOrEqualTo(-10)
            make.left.equalTo(32)
            make.top.equalTo(8)
        }
        startToEndLabel.font = UIFont.systemFont(ofSize: 12)
        startToEndLabel.textColor = UIColor.darkGray
        startToEndLabel.textAlignment = .left
        startToEndLabel.adjustsFontSizeToFitWidth = true
        startToEndLabel.baselineAdjustment = .alignCenters
        
        timeIndicator = TimeStatusIndicator()
        addSubview(timeIndicator)
        timeIndicator.snp.makeConstraints { (make) in
            make.height.width.equalTo(12)
            make.left.equalTo(10)
            make.centerY.equalTo(startToEndLabel)
        }
        
        line1 = LineView()
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
            make.height.equalTo(91)
        }
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        card1View.addGestureRecognizer(tap1)
    
        line3 = LineView()
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
            make.height.equalTo(91)
        }
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        card2View.addGestureRecognizer(tap2)
        
        
        line2 = LineView()
        addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1 / Screen.scale)
            make.top.equalTo(card2View.snp.bottom)
        }
        
        songDescLabel = UILabel()
        addSubview(songDescLabel)
        songDescLabel.textColor = UIColor.black
        songDescLabel.text = NSLocalizedString("活动曲", comment: "")
        songDescLabel.font = Font.title
        songDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(line2.snp.bottom).offset(8)
        }
        
        liveTrendLabel = UILabel()
        addSubview(liveTrendLabel)
        liveTrendLabel.textColor = UIColor.lightGray
        liveTrendLabel.text = NSLocalizedString("流行曲", comment: "") + " >"
        liveTrendLabel.font = Font.title
        liveTrendLabel.snp.makeConstraints { (make) in
            make.top.equalTo(line2.snp.bottom).offset(8)
            make.right.equalTo(-10)
        }
        liveTrendLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(gotoLiveTrendViewAction(gesture:)))
        liveTrendLabel.addGestureRecognizer(tap)
        
        liveView = LiveView()
        addSubview(liveView)
        liveView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(songDescLabel.snp.bottom)
            make.height.equalTo(88)
        }
        liveView.delegate = self
        
        eventPtContentView = UIView()
        addSubview(eventPtContentView)
        eventPtContentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(liveView.snp.bottom)
            make.height.equalTo(192)
        }
        eventPtContentView.layer.masksToBounds = true
        
        line4 = LineView()
        eventPtContentView.addSubview(line4)
        line4.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1 / Screen.scale)
            make.top.equalToSuperview()
        }

        eventPtDescLabel = UILabel()
        eventPtContentView.addSubview(eventPtDescLabel)
        eventPtDescLabel.textColor = UIColor.black
        eventPtDescLabel.text = NSLocalizedString("活动pt档位", comment: "")
        eventPtDescLabel.font = Font.title
        eventPtDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(line4.snp.bottom).offset(8)
        }
        
        gotoPtChartLabel = UILabel()
        eventPtContentView.addSubview(gotoPtChartLabel)
        gotoPtChartLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(eventPtDescLabel)
        }
        gotoPtChartLabel.font = Font.title
        gotoPtChartLabel.textColor = UIColor.lightGray
        gotoPtChartLabel.text = NSLocalizedString("查看完整图表", comment: "") + " >"
        let tap3 = UITapGestureRecognizer.init(target: self, action: #selector(gotoPtChartAction))
        gotoPtChartLabel.addGestureRecognizer(tap3)
        gotoPtChartLabel.isUserInteractionEnabled = true
        gotoPtChartLabel.isHidden = true
        
        
        eventPtView = EventPtView()
        eventPtContentView.addSubview(eventPtView)
        eventPtView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(158.5)
            make.top.equalTo(eventPtDescLabel.snp.bottom).offset(-2)
        }
        
        eventPtView.delegate = self
        
        eventScoreContentView = UIView()
        addSubview(eventScoreContentView)
        eventScoreContentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(eventPtContentView.snp.bottom)
            make.height.equalTo(156)
            make.bottom.equalToSuperview().offset(-30)
        }
        eventScoreContentView.layer.masksToBounds = true
        
        line5 = LineView()
        eventScoreContentView.addSubview(line5)
        line5.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1 / Screen.scale)
            make.top.equalToSuperview()
        }
        
        eventScoreDescLabel = UILabel()
        eventScoreContentView.addSubview(eventScoreDescLabel)
        eventScoreDescLabel.textColor = UIColor.black
        eventScoreDescLabel.text = NSLocalizedString("歌曲分数档位", comment: "")
        eventScoreDescLabel.font = Font.title
        eventScoreDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(line5.snp.bottom).offset(8)
        }
        
        gotoScoreChartLabel = UILabel()
        eventScoreContentView.addSubview(gotoScoreChartLabel)
        gotoScoreChartLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(eventScoreDescLabel)
        }
        gotoScoreChartLabel.font = Font.title
        gotoScoreChartLabel.textColor = UIColor.lightGray
        gotoScoreChartLabel.text = NSLocalizedString("查看完整图表", comment: "") + " >"
        let tap4 = UITapGestureRecognizer.init(target: self, action: #selector(gotoScoreChartAction))
        gotoScoreChartLabel.isUserInteractionEnabled = true
        gotoScoreChartLabel.addGestureRecognizer(tap4)
        gotoScoreChartLabel.isHidden = true
        
        eventScoreView = EventScoreView()
        eventScoreContentView.addSubview(eventScoreView)
        eventScoreView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(122.5)
            make.top.equalTo(eventScoreDescLabel.snp.bottom).offset(-2)
        }
        
        eventScoreView.delegate = self
        
        
        // TODO: 歌曲分数档线
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapAction(tap: UITapGestureRecognizer) {
        if let view = tap.view as? EventCardView {
            delegate?.eventDetailView(self, didClick: view.cardView.cardIconView)
        }
    }
    
    @objc func gotoScoreChartAction() {
        delegate?.gotoScoreChartView(eventDetailView: self)
    }
    
    @objc func gotoPtChartAction() {
        delegate?.gotoPtChartView(eventDetailView: self)
    }
    
    @objc func gotoLiveTrendViewAction(gesture: UITapGestureRecognizer) {
        delegate?.gotoLiveTrendView(eventDetailView: self)
    }
    
    func setup(event: CGSSEvent, bannerId: Int) {
        if event.startDate.toDate() > Date() {
            timeIndicator.style = .future
        } else if event.endDate.toDate() < Date() {
            timeIndicator.style = .past
        } else {
            timeIndicator.style = .now
        }
        
        if event.startDate.toDate() > Date() {
//            if let preStartDateString = event.preStartDate?.toString(format: "(zzz)yyyy-MM-dd HH:mm:ss", timeZone: TimeZone.current) {
//                startToEndLabel.text = "\(preStartDateString) ~ \(NSLocalizedString("待定", comment: ""))"
//            }
            
            // startToEndLabel.text = Date().toString(format: "yyyy") + "-" + event.startDate.toDate().toString(format: "MM-dd")
            startToEndLabel.text = NSLocalizedString("待定", comment: "")
            card1View.isHidden = true
            card2View.isHidden = true
            liveView.isHidden = true
            songDescLabel.isHidden = true
            liveTrendLabel.isHidden = true
            
            line1.isHidden = true
            line2.isHidden = true
            line3.isHidden = true
            
            eventPtContentView.isHidden = true
            eventScoreContentView.isHidden = true
            
        } else {
            startToEndLabel.text = "\(event.startDate.toDate().toString(format: "(zzz)yyyy-MM-dd HH:mm:ss", timeZone: TimeZone.current)) ~ \(event.endDate.toDate().toString(timeZone: TimeZone.current))"
            if event.reward.count >= 2 {
                var rewards = event.reward.sorted(by: { (r1, r2) -> Bool in
                    return r1.recommandOrder < r2.recommandOrder
                })
                if let card1 = CGSSDAO.shared.findCardById(rewards[0].cardId) {
                    card1View.setup(card: card1, desc: NSLocalizedString("上位", comment: ""))
                }
                if let card2 = CGSSDAO.shared.findCardById(rewards[1].cardId) {
                    card2View.setup(card: card2, desc: NSLocalizedString("下位", comment: ""))
                }
            }
            
            if let live = event.live {
                liveView.setup(with: live)
                liveView.snp.updateConstraints { (update) in
                    update.height.equalTo(88)
                }
                songDescLabel.isHidden = false
            } else {
                liveView.snp.updateConstraints { (update) in
                    update.height.equalTo(0)
                }
                songDescLabel.isHidden = true
            }
        
            if CGSSEventTypes.ptRankingExists.contains(event.eventType) {
                eventPtContentView.snp.updateConstraints { (update) in
                    update.height.equalTo(Height.ptContentView)
                }
            } else {
                eventPtContentView.snp.updateConstraints { (update) in
                    update.height.equalTo(0)
                }
            }
            
            if CGSSEventTypes.scoreRankingExists.contains(event.eventType) {
                eventScoreContentView.snp.updateConstraints { (update) in
                    update.height.equalTo(Height.scoreContentView)
                }
            } else {
                eventScoreContentView.snp.updateConstraints { (update) in
                    update.height.equalTo(0)
                }
            }
            
            liveTrendLabel.isHidden = !event.hasTrendLives
        }
    }
    
    func setup(ptList: EventPtRanking, onGoing: Bool) {
        eventPtView.setup(rankingList: ptList, onGoing: onGoing)
        if ptList.list.count > 0 {
            gotoPtChartLabel.isHidden = false
        }
    }
    
    func setup(scoreList: EventScoreRanking, onGoing: Bool) {
        eventScoreView.setup(rankingList: scoreList, onGoing: onGoing)
        if scoreList.list.count > 0 {
            gotoScoreChartLabel.isHidden = false
        }
    }
    
    func iconClick(_ iv: CGSSIconView) {
        delegate?.eventDetailView(self, didClick: iv as! CGSSCardIconView)
    }
}

extension EventDetailView: EventPtViewDelegate {
    
    func refresh(eventPtView: EventPtView) {
        delegate?.refreshPtView(eventDetailView: self)
    }
    
}

extension EventDetailView: EventScoreViewDelegate {
    
    func refresh(eventScoreView: EventScoreView) {
        delegate?.refreshScoreView(eventDetailView: self)
    }
    
}

extension EventDetailView: LiveViewDelegate {
    
    func liveView(_ liveView: LiveView, didSelect scene: CGSSLiveScene) {
        delegate?.eventDetailView(self, didSelect: scene)
    }
    
}

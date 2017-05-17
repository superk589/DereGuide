//
//  TeamSimulationLiveSelectCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class TeamSimulationLiveView: UIView {
    
    var jacketImageView: BannerView!
    var typeIcon: UIImageView!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    var backgroundLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        jacketImageView = BannerView()
        addSubview(jacketImageView)
        jacketImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
        
        typeIcon = UIImageView()
        addSubview(typeIcon)
        typeIcon.snp.makeConstraints { (make) in
            make.left.equalTo(jacketImageView.snp.right).offset(10)
            make.top.equalTo(jacketImageView)
            make.width.height.equalTo(20)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeIcon.snp.right).offset(5)
            make.centerY.equalTo(typeIcon)
            make.right.lessThanOrEqualToSuperview()
        }
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.textAlignment = .left
        addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeIcon)
            make.bottom.equalTo(jacketImageView)
        }
        
        backgroundLabel = UILabel()
        addSubview(backgroundLabel)
        backgroundLabel.font = UIFont.systemFont(ofSize: 18)
        backgroundLabel.textColor = UIColor.lightGray
        backgroundLabel.text = NSLocalizedString("请选择歌曲", comment: "队伍详情页面")
        backgroundLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func setupWith(live: CGSSLive, liveDetail: CGSSLiveDetail) {
        backgroundLabel.text = ""
        guard let beatmap = liveDetail.beatmap else {
            return
        }
        descriptionLabel.text = "\(liveDetail.stars)☆ \(liveDetail.difficulty.description) bpm: \(live.bpm) notes: \(beatmap.numberOfNotes) \(NSLocalizedString("时长", comment: "队伍详情页面")): \(Int(beatmap.totalSeconds))\(NSLocalizedString("秒", comment: "队伍详情页面"))"
        
        nameLabel.text = live.name
        nameLabel.textColor = live.color
        typeIcon.image = live.icon
        
        if let url = live.jacketURL {
            jacketImageView.sd_setImage(with: url)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TeamSimulationLiveSelectCell: UITableViewCell {
    
    
    // var leftLabel: UILabel!
    
    // var rightLabel: UILabel!
    
    var liveView: TeamSimulationLiveView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        leftLabel = UILabel()
//        leftLabel.font = UIFont.systemFont(ofSize: 16)
//        contentView.addSubview(leftLabel)
      
//        leftLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.top.equalTo(10)
//        }
//        
//        leftLabel.text = NSLocalizedString("歌曲", comment: "") + ": "
        
        liveView = TeamSimulationLiveView()
        contentView.addSubview(liveView)
        liveView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
    
    func setupWith(live: CGSSLive, liveDetail: CGSSLiveDetail) {
        liveView.setupWith(live: live, liveDetail: liveDetail)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

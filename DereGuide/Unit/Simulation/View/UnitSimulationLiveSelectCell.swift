//
//  UnitSimulationLiveSelectCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitSimulationLiveView: UIView {
    
    let jacketImageView = BannerView()
    let typeIcon = UIImageView()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let backgroundLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(jacketImageView)
        jacketImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
        
        addSubview(typeIcon)
        typeIcon.snp.makeConstraints { (make) in
            make.left.equalTo(jacketImageView.snp.right).offset(10)
            make.top.equalTo(jacketImageView)
            make.width.height.equalTo(20)
        }
        
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeIcon.snp.right).offset(5)
            make.centerY.equalTo(typeIcon)
            make.right.lessThanOrEqualToSuperview()
        }
        
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.baselineAdjustment = .alignCenters
        descriptionLabel.textAlignment = .left
        addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeIcon)
            make.bottom.equalTo(jacketImageView)
            make.right.lessThanOrEqualTo(-10)
        }
        
        addSubview(backgroundLabel)
        backgroundLabel.font = .systemFont(ofSize: 18)
        backgroundLabel.textColor = .lightGray
        backgroundLabel.text = NSLocalizedString("请选择歌曲", comment: "队伍详情页面")
        backgroundLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func setup(with scene: CGSSLiveScene?) {
        guard let scene = scene, let beatmap = scene.beatmap else {
            backgroundLabel.text = NSLocalizedString("请选择歌曲", comment: "队伍详情页面")
            descriptionLabel.text = ""
            jacketImageView.image = nil
            nameLabel.text = ""
            typeIcon.image = nil
            return
        }
        backgroundLabel.text = ""
        descriptionLabel.text = "\(scene.stars)☆ \(scene.difficulty.description) bpm: \(scene.live.bpm) notes: \(beatmap.numberOfNotes) \(NSLocalizedString("时长", comment: "队伍详情页面")): \(Int(beatmap.totalSeconds))\(NSLocalizedString("秒", comment: "队伍详情页面"))"
        
        nameLabel.text = scene.live.name
        nameLabel.textColor = scene.live.color
        typeIcon.image = scene.live.icon
        
        jacketImageView.sd_setImage(with: scene.live.jacketURL)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UnitSimulationLiveSelectCell: UITableViewCell {
    
    let liveView = UnitSimulationLiveView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    func setup(with scene: CGSSLiveScene?) {
        liveView.setup(with: scene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

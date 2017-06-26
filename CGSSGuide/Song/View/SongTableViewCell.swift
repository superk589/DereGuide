//
//  SongTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKCornerRadiusView
import SnapKit

class LiveDifficultyView: UIView {
    var label: UILabel!
    var backgoundView: ZKCornerRadiusView!
    var text: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgoundView = ZKCornerRadiusView.init(frame: self.bounds)
        addSubview(backgoundView)
        backgoundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        label = UILabel()
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textColor = UIColor.white
        label.textAlignment = .center
        backgoundView.zk.cornerRadius = 8
    }
    
    func addTarget(_ target: AnyObject?, action: Selector) {
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        self.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgoundView.image = nil
        backgoundView.render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SongTableViewCellDelegate: class {
    func songTableViewCell(_ songTableViewCell: SongTableViewCell, didSelect scene: CGSSLiveScene)
}

class SongTableViewCell: UITableViewCell {
    
    weak var delegate: SongTableViewCellDelegate?
    var jacketImageView: UIImageView!
    var nameLabel: UILabel!
    var typeIcon: UIImageView!
    var descriptionLabel: UILabel!
    var stackView: UIStackView!
    var difficultyViews: [LiveDifficultyView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepare()
    }
    
    fileprivate func prepare() {
        jacketImageView = BannerView()
        contentView.addSubview(jacketImageView)
        jacketImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.width.height.equalTo(66)
            make.bottom.equalTo(-10)
        }
        
        typeIcon = UIImageView()
        contentView.addSubview(typeIcon)
        typeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(jacketImageView.snp.right).offset(10)
            make.width.height.equalTo(20)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeIcon.snp.right).offset(5)
            make.right.lessThanOrEqualTo(-10)
            make.centerY.equalTo(typeIcon)
        }
        
//        descriptionLabel = UILabel()
//        descriptionLabel.frame = CGRect(x: 86, y: 35, width: CGSSGlobal.width - 96, height: 16)
//        descriptionLabel.font = CGSSGlobal.alphabetFont
//        addSubview(descriptionLabel)
//        descriptionLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(jacketImageView.snp.right).offset(10)
//            make.top.equalTo()
//        }
        
//        let width = floor((CGSSGlobal.width - 96 - 40) / 5)
//        let space: CGFloat = 10
//        // let fontSize: CGFloat = 16
//        let height: CGFloat = 33
//        let originY: CGFloat = 43
//        let originX: CGFloat = 86
//        
//        contentView.addSubview(jacketImageView)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(typeIcon)
        // contentView.addSubview(descriptionLabel)
        
//        let colors = [Color.debut, Color.regular, Color.pro, Color.master, Color.masterPlus]
        difficultyViews = [LiveDifficultyView]()
        for i in 0...4 {
            let diffView = LiveDifficultyView()
//            diffView.iv.zk.backgroundColor = colors[i]
//            diffView.iv.render()
            diffView.label.textColor = UIColor.darkGray
            diffView.tag = i + 1
            diffView.addTarget(self, action: #selector(diffClick))
            difficultyViews.append(diffView)
        }
        
        stackView = UIStackView(arrangedSubviews: difficultyViews)
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(jacketImageView.snp.right).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(33)
            make.bottom.equalTo(jacketImageView)
        }
        
        selectionStyle = .none
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func diffClick(_ tap: UITapGestureRecognizer) {
        let selectedDifficulty = CGSSLiveDifficulty(rawValue: tap.view!.tag)!
        if live.difficultyTypes.contains(selectedDifficulty.difficultyTypes) {
            delegate?.songTableViewCell(self, didSelect: CGSSLiveScene(live: live, difficulty: selectedDifficulty))
        }
    }
    
    var live: CGSSLive!
    func setup(with live: CGSSLive) {
        self.live = live
        self.nameLabel.text = live.title
        self.nameLabel.textColor = live.color
        self.typeIcon.image = live.icon
        let diffStars = live.liveDetails.map { $0.stars }
        
        let difficulties = CGSSLiveDifficulty.all
        for i in 0...4 {
            let view = difficultyViews[i]
            view.text = "\(diffStars[i])"
            let color = view.backgoundView.zk.backgroundColor
            if !live.difficultyTypes.contains(difficulties[i].difficultyTypes) {
                view.backgoundView.zk.backgroundColor = UIColor.lightBackground
            } else {
                view.backgoundView.zk.backgroundColor = difficulties[i].color
            }
            if color != view.backgoundView.zk.backgroundColor {
                view.backgoundView.image = nil
                view.backgoundView.render()
            }
        }
        
        self.difficultyViews[4].alpha = (live.maxDiff.rawValue == 5) ? 1 : 0
        
        if let url = live.jacketURL {
            self.jacketImageView.sd_setImage(with: url)
        }
    }
}

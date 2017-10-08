//
//  LiveView.swift
//  DereGuide
//
//  Created by zzk on 2017/7/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import ZKCornerRadiusView

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
        label.textColor = .darkGray
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

protocol LiveViewDelegate: class {
    func liveView(_ liveView: LiveView, didSelect scene: CGSSLiveScene)
}

class LiveView: UIView {
    
    weak var delegate: LiveViewDelegate?
    
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
        addSubview(jacketImageView)
        jacketImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.width.height.equalTo(66)
            make.bottom.equalTo(-10)
        }
        
        typeIcon = UIImageView()
        addSubview(typeIcon)
        typeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(jacketImageView.snp.right).offset(10)
            make.width.height.equalTo(20)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeIcon.snp.right).offset(5)
            make.right.lessThanOrEqualTo(-10)
            make.centerY.equalTo(typeIcon)
        }
        
        difficultyViews = [LiveDifficultyView]()
        for i in 0...4 {
            let diffView = LiveDifficultyView()
            diffView.tag = i + 1
            diffView.addTarget(self, action: #selector(diffClick))
            difficultyViews.append(diffView)
        }
        
        stackView = UIStackView(arrangedSubviews: difficultyViews)
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(jacketImageView.snp.right).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(33)
            make.bottom.equalTo(jacketImageView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    @objc func diffClick(_ tap: UITapGestureRecognizer) {
        let selectedDifficulty = CGSSLiveDifficulty(rawValue: tap.view!.tag)!
        if live.difficultyTypes.contains(selectedDifficulty.difficultyTypes) {
            delegate?.liveView(self, didSelect: CGSSLiveScene(live: live, difficulty: selectedDifficulty))
        }
    }
    
    var live: CGSSLive!
    
    func setup(with live: CGSSLive) {
        self.live = live
        nameLabel.text = live.title
        nameLabel.textColor = live.color
        typeIcon.image = live.icon
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
        
        difficultyViews[4].alpha = (live.maxDiff.rawValue == 5) ? 1 : 0
        
        if let url = live.jacketURL {
            jacketImageView.sd_setImage(with: url)
        }
    }
    
}

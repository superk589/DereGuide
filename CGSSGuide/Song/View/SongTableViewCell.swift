//
//  SongTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKCornerRadiusView

class SongDiffView: UIView {
    var label: UILabel!
    var iv: ZKCornerRadiusView!
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
        iv = ZKCornerRadiusView.init(frame: self.bounds)
        addSubview(iv)
        label = UILabel.init(frame: CGRect(x: 5, y: 0, width: frame.size.width - 10, height: frame.size.height))
        addSubview(label)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.textAlignment = .center
        iv.zk.cornerRadius = 8
    }
    
    func addTarget(_ target: AnyObject?, action: Selector) {
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SongTableViewCellDelegate: class {
    func songTableViewCell(_ songTableViewCell: SongTableViewCell, didSelect live: CGSSLive, difficulty: CGSSLiveDifficulty)
}

class SongTableViewCell: UITableViewCell {
    
    weak var delegate: SongTableViewCellDelegate?
    var jacketImageView: UIImageView!
    var nameLabel: UILabel!
    var typeIcon: UIImageView!
    var descriptionLabel: UILabel!
    var diffViews: [SongDiffView]!
    override func awakeFromNib() {
        super.awakeFromNib()
        prepare()
    }
    
    fileprivate func prepare() {
        jacketImageView = BannerView()
        jacketImageView.frame = CGRect(x: 10, y: 10, width: 66, height: 66)
        
        typeIcon = UIImageView.init(frame: CGRect(x: 86, y: 10, width: 20, height: 20))
        nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 111, y: 10, width: CGSSGlobal.width - 121, height: 20)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        
        descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(x: 86, y: 35, width: CGSSGlobal.width - 96, height: 16)
        descriptionLabel.font = CGSSGlobal.alphabetFont
        
        let width = floor((CGSSGlobal.width - 96 - 40) / 5)
        let space: CGFloat = 10
        // let fontSize: CGFloat = 16
        let height: CGFloat = 33
        let originY: CGFloat = 43
        let originX: CGFloat = 86
        
        contentView.addSubview(jacketImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeIcon)
        // contentView.addSubview(descriptionLabel)
        
        let colors = [Color.debut, Color.regular, Color.pro, Color.master, Color.masterPlus]
        diffViews = [SongDiffView]()
        for i in 0...4 {
            let diffView = SongDiffView.init(frame: CGRect(x: originX + (space + width) * CGFloat(i), y: originY, width: width, height: height))
            diffView.iv.zk.backgroundColor = colors[i]
            diffView.iv.render()
            diffView.label.textColor = UIColor.darkGray
            diffView.tag = i + 1
            diffView.addTarget(self, action: #selector(diffClick))
            diffViews.append(diffView)
            addSubview(diffView)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func diffClick(_ tap: UITapGestureRecognizer) {
        delegate?.songTableViewCell(self, didSelect: live, difficulty: CGSSLiveDifficulty(rawValue: tap.view!.tag)!)
    }
    
    var live: CGSSLive!
    func setup(with live: CGSSLive) {
        self.live = live
        self.nameLabel.text = live.title
        let descString = "bpm:\(live.bpm)"
        self.descriptionLabel.text = descString
        self.nameLabel.textColor = live.color
        self.typeIcon.image = live.icon
        let diffStars = live.liveDetails.map { $0.stars }
        
        for i in 0...4 {
            self.diffViews[i].text = "\(diffStars[i])"
        }
        
        self.diffViews[4].isHidden = !(live.maxDiff.rawValue == 5)
        
        if let url = live.jacketURL {
            self.jacketImageView.sd_setImage(with: url)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  SongTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZYCornerRadius

class SongDiffView: UIView {
    var label: UILabel!
    var iv: UIImageView!
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
        iv = UIImageView.init(frame: self.bounds)
        addSubview(iv)
        label = UILabel.init(frame: CGRectMake(5, 0, frame.size.width - 10, frame.size.height))
        addSubview(label)
        label.font = UIFont.boldSystemFontOfSize(14)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        iv.zy_cornerRadiusAdvance(6, rectCornerType: .AllCorners)
    }
    
    func addTarget(target: AnyObject?, action: Selector) {
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SongTableViewCellDelegate: class {
    func diffSelected(live: CGSSLive, diff: Int)
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
    
    private func prepare() {
        jacketImageView = UIImageView()
        jacketImageView.frame = CGRectMake(10, 10, 66, 66)
        
        typeIcon = UIImageView.init(frame: CGRectMake(86, 10, 20, 20))
        nameLabel = UILabel()
        nameLabel.frame = CGRectMake(111, 10, CGSSGlobal.width - 121, 20)
        nameLabel.font = UIFont.boldSystemFontOfSize(18)
        nameLabel.adjustsFontSizeToFitWidth = true
        
        descriptionLabel = UILabel()
        descriptionLabel.frame = CGRectMake(86, 35, CGSSGlobal.width - 96, 16)
        descriptionLabel.font = CGSSGlobal.alphabetFont
        
        let width = floor((CGSSGlobal.width - 96 - 40) / 5)
        let space: CGFloat = 10
        // let fontSize: CGFloat = 16
        let height: CGFloat = 20
        let originY: CGFloat = 56
        let originX: CGFloat = 86
        
        contentView.addSubview(jacketImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeIcon)
        contentView.addSubview(descriptionLabel)
        
        let colors = [CGSSGlobal.debutColor, CGSSGlobal.regularColor, CGSSGlobal.proColor, CGSSGlobal.masterColor, CGSSGlobal.masterPlusColor]
        diffViews = [SongDiffView]()
        for i in 0...4 {
            let diffView = SongDiffView.init(frame: CGRectMake(originX + (space + width) * CGFloat(i), originY, width, height))
            // diffView.label.font = UIFont.init(name: "menlo", size: fontSize)
            diffView.iv.tintColor = colors[i]
            diffView.iv.image = UIImage.init(named: "icon_placeholder")?.imageWithRenderingMode(.AlwaysTemplate)
            diffView.label.textColor = UIColor.darkGrayColor()
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
    
    func diffClick(tap: UITapGestureRecognizer) {
        delegate?.diffSelected(live, diff: tap.view!.tag)
    }
    
    var live: CGSSLive!
    func initWith(live: CGSSLive) {
        self.live = live
        let dao = CGSSDAO.sharedDAO
        if let song = dao.findSongById(live.musicId!) {
            self.nameLabel.text = song.title
            // self.descriptionLabel.text = "bpm:\(song?.bpm ?? 0)  composer:\(song?.composer!)  lyricist:\(song.lyricist!)"
            let descString = "bpm:\(song.bpm!)"
            // 暂时去除时长的显示
//            if let beatmap = dao.findBeatmapById(live.id!, diffId: 1) {
//                descString += " 时长:\(Int(beatmap.totalSeconds))秒"
//            }
            self.descriptionLabel.text = descString
            self.nameLabel.textColor = live.getLiveColor()
            self.typeIcon.image = UIImage.init(named: live.getLiveIconName())
            
            let diffStars = [live.debut!, live.regular!, live.pro!, live.master!, live.masterPlus!]
            for i in 0...4 {
                self.diffViews[i].text = "\(diffStars[i])"
            }
            if live.masterPlus != 0 {
                self.diffViews[4].hidden = false
            } else {
                self.diffViews[4].hidden = true
            }
            
            let url = CGSSUpdater.URLOfDeresuteApi + "/image/jacket_\(song.id!).png"
            self.jacketImageView.sd_setImageWithURL(NSURL.init(string: url))
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

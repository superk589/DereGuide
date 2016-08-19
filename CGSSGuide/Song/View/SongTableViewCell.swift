//
//  SongTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol SongTableViewCellDelegate: class {
    func diffSelected(live: CGSSLive, diff: Int)
}

class SongTableViewCell: UITableViewCell {
    
    weak var delegate: SongTableViewCellDelegate?
    var jacketImageView: UIImageView!
    var nameLabel: UILabel!
    var typeIcon: UIImageView!
    var descriptionLabel: UILabel!
    var debutButton: UIButton!
    var regularButton: UIButton!
    var proButton: UIButton!
    var masterButton: UIButton!
    var masterPlusButton: UIButton!
    var diffLabel: UILabel!
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
        descriptionLabel.font = UIFont.init(name: "menlo", size: 14)
        
        let width = floor((CGSSGlobal.width - 96 - 40) / 5)
        let space: CGFloat = 10
        let fontSize: CGFloat = 16
        let height: CGFloat = 16
        let originY: CGFloat = 60
        let originX: CGFloat = 86
        //
        //// diffLabel = UILabel()
        //// diffLabel.frame = CGRectMake(76, 40, 150, 12)
        //// diffLabel.text = "diff"
        //
        debutButton = UIButton()
        debutButton.frame = CGRectMake(originX, originY, width, height)
        debutButton.titleLabel?.font = UIFont.init(name: "menlo", size: fontSize)
        debutButton.backgroundColor = CGSSGlobal.debutColor
        debutButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        // debutButton.layer.cornerRadius = 6
        // debutButton.layer.masksToBounds = true
        debutButton.tag = 1
        debutButton.addTarget(self, action: #selector(diffClick), forControlEvents: .TouchUpInside)
        //
        regularButton = UIButton()
        regularButton.frame = CGRectMake(originX + width + space, originY, width, height)
        regularButton.titleLabel?.font = UIFont.init(name: "menlo", size: fontSize)
        regularButton.backgroundColor = CGSSGlobal.regularColor
        regularButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        // regularButton.layer.cornerRadius = 6
        // regularButton.layer.masksToBounds = true
        // regularButton.textAlignment = .Center
        regularButton.tag = 2
        regularButton.addTarget(self, action: #selector(diffClick), forControlEvents: .TouchUpInside)
        
        proButton = UIButton()
        proButton.frame = CGRectMake(originX + 2 * (width + space), originY, width, height)
        proButton.titleLabel?.font = UIFont.init(name: "menlo", size: fontSize)
        proButton.backgroundColor = CGSSGlobal.proColor
        proButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        // proButton.layer.cornerRadius = 6
        // proButton.layer.masksToBounds = true
        // proButton.textAlignment = .Center
        proButton.tag = 3
        proButton.addTarget(self, action: #selector(diffClick), forControlEvents: .TouchUpInside)
        
        masterButton = UIButton()
        masterButton.frame = CGRectMake(originX + 3 * (width + space), originY, width, height)
        masterButton.titleLabel?.font = UIFont.init(name: "menlo", size: fontSize)
        masterButton.backgroundColor = CGSSGlobal.masterColor
        masterButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        // masterButton.layer.cornerRadius = 6
        // masterButton.layer.masksToBounds = true
        // masterButton.textAlignment = .Center
        masterButton.tag = 4
        masterButton.addTarget(self, action: #selector(diffClick), forControlEvents: .TouchUpInside)
        
        masterPlusButton = UIButton()
        masterPlusButton.frame = CGRectMake(originX + 4 * (width + space), originY, width, height)
        masterPlusButton.titleLabel?.font = UIFont.init(name: "menlo", size: fontSize)
        masterPlusButton.backgroundColor = CGSSGlobal.masterPlusColor
        masterPlusButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        // masterPlusButton.tintColor = CGSSGlobal.masterPlusColor
        // masterPlusButton.layer.cornerRadius = 6
        // masterPlusButton.layer.masksToBounds = true
        // masterPlusButton.textAlignment = .Center
        masterPlusButton.tag = 5
        masterPlusButton.addTarget(self, action: #selector(diffClick), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(jacketImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeIcon)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(debutButton)
        contentView.addSubview(regularButton)
        contentView.addSubview(proButton)
        contentView.addSubview(masterButton)
        contentView.addSubview(masterPlusButton)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func diffClick(button: UIButton) {
        delegate?.diffSelected(live, diff: button.tag)
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
            
            self.debutButton.setTitle(String(live.debut!), forState: .Normal)
            // self.debutButton.ad
            self.regularButton.setTitle(String(live.regular!), forState: .Normal)
            self.proButton.setTitle(String(live.pro!), forState: .Normal)
            self.masterButton.setTitle(String(live.master!), forState: .Normal)
            self.nameLabel.textColor = live.getLiveColor()
            self.typeIcon.image = UIImage.init(named: live.getLiveIconName())
            if live.masterPlus != 0 {
                masterPlusButton.hidden = false
                masterPlusButton.setTitle(String(live.masterPlus!), forState: .Normal)
            } else {
                masterPlusButton.hidden = true
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

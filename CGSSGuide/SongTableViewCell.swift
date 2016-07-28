//
//  SongTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    var jacketImageView: UIImageView!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    var debutLabel: UILabel!
    var regularLabel: UILabel!
    var proLabel: UILabel!
    var masterLabel: UILabel!
    var masterPlusLabel: UILabel!
    var diffLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        jacketImageView = UIImageView()
        jacketImageView.frame = CGRectMake(5, 5, 66, 66)
        
        nameLabel = UILabel()
        nameLabel.frame = CGRectMake(76, 5, CGSSTool.width - 86, 20)
        nameLabel.font = UIFont.boldSystemFontOfSize(18)
        
        descriptionLabel = UILabel()
        descriptionLabel.frame = CGRectMake(76, 30, CGSSTool.width - 86, 16)
        descriptionLabel.font = UIFont.init(name: "menlo", size: 14)

        let width = floor((CGSSTool.width - 86 - 40) / 5)
        let space:CGFloat = 10
        let fontSize:CGFloat = 16
        let height:CGFloat = 16
        let originY:CGFloat = 52
//
////        diffLabel = UILabel()
////        diffLabel.frame = CGRectMake(76, 40, 150, 12)
////        diffLabel.text = "diff"
//        
        debutLabel = UILabel()
        debutLabel.frame = CGRectMake(76, originY, width, height )
        debutLabel.font = UIFont.init(name: "menlo", size: fontSize)
        debutLabel.backgroundColor = CGSSTool.debutColor
        //debutLabel.layer.cornerRadius = 6
        //debutLabel.layer.masksToBounds = true
        debutLabel.textAlignment = .Center
//
        regularLabel = UILabel()
        regularLabel.frame = CGRectMake(76 + width + space, originY, width, height )
        regularLabel.font = UIFont.init(name: "menlo", size: fontSize)
        regularLabel.backgroundColor = CGSSTool.regularColor
        //regularLabel.layer.cornerRadius = 6
        //regularLabel.layer.masksToBounds = true
        regularLabel.textAlignment = .Center
        
        proLabel = UILabel()
        proLabel.frame = CGRectMake(76 + 2 * (width + space), originY, width, height )
        proLabel.font = UIFont.init(name: "menlo", size: fontSize)
        proLabel.backgroundColor = CGSSTool.proColor
//        proLabel.layer.cornerRadius = 6
//        proLabel.layer.masksToBounds = true
        proLabel.textAlignment = .Center
        
        masterLabel = UILabel()
        masterLabel.frame = CGRectMake(76 + 3 * (width + space), originY, width, height )
        masterLabel.font = UIFont.init(name: "menlo", size: fontSize)
        masterLabel.backgroundColor = CGSSTool.masterColor
        //masterLabel.layer.cornerRadius = 6
        //masterLabel.layer.masksToBounds = true
        masterLabel.textAlignment = .Center
        
        masterPlusLabel = UILabel()
        masterPlusLabel.frame = CGRectMake(76 + 4 * (width + space), 50, width, height )
        masterPlusLabel.font = UIFont.init(name: "menlo", size: fontSize)
        masterPlusLabel.backgroundColor = CGSSTool.masterPlusColor
        masterPlusLabel.tintColor = CGSSTool.masterPlusColor
        //masterPlusLabel.layer.cornerRadius = 6
        //masterPlusLabel.layer.masksToBounds = true
        masterPlusLabel.textAlignment = .Center
        
        contentView.addSubview(jacketImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(debutLabel)
        contentView.addSubview(regularLabel)
        contentView.addSubview(proLabel)
        contentView.addSubview(masterLabel)
        contentView.addSubview(masterPlusLabel)
    }
    
    func initWith(live:CGSSLive) {
        let dao = CGSSDAO.sharedDAO
        if let song = dao.findSongById(live.musicId!) {
            self.nameLabel.text = song.title
            //self.descriptionLabel.text = "bpm:\(song?.bpm ?? 0)  composer:\(song?.composer!)  lyricist:\(song.lyricist!)"
            self.descriptionLabel.text = "bpm:\(song.bpm!)"

            self.debutLabel.text = String(live.debut!)
            self.regularLabel.text = String(live.regular!)
            self.proLabel.text = String(live.pro!)
            self.masterLabel.text = String(live.master!)
            switch live.type! {
            case 1:
                self.nameLabel.textColor = CGSSTool.cuteColor
            case 2:
                self.nameLabel.textColor = CGSSTool.coolColor
            case 3:
                self.nameLabel.textColor = CGSSTool.passionColor
            case 4:
                self.nameLabel.textColor = UIColor.darkTextColor()
            default:
                break
            }
            if live.masterPlus != 0 {
                masterPlusLabel.hidden = false
                masterPlusLabel.text = String(live.masterPlus!)
            } else {
                masterPlusLabel.hidden = true
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

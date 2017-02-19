//
//  TeamTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    
    var icons: [CGSSCardIconView]!
    var skillLvLabels: [UILabel]!
    var leftSpace: CGFloat = 10
    var rightSpace: CGFloat = 48
    var space: CGFloat = 5
    static let btnW: CGFloat = (CGSSGlobal.width - 10 - 48 + 5) / 6 - 5
    var rawValueLabels: [UILabel]!
    
    var lifeLabel: UILabel!
    var vocalLabel: UILabel!
    var danceLabel: UILabel!
    var visualLabel: UILabel!
    var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icons = [CGSSCardIconView]()
        skillLvLabels = [UILabel]()
        let btnW = TeamTableViewCell.btnW
        for index in 0...5 {
            let icon = CGSSCardIconView.init(frame: CGRect(x: leftSpace + (btnW + space) * CGFloat(index), y: 10, width: btnW, height: btnW))
            icon.isUserInteractionEnabled = false
            let label = UILabel.init(frame: CGRect(x: icon.frame.origin.x, y: icon.frame.origin.y + icon.frame.size.height, width: icon.frame.size.width, height: 21))
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.darkGray
            contentView.addSubview(label)
            skillLvLabels.append(label)
            
            contentView.addSubview(icon)
            icons.append(icon)
        }
        let originY = 10 + btnW + 23
        
        let width = (CGSSGlobal.width - leftSpace - rightSpace - 2) / 5
        let fontSize: CGFloat = 12
        let height: CGFloat = 12
        let originX: CGFloat = 10
        
        lifeLabel = UILabel()
        lifeLabel.frame = CGRect(x: originX, y: originY, width: width, height: height)
        lifeLabel.font = UIFont.init(name: "menlo", size: fontSize)
        lifeLabel.textColor = Color.life
        lifeLabel.textAlignment = .right
        
        vocalLabel = UILabel()
        vocalLabel.frame = CGRect(x: originX + width, y: originY, width: width, height: height)
        vocalLabel.font = UIFont.init(name: "menlo", size: fontSize)
        vocalLabel.textColor = Color.vocal
        vocalLabel.textAlignment = .right
        
        danceLabel = UILabel()
        danceLabel.frame = CGRect(x: originX + 2 * width, y: originY, width: width, height: height)
        danceLabel.font = UIFont.init(name: "menlo", size: fontSize)
        danceLabel.textColor = Color.dance
        danceLabel.textAlignment = .right
        
        visualLabel = UILabel()
        visualLabel.frame = CGRect(x: originX + 3 * width, y: originY, width: width, height: height)
        visualLabel.font = UIFont.init(name: "menlo", size: fontSize)
        visualLabel.textColor = Color.visual
        visualLabel.textAlignment = .right
        
        totalLabel = UILabel()
        totalLabel.frame = CGRect(x: originX + 4 * width, y: originY, width: width, height: height)
        totalLabel.font = UIFont.init(name: "menlo", size: fontSize)
        totalLabel.textColor = UIColor.darkGray
        totalLabel.textAlignment = .right
        
        contentView.addSubview(vocalLabel)
        contentView.addSubview(lifeLabel)
        contentView.addSubview(danceLabel)
        contentView.addSubview(visualLabel)
        contentView.addSubview(totalLabel)
        
        let asView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        asView.image = UIImage.init(named: "766-arrow-right-toolbar-selected")!.withRenderingMode(.alwaysTemplate)
        asView.tintColor = UIColor.lightGray
        
        self.accessoryView = asView
        
        // Initialization code
    }
    
    func initWith(_ team: CGSSTeam) {
        for i in 0...5 {
            let tm = team[i]
            if let card = tm?.cardRef {
                icons[i].setWithCardId(card.id!)
                if i != 5 {
                    if card.skill != nil {
                        skillLvLabels[i].text = "SLv.\((tm?.skillLevel)!)"
                    } else {
                        skillLvLabels[i].text = "n/a"
                    }
                } else {
                    skillLvLabels[i].text = "n/a"
                }
            }
        }
        vocalLabel.text = String(team.rawVocal)
        visualLabel.text = String(team.rawVisual)
        danceLabel.text = String(team.rawDance)
        totalLabel.text = String(team.rawAppeal.total)
        lifeLabel.text = String(team.rawHP)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

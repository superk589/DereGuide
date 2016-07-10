//
//  CardTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    var cardIconView:CGSSCardIconView!
    var cardNameLabel:UILabel!
    var rarityLabel:UILabel!
    var skillLabel:UILabel!
    var lifeLabel:UILabel!
    var vocalLabel:UILabel!
    var danceLabel:UILabel!
    var visualLabel:UILabel!
    var totalLabel:UILabel!
    var titleLabel:UILabel!
    var nameOnlyLabel:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        cardIconView = CGSSCardIconView(frame: CGRectMake(5, 5, 48, 48))
                
        rarityLabel = UILabel()
        rarityLabel.frame = CGRectMake(58, 5, 30, 10)
        rarityLabel.textAlignment = .Left
        rarityLabel.font = UIFont.systemFontOfSize(10)
        
        skillLabel = UILabel()
        skillLabel.frame = CGRectMake(CGSSTool.width - 150, 5, 140, 10)
        skillLabel.font = UIFont.systemFontOfSize(10)
        skillLabel.textAlignment = .Right
        
        cardNameLabel = UILabel()
        cardNameLabel.frame = CGRectMake(58, 20, CGSSTool.width - 68, 16)
        cardNameLabel.font = UIFont.systemFontOfSize(16)
        
        
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(88, 5, CGSSTool.width - 150, 10)
        titleLabel.font = UIFont.systemFontOfSize(10)
        
        
        
        
        let width = (CGSSTool.width - 68 ) / 5
        let fontSize:CGFloat = 12
        let height:CGFloat = 12
        
        lifeLabel = UILabel()
        lifeLabel.frame = CGRectMake(58, 41, width, height )
        lifeLabel.font = UIFont.init(name: "menlo", size: fontSize)
        lifeLabel.textColor = CGSSTool.lifeColor
        lifeLabel.textAlignment = .Right
 
        vocalLabel = UILabel()
        vocalLabel.frame = CGRectMake(58 + width, 41, width, height )
        vocalLabel.font = UIFont.init(name: "menlo", size: fontSize)
        vocalLabel.textColor = CGSSTool.vocalColor
        vocalLabel.textAlignment = .Right
        
        danceLabel = UILabel()
        danceLabel.frame = CGRectMake(58 + 2 * width, 41, width, height )
        danceLabel.font = UIFont.init(name: "menlo", size: fontSize)
        danceLabel.textColor = CGSSTool.danceColor
        danceLabel.textAlignment = .Right
        
        visualLabel = UILabel()
        visualLabel.frame = CGRectMake(58 + 3 * width, 41, width, height )
        visualLabel.font = UIFont.init(name: "menlo", size: fontSize)
        visualLabel.textColor = CGSSTool.visualColor
        visualLabel.textAlignment = .Right
        
        totalLabel = UILabel()
        totalLabel.frame = CGRectMake(58 + 4 * width, 41, width, height )
        totalLabel.font = UIFont.init(name: "menlo", size: fontSize)
        totalLabel.textColor = UIColor.darkTextColor().colorWithAlphaComponent(0.5)
        totalLabel.textAlignment = .Right
        
        contentView.addSubview(cardNameLabel)
        contentView.addSubview(cardIconView)
        contentView.addSubview(skillLabel)
        contentView.addSubview(rarityLabel)
        contentView.addSubview(vocalLabel)
        contentView.addSubview(lifeLabel)
        contentView.addSubview(danceLabel)
        contentView.addSubview(visualLabel)
        contentView.addSubview(totalLabel)
        contentView.addSubview(titleLabel)
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

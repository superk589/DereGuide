//
//  CardTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    var cardIconView: CGSSCardIconView!
    var cardNameLabel: UILabel!
    var rarityLabel: UILabel!
    var skillLabel: UILabel!
    var lifeLabel: UILabel!
    var vocalLabel: UILabel!
    var danceLabel: UILabel!
    var visualLabel: UILabel!
    var totalLabel: UILabel!
    var titleLabel: UILabel!
    var nameOnlyLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func prepare() {
        
        cardIconView = CGSSCardIconView(frame: CGRectMake(10, 10, 48, 48))
        
        rarityLabel = UILabel()
        rarityLabel.frame = CGRectMake(68, 10, 30, 10)
        rarityLabel.textAlignment = .Left
        rarityLabel.font = UIFont.systemFontOfSize(10)
        
        skillLabel = UILabel()
        skillLabel.frame = CGRectMake(CGSSGlobal.width - 150, 10, 140, 10)
        skillLabel.font = UIFont.systemFontOfSize(10)
        skillLabel.textAlignment = .Right
        
        cardNameLabel = UILabel()
        cardNameLabel.frame = CGRectMake(68, 25, CGSSGlobal.width - 78, 16)
        cardNameLabel.font = UIFont.systemFontOfSize(16)
        cardNameLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(98, 10, CGSSGlobal.width - 150, 10)
        titleLabel.font = UIFont.systemFontOfSize(10)
        
        let width = (CGSSGlobal.width - 78) / 5
        let fontSize: CGFloat = 12
        let height: CGFloat = 12
        let originX: CGFloat = 68
        let originY: CGFloat = 46
        
        lifeLabel = UILabel()
        lifeLabel.frame = CGRectMake(originX, originY, width, height)
        lifeLabel.font = UIFont.init(name: "menlo", size: fontSize)
        lifeLabel.textColor = CGSSGlobal.lifeColor
        lifeLabel.textAlignment = .Right
        
        vocalLabel = UILabel()
        vocalLabel.frame = CGRectMake(originX + width, originY, width, height)
        vocalLabel.font = UIFont.init(name: "menlo", size: fontSize)
        vocalLabel.textColor = CGSSGlobal.vocalColor
        vocalLabel.textAlignment = .Right
        
        danceLabel = UILabel()
        danceLabel.frame = CGRectMake(originX + 2 * width, originY, width, height)
        danceLabel.font = UIFont.init(name: "menlo", size: fontSize)
        danceLabel.textColor = CGSSGlobal.danceColor
        danceLabel.textAlignment = .Right
        
        visualLabel = UILabel()
        visualLabel.frame = CGRectMake(originX + 3 * width, originY, width, height)
        visualLabel.font = UIFont.init(name: "menlo", size: fontSize)
        visualLabel.textColor = CGSSGlobal.visualColor
        visualLabel.textAlignment = .Right
        
        totalLabel = UILabel()
        totalLabel.frame = CGRectMake(originX + 4 * width, originY, width, height)
        totalLabel.font = UIFont.init(name: "menlo", size: fontSize)
        totalLabel.textColor = UIColor.darkGrayColor()
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepare()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

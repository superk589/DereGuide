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
    
    fileprivate func prepare() {
        
        cardIconView = CGSSCardIconView(frame: CGRect(x: 10, y: 10, width: 48, height: 48))
        
        rarityLabel = UILabel()
        rarityLabel.frame = CGRect(x: 68, y: 10, width: 30, height: 10)
        rarityLabel.textAlignment = .left
        rarityLabel.font = UIFont.systemFont(ofSize: 10)
        
        skillLabel = UILabel()
        skillLabel.frame = CGRect(x: CGSSGlobal.width - 150, y: 10, width: 140, height: 10)
        skillLabel.font = UIFont.systemFont(ofSize: 10)
        skillLabel.textAlignment = .right
        
        cardNameLabel = UILabel()
        cardNameLabel.frame = CGRect(x: 68, y: 25, width: CGSSGlobal.width - 78, height: 16)
        cardNameLabel.font = UIFont.systemFont(ofSize: 16)
        cardNameLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 98, y: 10, width: CGSSGlobal.width - 150, height: 10)
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        
        let width = (CGSSGlobal.width - 78) / 5
        let fontSize: CGFloat = 12
        let height: CGFloat = 12
        let originX: CGFloat = 68
        let originY: CGFloat = 46
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

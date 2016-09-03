//
//  CharDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

private let topSpace: CGFloat = 10
private let leftSpace: CGFloat = 10
private let bottomInset: CGFloat = 30

protocol CharDetailViewDelegate: class {
    func cardIconClick(icon: CGSSCardIconView)
    
}

class CharDetailView: UIView {
    weak var delegate: CharDetailViewDelegate?
    
    var charIconView: CGSSCharIconView!
    var charNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    var basicView: UIView!
    var detailView: UIView!
    var relatedView: UIView!
    
    var profileView: CharProfileView!
    
    private func prepare() {
        basicView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 68))
        charIconView = CGSSCharIconView(frame: CGRectMake(10, 10, 48, 48))
        
        charNameLabel = UILabel()
        charNameLabel.frame = CGRectMake(68, 26, CGSSGlobal.width - 78, 16)
        charNameLabel.font = UIFont.systemFontOfSize(16)
        charNameLabel.adjustsFontSizeToFitWidth = true
        
        basicView.addSubview(charNameLabel)
        basicView.addSubview(charIconView)
        addSubview(basicView)
        
        profileView = CharProfileView.init(frame: CGRectMake(10, 78, CGSSGlobal.width - 20, 0))
        addSubview(profileView)
    }
    
    func setup(char: CGSSChar) {
        charNameLabel.text = "\(char.kanjiSpaced)  \(char.conventional)"
        charIconView.setWithCharId(char.charaId)
        profileView.setup(char)
        var cards = CGSSDAO.sharedDAO.findCardsByCharId(char.charaId)
        let sorter = CGSSSorter.init(att: "sAlbumId")
        sorter.sortList(&cards)
        if cards.count > 0 {
            prepareRelatedCardsContentView()
            setupRelatedCardsContentView(cards)
        }
        relatedCardsContentView.fy = profileView.fy + profileView.fheight + topSpace
        
        fheight = relatedCardsContentView.fheight + relatedCardsContentView.fy
    }
    
    // 相关卡片
    var relatedCardsContentView: UIView!
    func prepareRelatedCardsContentView() {
        if relatedCardsContentView != nil {
            return
        }
        relatedCardsContentView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 0))
        relatedCardsContentView.clipsToBounds = true
        relatedCardsContentView.drawSectionLine(0)
        // evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 92 + (1 / UIScreen.mainScreen().scale))
        let insideY: CGFloat = topSpace
        let descLabel = UILabel()
        descLabel.frame = CGRectMake(10, insideY, 140, 14)
        descLabel.textColor = UIColor.blackColor()
        descLabel.font = UIFont.systemFontOfSize(14)
        descLabel.text = "角色所有卡片:"
        descLabel.textColor = UIColor.blackColor()
        relatedCardsContentView.addSubview(descLabel)
        addSubview(relatedCardsContentView)
        
    }
    
    // 设置相关卡片
    func setupRelatedCardsContentView(cards: [CGSSCard]) {
        let column = floor((CGSSGlobal.width - 2 * topSpace) / 50)
        let space = (CGSSGlobal.width - 2 * topSpace - column * 48)
            / (column - 1)
        
        for i in 0..<cards.count {
            let y = CGFloat(i / Int(column)) * (48 + space) + 34
            let x = CGFloat(i % Int(column)) * (48 + space) + topSpace
            let icon = CGSSCardIconView.init(frame: CGRectMake(x, y, 48, 48))
            icon.setWithCardId(cards[i].id, target: self, action: #selector(iconClick))
            relatedCardsContentView.addSubview(icon)
        }
        relatedCardsContentView.fheight = CGFloat((cards.count - 1) / Int(column)) * (48 + space) + 48 + 34 + topSpace
        
    }
    
    func iconClick(icon: CGSSCardIconView) {
        delegate?.cardIconClick(icon)
    }
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}

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
private let bottomInset: CGFloat = 50

protocol CharDetailViewDelegate: class {
    func cardIconClick(_ icon: CGSSCardIconView)
    
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
    
    fileprivate func prepare() {
        basicView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 68))
        charIconView = CGSSCharIconView(frame: CGRect(x: 10, y: 10, width: 48, height: 48))
        
        charNameLabel = UILabel()
        charNameLabel.frame = CGRect(x: 68, y: 26, width: CGSSGlobal.width - 78, height: 16)
        charNameLabel.font = UIFont.systemFont(ofSize: 16)
        charNameLabel.adjustsFontSizeToFitWidth = true
        
        basicView.addSubview(charNameLabel)
        basicView.addSubview(charIconView)
        addSubview(basicView)
        
        profileView = CharProfileView.init(frame: CGRect(x: 10, y: 78, width: CGSSGlobal.width - 20, height: 0))
        addSubview(profileView)
    }
    
    func setup(_ char: CGSSChar) {
        charNameLabel.text = "\(char.kanjiSpaced!)  \(char.conventional!)"
        charIconView.charId = char.charaId
        profileView.setup(char)
        var cards = CGSSDAO.sharedDAO.findCardsByCharId(char.charaId)
        let sorter = CGSSSorter.init(property: "sAlbumId")
        sorter.sortList(&cards)
        if cards.count > 0 {
            prepareRelatedCardsContentView()
            setupRelatedCardsContentView(cards)
        }
        relatedCardsContentView.fy = profileView.fy + profileView.fheight + topSpace
        
        fheight = relatedCardsContentView.fheight + relatedCardsContentView.fy + bottomInset
    }
    
    // 相关卡片
    var relatedCardsContentView: UIView!
    func prepareRelatedCardsContentView() {
        if relatedCardsContentView != nil {
            return
        }
        relatedCardsContentView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        relatedCardsContentView.clipsToBounds = true
        relatedCardsContentView.drawSectionLine(0)
        // evolutionContentView.frame = CGRectMake(-1, originY - (1 / UIScreen.mainScreen().scale), CGSSGlobal.width+2, 92 + (1 / UIScreen.mainScreen().scale))
        let insideY: CGFloat = topSpace
        let descLabel = UILabel()
        descLabel.frame = CGRect(x: 10, y: insideY, width: 170, height: 17)
        descLabel.textColor = UIColor.black
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.text = NSLocalizedString("角色所有卡片", comment: "角色信息页面") + ":"
        descLabel.textColor = UIColor.black
        relatedCardsContentView.addSubview(descLabel)
        addSubview(relatedCardsContentView)
        
    }
    
    // 设置相关卡片
    func setupRelatedCardsContentView(_ cards: [CGSSCard]) {
        let column = floor((CGSSGlobal.width - 2 * topSpace) / 50)
        let spaceTotal = CGSSGlobal.width - 2 * topSpace - column * 48
        let space = spaceTotal / (column - 1)
        
        for i in 0..<cards.count {
            let y = CGFloat(i / Int(column)) * (48 + space) + 37
            let x = CGFloat(i % Int(column)) * (48 + space) + topSpace
            let icon = CGSSCardIconView.init(frame: CGRect(x: x, y: y, width: 48, height: 48))
            icon.setWithCardId(cards[i].id, target: self, action: #selector(iconClick))
            relatedCardsContentView.addSubview(icon)
        }
        relatedCardsContentView.fheight = CGFloat((cards.count - 1) / Int(column)) * (48 + space) + 48 + 37 + topSpace
        
    }
    
    func iconClick(_ icon: CGSSCardIconView) {
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

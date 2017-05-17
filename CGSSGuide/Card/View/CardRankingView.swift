//
//  CardRankingView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardRankingView: UIView {

    var titleLabel: UILabel!
    
    var rangkingGridLabel: GridLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let line = LineView()
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }

        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = NSLocalizedString("属性排名", comment: "卡片详情页") + ":"
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        rangkingGridLabel = GridLabel.init(rows: 3, columns: 5)
        rangkingGridLabel.frame = CGRect(x: 10, y: 0, width: CGSSGlobal.width - 20, height: 54)
        addSubview(rangkingGridLabel)
        rangkingGridLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(54)
            make.bottom.equalTo(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with card: CGSSCard) {
        // 设置属性排名列表
        let dao = CGSSDAO.shared
        var rankGridStrings = [[String]]()
        let rankInType = dao.getRankInType(card)
        let rankInAll = dao.getRankInAll(card)
        rankGridStrings.append(["  ", "Vocal", "Dance", "Visual", "Total"])
        rankGridStrings.append(["In \(card.attShort)", "#\(rankInType[0])", "#\(rankInType[1])", "#\(rankInType[2])", "#\(rankInType[3])"])
        rankGridStrings.append(["In All", "#\(rankInAll[0])", "#\(rankInAll[1])", "#\(rankInAll[2])", "#\(rankInAll[3])"])
        rangkingGridLabel.setContents(rankGridStrings)
        
        var colors2 = [[UIColor]]()
        let colorArray2 = [card.attColor, Color.vocal, Color.dance, Color.visual, Color.allType]
        let colorArray3 = [Color.allType, Color.vocal, Color.dance, Color.visual, Color.allType]
        
        colors2.append(colorArray3)
        colors2.append(colorArray2)
        colors2.append(colorArray3)
        rangkingGridLabel.setColors(colors2)
        
        var fonts2 = [[UIFont]]()
        let fontArray3 = [UIFont].init(repeating: CGSSGlobal.alphabetFont, count: 5)
        var fontArray4 = [UIFont].init(repeating: CGSSGlobal.numberFont!, count: 5)
        fontArray4[0] = CGSSGlobal.alphabetFont
        fonts2.append(fontArray3)
        fonts2.append(fontArray4)
        fonts2.append(fontArray4)
        rangkingGridLabel.setFonts(fonts2)
    }
}

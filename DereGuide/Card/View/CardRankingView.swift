//
//  CardRankingView.swift
//  DereGuide
//
//  Created by zzk on 2017/3/7.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardRankingView: UIView {

    let titleLabel = UILabel()
    
    let rangkingGridLabel = GridLabel(rows: 3, columns: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.text = NSLocalizedString("属性排名", comment: "卡片详情页")
        titleLabel.textColor = .black
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
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
        let colorArray2 = [card.attColor, .vocal, .dance, .visual, .allType]
        let colorArray3 = [UIColor.allType, .vocal, .dance, .visual, .allType]
        
        colors2.append(colorArray3)
        colors2.append(colorArray2)
        colors2.append(colorArray3)
        rangkingGridLabel.setColors(colors2)
        
        var fonts2 = [[UIFont]]()
        let fontArray3 = [UIFont](repeating: CGSSGlobal.alphabetFont, count: 5)
        var fontArray4 = [UIFont](repeating: CGSSGlobal.numberFont!, count: 5)
        fontArray4[0] = CGSSGlobal.alphabetFont
        fonts2.append(fontArray3)
        fonts2.append(fontArray4)
        fonts2.append(fontArray4)
        rangkingGridLabel.setFonts(fonts2)
    }
}

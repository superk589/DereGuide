//
//  UnitInformationSkillListCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/20.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitInformationSkillListCell: UITableViewCell {
    
    let leftLabel = UILabel()
    
    let skillListGrid = GridLabel(rows: 5, columns: 1, textAligment: .left)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.text = NSLocalizedString("特技列表", comment: "队伍详情页面")
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.textAlignment = .left
        
        skillListGrid.distribution = .fill
        skillListGrid.numberOfLines = 0
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(skillListGrid)
        
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
        }
        skillListGrid.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        
        selectionStyle = .none
    }
    
    func setup(with unit: Unit) {
        var skillListStrings = [[String]]()
        let skillListColor = [[UIColor]](repeating: [.darkGray], count: 5)
        for i in 0...4 {
            if let skill = unit[i].card?.skill {
                let str = "\(skill.skillName!): Lv.\(unit[i].skillLevel)\n\(skill.getLocalizedExplainByLevel(Int(unit[i].skillLevel)))"
                let arr = [str]
                skillListStrings.append(arr)
            } else {
                skillListStrings.append([""])
            }
        }
        
        skillListGrid.setContents(skillListStrings)
        skillListGrid.setColors(skillListColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

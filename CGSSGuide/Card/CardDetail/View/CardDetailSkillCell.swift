//
//  CardDetailSkillCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class CardDetailSkillCell: UITableViewCell {
    
    var leftLabel: UILabel!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    var gridLabel: GridLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel = UILabel()
        leftLabel.textColor = UIColor.black
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("特技", comment: "通用")
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(10)
            make.top.equalTo(leftLabel)
            make.right.lessThanOrEqualTo(-10)
        }
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byCharWrapping
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.darkGray
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.lessThanOrEqualTo(-10)
        }
        
        gridLabel = GridLabel.init(rows: 4, columns: 5)
        contentView.addSubview(gridLabel)
        gridLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension CardDetailSkillCell: CardDetailSetable {
    func setup(with card: CGSSCard) {
        guard let skill = card.skill else {
            return
        }
        nameLabel.text = skill.skillName
        descriptionLabel.text = skill.getExplainByLevelRange(1, end: 10, languageType: CGSSGlobal.languageType)
        
        var procGridStrings = [[String]]()
        let procChanceMax = skill.procChanceOfLevel(10)
        let procChanceMin = skill.procChanceOfLevel(1)
        let durationMax = skill.effectLengthOfLevel(10)
        let durationMin = skill.effectLengthOfLevel(1)
        
        procGridStrings.append(["  ",
                                NSLocalizedString("触发几率%", comment: "卡片详情页"),
                                NSLocalizedString("持续时间s", comment: "卡片详情页"),
                                NSLocalizedString("最大覆盖率%", comment: "卡片详情页"),
                                NSLocalizedString("平均覆盖率%", comment: "卡片详情页")])
        procGridStrings.append(["Lv.1",
                                String(format: "%.2f", procChanceMin / 100),
                                String(format: "%.2f", durationMin / 100),
                                String(format: "%.2f", durationMin / Double(skill.condition!)),
                                String(format: "%.2f", durationMin / Double(skill.condition!) * procChanceMin / 10000)])
        procGridStrings.append(["Lv.10",
                                String(format: "%.2f", procChanceMax / 100),
                                String(format: "%.2f", durationMax / 100),
                                String(format: "%.2f", durationMax / Double(skill.condition!)),
                                String(format: "%.2f", durationMax / Double(skill.condition!) * procChanceMax / 10000)])
        procGridStrings.append(["Lv.10(+30%)",
                                String(format: "%.3f", procChanceMax * 1.3 / 100),
                                String(format: "%.2f", durationMax / 100),
                                String(format: "%.2f", durationMax / Double(skill.condition!)),
                                String(format: "%.2f", durationMax / Double(skill.condition!) * procChanceMax * 1.3 / 10000)])
        
        gridLabel.setContents(procGridStrings)
    }
}

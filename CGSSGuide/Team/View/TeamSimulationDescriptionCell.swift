//
//  TeamSimulationDescriptionCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class TeamSimulationDescriptionCell: UITableViewCell {

    var leftLabel: UILabel!
    
    var descriptionLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel = UILabel()
        contentView.addSubview(leftLabel)
        leftLabel.text = NSLocalizedString("得分说明", comment: "") + ": "
        leftLabel.font = UIFont.systemFont(ofSize: 16)

        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = NSLocalizedString("* 全部note为Perfect评价，小屋加成为10%\n* 极限分数中所有技能100%触发\n* 极限分数1中note取Perfect判定±0.06秒中的最优值，极限分数2和其他分数都不考虑此项因素\n* 模拟计算结果是10000次模拟后取前x%内的最低分数得出，每次结果会略有不同\n* 选取Groove模式或LIVE Parade模式时会自动忽略好友队长的影响\n* 一般计算中不考虑当生命值不足时，过载技能无法发动的因素；模拟计算中考虑此因素", comment: "队伍详情页面")

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel)
            make.top.equalTo(leftLabel.snp.bottom)
            make.right.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

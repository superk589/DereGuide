//
//  UnitSimulationDescriptionCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitSimulationDescriptionCell: UITableViewCell {
    
    var descriptionLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        leftLabel = UILabel()
//        contentView.addSubview(leftLabel)
//        leftLabel.text = NSLocalizedString("得分说明", comment: "") + ": "
//        leftLabel.font = UIFont.systemFont(ofSize: 16)

//        leftLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.top.equalTo(10)
//        }
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = NSLocalizedString("* 极限分数中所有技能100%触发\n* 极限分数1中note取PERFECT判定区间中的最优值\n* 模拟计算结果是取模拟次数前x%内的最低分数，每次会略有不同\n* 选取Groove模式或LIVE Parade模式时会自动忽略好友队长的影响", comment: "队伍详情页面")

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

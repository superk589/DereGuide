//
//  UnitSimulationDescriptionCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitSimulationDescriptionCell: UITableViewCell {
    
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = NSLocalizedString("* 极限分数中所有技能100%触发\n* 极限分数1中note取PERFECT判定区间中的最优值\n* 模拟计算结果是取模拟次数前x%内的最低分数，每次会略有不同\n* 选取Groove模式或LIVE Parade模式时会自动忽略好友队长的影响\n* 存在一些暂时不支持计算平均分数的技能，平均分数将会显示为n/a", comment: "队伍详情页面")

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

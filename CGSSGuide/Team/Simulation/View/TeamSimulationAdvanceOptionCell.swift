//
//  TeamSimulationAdvanceOptionCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/25.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol TeamSimulationAdvanceOptionCellDelegate: class {
    func teamSimulationAdvanceOptionCell(_ teamSimulationAdvanceOptionCell: TeamSimulationAdvanceOptionCell, didSetOverloadSkillLifeLimitation allowed: Bool)
}

class TeamSimulationAdvanceOptionCell: UITableViewCell {

    var leftLabel: UILabel!
    
    var option1Label: UILabel!
    
    var option1Switch: UISwitch!
    
    weak var delegate: TeamSimulationAdvanceOptionCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftLabel = UILabel()
        contentView.addSubview(leftLabel)
        leftLabel.text = NSLocalizedString("高级选项", comment: "")
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.adjustsFontSizeToFitWidth = true

        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.lessThanOrEqualTo(-10)
        }
        
        option1Switch = UISwitch()
        contentView.addSubview(option1Switch)
        option1Switch.isOn = false
        option1Switch.addTarget(self, action: #selector(switch1Changed(sender:)), for: .valueChanged)
        option1Switch.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        
        option1Label = UILabel()
        option1Label.text = NSLocalizedString("模拟计算中生命不足时不发动过载技能", comment: "")
        contentView.addSubview(option1Label)
        option1Label.numberOfLines = 2
        option1Label.adjustsFontSizeToFitWidth = true
        option1Label.textColor = UIColor.darkGray
        option1Label.font = UIFont.systemFont(ofSize: 14)
        option1Label.snp.makeConstraints { (make) in
            make.centerY.equalTo(option1Switch)
            make.left.equalTo(leftLabel)
            make.right.lessThanOrEqualTo(option1Switch.snp.left)
        }
        
        option1Switch.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        option1Label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        selectionStyle = .none
    }
    
    func switch1Changed(sender: UISwitch) {
        delegate?.teamSimulationAdvanceOptionCell(self, didSetOverloadSkillLifeLimitation: sender.isOn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

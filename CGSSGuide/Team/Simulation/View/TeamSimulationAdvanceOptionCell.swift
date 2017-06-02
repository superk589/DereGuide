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
    
    func teamSimulationAdvanceOptionCell(_ teamSimulationAdvanceOptionCell: TeamSimulationAdvanceOptionCell, didSetRoomValue value: Int)
    
    func teamSimulationAdvanceOptionCell(_ teamSimulationAdvanceOptionCell: TeamSimulationAdvanceOptionCell, didSetGreatPercent value: Double)
    
    func teamSimulationAdvanceOptionCell(_ teamSimulationAdvanceOptionCell: TeamSimulationAdvanceOptionCell, didSetSimulationTimes times: Int)
        
}

class TeamSimulationAdvanceOptionCell: UITableViewCell {

    var leftLabel: UILabel!
    
    var option1: TeamSimulationSwitchOption!
    
    var option2: TeamSimulationTextFieldOption!
    
    var option3: TeamSimulationTextFieldOption!
    
    var option4: TeamSimulationTextFieldOption!
    
    var resetButton: UIButton!

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
        
        option1 = TeamSimulationSwitchOption()
        contentView.addSubview(option1)
        option1.switch.isOn = false
        option1.addTarget(self, action: #selector(option1SwitchChanged(_:)), for: .valueChanged)
        
        let option1Label = option1.label
        option1Label.text = NSLocalizedString("模拟计算中生命不足时不发动过载技能", comment: "")
       
        option1.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        option2 = TeamSimulationTextFieldOption()
        contentView.addSubview(option2)
        option2.addTarget(self, action: #selector(option2TextFieldEndEditing(_:)), for: .editingDidEnd)
        option2.addTarget(self, action: #selector(option2TextFieldEndEditing(_:)), for: .editingDidEndOnExit)
        option2.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.left.equalTo(10)
            make.top.equalTo(option1.snp.bottom).offset(10)
        }
        option2.label.text = NSLocalizedString("小屋加成%", comment: "")
        
        
        option3 = TeamSimulationTextFieldOption()
        option3.label.text = NSLocalizedString("Great占比%", comment: "")
        option3.addTarget(self, action: #selector(option3TextFieldEndEditing(_:)), for: .editingDidEnd)
        option3.addTarget(self, action: #selector(option3TextFieldEndEditing(_:)), for: .editingDidEndOnExit)
        contentView.addSubview(option3)
        option3.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(option2.snp.bottom).offset(10)
        }
        
        option4 = TeamSimulationTextFieldOption()
        option4.label.text = NSLocalizedString("模拟次数", comment: "")
        option4.addTarget(self, action: #selector(option4TextFieldEndEditing(_:)), for: .editingDidEnd)
        option4.addTarget(self, action: #selector(option4TextFieldEndEditing(_:)), for: .editingDidEndOnExit)
        contentView.addSubview(option4)
        option4.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(option3.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        
        selectionStyle = .none
    }
    
    func option1SwitchChanged(_ sender: UISwitch) {
        delegate?.teamSimulationAdvanceOptionCell(self, didSetOverloadSkillLifeLimitation: sender.isOn)
    }
    
    private func validateOption2TextField() {
        if let value = Double(option2.textField.text ?? ""), value >= 0 && value <= 10 {
            option2.textField.text = String(Int(value))
        } else {
            option2.textField.text = "10"
        }
    }
    
    func setupWithUserDefaults() {
        option1.switch.isOn = LiveSimulationAdvanceOptionsManager.default.allowOverloadSkillsTriggerLifeCondition
        option2.textField.text = String(LiveSimulationAdvanceOptionsManager.default.roomUpValue)
        option3.textField.text = String(LiveSimulationAdvanceOptionsManager.default.greatPercent)
        option4.textField.text = String(LiveSimulationAdvanceOptionsManager.default.simulationTimes)
    }
    
    func option2TextFieldEndEditing(_ sender: UITextField) {
        validateOption2TextField()
        delegate?.teamSimulationAdvanceOptionCell(self, didSetRoomValue: Int(option2.textField.text!)!)
    }
    
    private func validateOption3TextField() {
        if let value = Double(option3.textField.text ?? ""), value >= 0 && value <= 100 {
            option3.textField.text = String(Double(value))
        } else {
            option3.textField.text = "0.0"
        }
    }
    
    func option3TextFieldEndEditing(_ sender: UITextField) {
        validateOption3TextField()
        delegate?.teamSimulationAdvanceOptionCell(self, didSetGreatPercent: Double(option3.textField.text!)!)
    }
    
    private func validateOption4TextField() {
        if let value = Int(option4.textField.text ?? ""), value >= 1 && value <= Int.max {
            option4.textField.text = String(value)
        } else {
            option4.textField.text = "10000"
        }
    }
    
    func option4TextFieldEndEditing(_ sender: UITextField) {
        validateOption4TextField()
        delegate?.teamSimulationAdvanceOptionCell(self, didSetSimulationTimes: Int(option4.textField.text!)!)
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

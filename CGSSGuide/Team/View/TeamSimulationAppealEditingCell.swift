//
//  TeamSimulationAppealEditingCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol TeamSimulationAppealEditingCellDelegate: class {
    func teamSimulationAppealEditingCell(_ teamSimulationAppealEditingCell: TeamSimulationAppealEditingCell, didUpdateAt selectionIndex: Int, supportAppeal: Int, customAppeal: Int)
    
    func teamSimulationAppealEditingCell(_ teamSimulationAppealEditingCell: TeamSimulationAppealEditingCell, beginEdit textField: UITextField)
}

class TeamSimulationAppealInputTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        autocorrectionType = .no
        autocapitalizationType = .none
        borderStyle = .roundedRect
        textAlignment = .right
        font = UIFont.systemFont(ofSize: 14)
        keyboardType = .numbersAndPunctuation
        contentVerticalAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TeamSimulationAppealEditingCell: UITableViewCell {

    var leftLabel: UILabel!
    
    var supportAppealBox: CheckBox!
    
    var customAppealBox: CheckBox!
    
    var supportAppealTextField: TeamSimulationAppealInputTextField!
    
    var customAppealTextField: TeamSimulationAppealInputTextField!
    
    weak var delegate: TeamSimulationAppealEditingCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel = UILabel()
        leftLabel.text = NSLocalizedString("表现值", comment: "队伍详情页面") + ": "
        leftLabel.font = UIFont.systemFont(ofSize: 16)

        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        
        supportAppealBox = CheckBox()
        supportAppealBox.label.font = UIFont.systemFont(ofSize: 14)
        supportAppealBox.label.text = NSLocalizedString("使用后援数值", comment: "队伍详情页面") + ": "
        supportAppealBox.label.textColor = UIColor.darkGray
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(checkBox(_:)))
        supportAppealBox.addGestureRecognizer(tap1)
        contentView.addSubview(supportAppealBox)
       
        supportAppealTextField = TeamSimulationAppealInputTextField()
        
        supportAppealTextField.addTarget(self, action: #selector(beginEditAppealTextField(sender:)), for: .editingDidBegin)
        supportAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEnd)
        supportAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEndOnExit)
        
        contentView.addSubview(supportAppealTextField)
        
        supportAppealTextField.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.width.equalTo(contentView.snp.width).dividedBy(2).offset(-20)
            make.height.greaterThanOrEqualTo(24)
        }
        supportAppealBox.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(supportAppealBox)
        }
        
        
        customAppealBox = CheckBox()
        customAppealBox.label.font = UIFont.systemFont(ofSize: 14)
        customAppealBox.label.text = NSLocalizedString("使用固定值", comment: "队伍详情页面") + ": "
        customAppealBox.label.textColor = UIColor.darkGray
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(checkBox(_:)))
        customAppealBox.addGestureRecognizer(tap2)
        contentView.addSubview(customAppealBox)
        
        customAppealTextField = TeamSimulationAppealInputTextField()
        
        customAppealTextField.addTarget(self, action: #selector(beginEditAppealTextField(sender:)), for: .editingDidBegin)
        customAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEnd)
        customAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEndOnExit)
        
        contentView.addSubview(customAppealTextField)
        
        customAppealTextField.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(customAppealTextField.snp.bottom).offset(5)
            make.width.equalTo(contentView.snp.width).dividedBy(2).offset(-20)
            make.height.greaterThanOrEqualTo(24)
            make.bottom.equalTo(-10)
        }
        customAppealBox.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(customAppealTextField)
        }
    }
    
    
    func beginEditAppealTextField(sender: UITextField) {
        delegate?.teamSimulationAppealEditingCell(self, beginEdit: sender)
    }
    
    func endEditAppeal() {
        delegate?.teamSimulationAppealEditingCell(self, didUpdateAt: supportAppealBox.isChecked ? 0 : 1, supportAppeal: Int(supportAppealTextField.text ?? "") ?? 0, customAppeal: Int(customAppealTextField.text ?? "") ?? 0)
    }
    
    func endEditCheckBox() {
        endEditAppeal()
    }
    
    func checkBox(_ tap: UITapGestureRecognizer) {
        supportAppealBox.setChecked(tap.view == supportAppealBox)
        customAppealBox.setChecked(!(tap.view == supportAppealBox))
        endEditCheckBox()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

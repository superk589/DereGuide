//
//  UnitSimulationAppealEditingCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol UnitSimulationAppealEditingCellDelegate: class {
    func unitSimulationAppealEditingCell(_ unitSimulationAppealEditingCell: UnitSimulationAppealEditingCell, didUpdateAt selectionIndex: Int, supportAppeal: Int, customAppeal: Int)
    
    func unitSimulationAppealEditingCell(_ unitSimulationAppealEditingCell: UnitSimulationAppealEditingCell, beginEdit textField: UITextField)
}

extension UnitSimulationAppealEditingCellDelegate {
    func unitSimulationAppealEditingCell(_ unitSimulationAppealEditingCell: UnitSimulationAppealEditingCell, beginEdit textField: UITextField) {
        
    }
}

class UnitSimulationAppealInputTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        autocorrectionType = .no
        autocapitalizationType = .none
        borderStyle = .roundedRect
        textAlignment = .right
        font = UIFont.systemFont(ofSize: 14)
        keyboardType = .numbersAndPunctuation
        returnKeyType = .done
        contentVerticalAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UnitSimulationAppealEditingCell: UITableViewCell {

//    var leftLabel: UILabel!
    
    var supportAppealBox: CheckBox!
    
    var customAppealBox: CheckBox!
    
    var supportAppealTextField: UnitSimulationAppealInputTextField!
    
    var customAppealTextField: UnitSimulationAppealInputTextField!
    
    weak var delegate: UnitSimulationAppealEditingCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        leftLabel = UILabel()
//        leftLabel.text = NSLocalizedString("表现值", comment: "队伍详情页面") + ": "
//        leftLabel.font = UIFont.systemFont(ofSize: 16)
//
//        contentView.addSubview(leftLabel)
//        leftLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.top.equalTo(10)
//        }
        
        
        supportAppealBox = CheckBox()
        supportAppealBox.tintColor = Color.dance
        supportAppealBox.label.font = UIFont.systemFont(ofSize: 14)
        supportAppealBox.label.text = NSLocalizedString("使用后援表现值", comment: "队伍详情页面") + ": "
        supportAppealBox.label.textColor = UIColor.darkGray
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(checkBox(_:)))
        supportAppealBox.addGestureRecognizer(tap1)
        contentView.addSubview(supportAppealBox)
       
        supportAppealTextField = UnitSimulationAppealInputTextField()
        
        supportAppealTextField.addTarget(self, action: #selector(beginEditAppealTextField(sender:)), for: .editingDidBegin)
        supportAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEnd)
        supportAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEndOnExit)

        
        contentView.addSubview(supportAppealTextField)
        
        supportAppealTextField.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
//            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.top.equalTo(10)
            make.width.equalTo(contentView.snp.width).dividedBy(2).offset(-20)
            make.height.greaterThanOrEqualTo(24)
        }
        supportAppealBox.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(supportAppealTextField)
            make.right.lessThanOrEqualTo(supportAppealTextField.snp.left)
        }
        
        
        customAppealBox = CheckBox()
        customAppealBox.tintColor = Color.dance
        customAppealBox.label.font = UIFont.systemFont(ofSize: 14)
        customAppealBox.label.text = NSLocalizedString("使用固定值", comment: "队伍详情页面") + ": "
        customAppealBox.label.textColor = UIColor.darkGray
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(checkBox(_:)))
        customAppealBox.addGestureRecognizer(tap2)
        contentView.addSubview(customAppealBox)
        
        customAppealTextField = UnitSimulationAppealInputTextField()
        
        customAppealTextField.addTarget(self, action: #selector(beginEditAppealTextField(sender:)), for: .editingDidBegin)
        customAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEnd)
        customAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEndOnExit)
        
        contentView.addSubview(customAppealTextField)
        
        customAppealTextField.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(supportAppealTextField.snp.bottom).offset(10)
            make.width.equalTo(contentView.snp.width).dividedBy(2).offset(-20)
            make.height.greaterThanOrEqualTo(24)
            make.bottom.equalTo(-10)
        }
        customAppealBox.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(customAppealTextField)
            make.right.lessThanOrEqualTo(customAppealTextField.snp.left)
        }
        
        selectionStyle = .none

    }
    
    
    @objc func beginEditAppealTextField(sender: UITextField) {
        delegate?.unitSimulationAppealEditingCell(self, beginEdit: sender)
    }
    
    private func validteInputResult() {
        if let value = Double(supportAppealTextField.text ?? "") {
            supportAppealTextField.text = String(Int(value))
        } else {
            supportAppealTextField.text = String(CGSSGlobal.defaultSupportAppeal)
        }
       
        if let value = Double(customAppealTextField.text ?? "") {
            customAppealTextField.text = String(Int(value))
        } else {
            customAppealTextField.text = "0"
        }
    }
    
    @objc func endEditAppeal() {
        validteInputResult()
        delegate?.unitSimulationAppealEditingCell(self, didUpdateAt: supportAppealBox.isChecked ? 0 : 1, supportAppeal: Int(supportAppealTextField.text ?? "") ?? 0, customAppeal: Int(customAppealTextField.text ?? "") ?? 0)
    }
    
    func endEditCheckBox() {
        endEditAppeal()
    }
    
    func setup(with unit: Unit) {
        supportAppealBox.setChecked(!unit.usesCustomAppeal)
        supportAppealTextField.isEnabled = !unit.usesCustomAppeal
        supportAppealTextField.text = unit.supportAppeal.description
        customAppealBox.setChecked(unit.usesCustomAppeal)
        customAppealTextField.isEnabled = unit.usesCustomAppeal
        customAppealTextField.text = unit.customAppeal.description
    }
    
    @objc func checkBox(_ tap: UITapGestureRecognizer) {
        supportAppealBox.setChecked(tap.view == supportAppealBox)
        customAppealBox.setChecked(!(tap.view == supportAppealBox))
        supportAppealTextField.isEnabled = (tap.view == supportAppealBox)
        customAppealTextField.isEnabled = !(tap.view == supportAppealBox)
        endEditCheckBox()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

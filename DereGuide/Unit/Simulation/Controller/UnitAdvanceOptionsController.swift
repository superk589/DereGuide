//
//  UnitAdvanceOptionsController.swift
//  DereGuide
//
//  Created by zzk on 2017/6/3.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitAdvanceOptionsController: UITableViewController {

    var staticCells = [UnitAdvanceOptionsTableViewCell]()
    
    let option1 = SwitchOption()
    let option2 = StepperOption()
    let option3 = TextFieldOption()
    let option4 = TextFieldOption()

    let option5 = TextFieldOption()
    
    let option6 = TextFieldOption()
    
    let option7 = TextFieldOption()
    
    private func prepareStaticCells() {
        
        option1.switch.isOn = false

        option1.addTarget(self, action: #selector(option1ValueChanged(_:)), for: .valueChanged)
        let option1Label = option1.label
        option1Label.text = NSLocalizedString("Groove模式中，若队伍可发动生命恢复效果，起始状态就拥有两倍生命值。", comment: "")
        
        option2.addTarget(self, action: #selector(option2ValueChanged(_:)), for: .valueChanged)
        option2.setup(title: NSLocalizedString("小屋加成%", comment: ""), minValue: 0, maxValue: 10, currentValue: 0)
        
        option3.label.text = NSLocalizedString("GREAT占比%(不考虑专注技能只加成PERFECT的因素)", comment: "")
        option3.addTarget(self, action: #selector(option3TextFieldEndEditing(_:)), for: .editingDidEnd)
        option3.addTarget(self, action: #selector(option3TextFieldEndEditing(_:)), for: .editingDidEndOnExit)

        option4.label.text = NSLocalizedString("模拟次数", comment: "")
        option4.addTarget(self, action: #selector(option4TextFieldEndEditing(_:)), for: .editingDidEnd)
        option4.addTarget(self, action: #selector(option4TextFieldEndEditing(_:)), for: .editingDidEndOnExit)
        
        option5.label.text = NSLocalizedString("挂机模式中，手动打前 x 秒", comment: "")
        option5.addTarget(self, action: #selector(option5TextFieldEndEditing(_:)), for: .editingDidEnd)
        option5.addTarget(self, action: #selector(option5TextFieldEndEditing(_:)), for: .editingDidEndOnExit)

        option6.label.text = NSLocalizedString("挂机模式中，手动打前 x combo", comment: "")
        option6.addTarget(self, action: #selector(option6TextFieldEndEditing(_:)), for: .editingDidEnd)
        option6.addTarget(self, action: #selector(option6TextFieldEndEditing(_:)), for: .editingDidEndOnExit)
        
        option7.label.text = NSLocalizedString("挂机模式模拟次数", comment: "")
        option7.addTarget(self, action: #selector(option7TextFieldEndEditing(_:)), for: .editingDidEnd)
        option7.addTarget(self, action: #selector(option7TextFieldEndEditing(_:)), for: .editingDidEndOnExit)

        let cell1 = UnitAdvanceOptionsTableViewCell(optionStyle: .switch(option1))
        let cell2 = UnitAdvanceOptionsTableViewCell(optionStyle: .stepper(option2))
        let cell3 = UnitAdvanceOptionsTableViewCell(optionStyle: .textField(option3))
        let cell4 = UnitAdvanceOptionsTableViewCell(optionStyle: .textField(option4))
        let cell5 = UnitAdvanceOptionsTableViewCell(optionStyle: .textField(option5))
        let cell6 = UnitAdvanceOptionsTableViewCell(optionStyle: .textField(option6))
        let cell7 = UnitAdvanceOptionsTableViewCell(optionStyle: .textField(option7))

        staticCells.append(contentsOf: [cell1, cell2, cell3, cell4, cell7, cell5, cell6])
        
        setupWithUserDefaults()
    }
    
    private func prepareNaviBar() {
        let resetItem = UIBarButtonItem.init(title: NSLocalizedString("重置", comment: "导航栏按钮"), style: .plain, target: self, action: #selector(resetAction))
        navigationItem.rightBarButtonItem = resetItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("高级选项", comment: "")
        prepareStaticCells()
        prepareNaviBar()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        
        tableView.register(UnitAdvanceOptionsTableViewCell.self, forCellReuseIdentifier: UnitAdvanceOptionsTableViewCell.description())
    }
    
    @objc private func resetAction() {
        LiveSimulationAdvanceOptionsManager.default.reset()
        setupWithUserDefaults()
        tableView.reloadData()
    }
    
    @objc private func option1ValueChanged(_ sender: UISwitch) {
        LiveSimulationAdvanceOptionsManager.default.startGrooveWithDoubleHP = option1.switch.isOn
    }
    
    @objc private func option2ValueChanged(_ sender: ValueStepper) {
        LiveSimulationAdvanceOptionsManager.default.roomUpValue = Int(option2.stepper.value)
    }
    
    func setupWithUserDefaults() {
        option1.switch.isOn = LiveSimulationAdvanceOptionsManager.default.startGrooveWithDoubleHP
        option2.stepper.value = Double(LiveSimulationAdvanceOptionsManager.default.roomUpValue)
        option3.textField.text = String(LiveSimulationAdvanceOptionsManager.default.greatPercent)
        option4.textField.text = String(LiveSimulationAdvanceOptionsManager.default.simulationTimes)
        option5.textField.text = String(LiveSimulationAdvanceOptionsManager.default.afkModeStartSeconds)
        option6.textField.text = String(LiveSimulationAdvanceOptionsManager.default.afkModeStartCombo)
        option7.textField.text = String(LiveSimulationAdvanceOptionsManager.default.afkModeSimulationTimes)
    }
    
    private func validateOption3TextField() {
        if let value = Double(option3.textField.text ?? ""), value >= 0 && value <= 100 {
            option3.textField.text = String(Double(value))
        } else {
            option3.textField.text = "0.0"
        }
    }
    
    @objc private func option3TextFieldEndEditing(_ sender: UITextField) {
        validateOption3TextField()
        LiveSimulationAdvanceOptionsManager.default.greatPercent = Double(option3.textField.text!)!
    }
    
    private func validateOption4TextField() {
        if let value = Int(option4.textField.text ?? ""), value >= 1 && value <= Int.max {
            option4.textField.text = String(value)
        } else {
            option4.textField.text = "10000"
        }
    }
    
    @objc private func option4TextFieldEndEditing(_ sender: UITextField) {
        validateOption4TextField()
        LiveSimulationAdvanceOptionsManager.default.simulationTimes = Int(option4.textField.text!)!
    }
    
    private func validateOption5TextField() {
        if let value = Float(option5.textField.text ?? ""), value >= 0 && value <= Float.greatestFiniteMagnitude {
            option5.textField.text = String(value)
        } else {
            option5.textField.text = "0"
        }
    }
    
    @objc private func option5TextFieldEndEditing(_ sender: UITextField) {
        validateOption5TextField()
        LiveSimulationAdvanceOptionsManager.default.afkModeStartSeconds = Float(option5.textField.text!)!
    }
    
    private func validateOption6TextField() {
        if let value = Int(option6.textField.text ?? ""), value >= 0 && value <= Int.max {
            option6.textField.text = String(value)
        } else {
            option6.textField.text = "0"
        }
    }
    
    @objc private func option6TextFieldEndEditing(_ sender: UITextField) {
        validateOption6TextField()
        LiveSimulationAdvanceOptionsManager.default.afkModeStartCombo = Int(option6.textField.text!)!
    }
    
    private func validateOption7TextField() {
        if let value = Int(option7.textField.text ?? ""), value >= 1 && value <= Int.max {
            option7.textField.text = String(value)
        } else {
            option7.textField.text = "1000"
        }
    }
    
    @objc private func option7TextFieldEndEditing(_ sender: UITextField) {
        validateOption7TextField()
        LiveSimulationAdvanceOptionsManager.default.afkModeSimulationTimes = Int(option7.textField.text!)!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staticCells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = staticCells[indexPath.row]
        return cell
    }
}

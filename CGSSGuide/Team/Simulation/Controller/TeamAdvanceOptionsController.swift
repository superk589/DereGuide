//
//  TeamAdvanceOptionsController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/3.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

//protocol TeamAdvanceOptionsControllerDelegate: class {
//    func doneAndReturn(_ teamAdvanceOptionsController: TeamAdvanceOptionsController)
//}

class TeamAdvanceOptionsController: BaseTableViewController {

    var staticCells = [TeamAdvanceOptionsTableViewCell]()
    
    var option1: TeamSimulationSwitchOption!
    var option2: TeamSimulationTextFieldOption!
    var option3: TeamSimulationTextFieldOption!
    var option4: TeamSimulationTextFieldOption!
    var option5: TeamSimulationTextFieldOption!
    
//    weak var delegate: TeamAdvanceOptionsControllerDelegate?
    
    private func prepareStaticCells() {
        
        option1 = TeamSimulationSwitchOption()
        option1.switch.isOn = false
        
        option1.addTarget(self, action: #selector(option1ValueChanged(_:)), for: .valueChanged)
        let option1Label = option1.label
        option1Label.text = NSLocalizedString("模拟计算中生命不足时不发动过载技能", comment: "")
        
        option2 = TeamSimulationTextFieldOption()
        option2.addTarget(self, action: #selector(option2TextFieldEndEditing(_:)), for: .editingDidEnd)
        option2.addTarget(self, action: #selector(option2TextFieldEndEditing(_:)), for: .editingDidEndOnExit)
        option2.label.text = NSLocalizedString("小屋加成%", comment: "")
        
        
        option3 = TeamSimulationTextFieldOption()
        option3.label.text = NSLocalizedString("Great占比%", comment: "")
        option3.addTarget(self, action: #selector(option3TextFieldEndEditing(_:)), for: .editingDidEnd)
        option3.addTarget(self, action: #selector(option3TextFieldEndEditing(_:)), for: .editingDidEndOnExit)

        option4 = TeamSimulationTextFieldOption()
        option4.label.text = NSLocalizedString("模拟次数", comment: "")
        option4.addTarget(self, action: #selector(option4TextFieldEndEditing(_:)), for: .editingDidEnd)
        option4.addTarget(self, action: #selector(option4TextFieldEndEditing(_:)), for: .editingDidEndOnExit)

        let cell1 = TeamAdvanceOptionsTableViewCell(optionStyle: .switch(option1))
        let cell2 = TeamAdvanceOptionsTableViewCell(optionStyle: .textField(option2))
        let cell3 = TeamAdvanceOptionsTableViewCell(optionStyle: .textField(option3))
        let cell4 = TeamAdvanceOptionsTableViewCell(optionStyle: .textField(option4))
        staticCells.append(contentsOf: [cell1, cell2, cell3, cell4])
        
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableFooterView = UIView()
        
        tableView.register(TeamAdvanceOptionsTableViewCell.self, forCellReuseIdentifier: TeamAdvanceOptionsTableViewCell.description())
    }
    
    func resetAction() {
        LiveSimulationAdvanceOptionsManager.default.reset()
        setupWithUserDefaults()
        tableView.reloadData()
    }
    
    func option1ValueChanged(_ sender: UISwitch) {
        LiveSimulationAdvanceOptionsManager.default.considerOverloadSkillsTriggerLifeCondition = option1.switch.isOn
    }
    
    private func validateOption2TextField() {
        if let value = Double(option2.textField.text ?? ""), value >= 0 && value <= 10 {
            option2.textField.text = String(Int(value))
        } else {
            option2.textField.text = "10"
        }
    }
    
    func setupWithUserDefaults() {
        option1.switch.isOn = LiveSimulationAdvanceOptionsManager.default.considerOverloadSkillsTriggerLifeCondition
        option2.textField.text = String(LiveSimulationAdvanceOptionsManager.default.roomUpValue)
        option3.textField.text = String(LiveSimulationAdvanceOptionsManager.default.greatPercent)
        option4.textField.text = String(LiveSimulationAdvanceOptionsManager.default.simulationTimes)
    }
    
    func option2TextFieldEndEditing(_ sender: UITextField) {
        validateOption2TextField()
        LiveSimulationAdvanceOptionsManager.default.roomUpValue = Int(option2.textField.text!)!
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
        LiveSimulationAdvanceOptionsManager.default.greatPercent = Double(option3.textField.text!)!
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
        LiveSimulationAdvanceOptionsManager.default.simulationTimes = Int(option4.textField.text!)!
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

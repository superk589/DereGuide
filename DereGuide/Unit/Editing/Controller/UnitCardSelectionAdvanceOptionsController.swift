//
//  UnitCardSelectionAdvanceOptionsController.swift
//  DereGuide
//
//  Created by zzk on 2017/6/12.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol UnitCardSelectionAdvanceOptionsControllerDelegate: class {
    func recentUsedIdolsNeedToReload()
}

class UnitCardSelectionAdvanceOptionsController: BaseTableViewController {
    
    weak var delegate: UnitCardSelectionAdvanceOptionsControllerDelegate?
    
    var staticCells = [UnitAdvanceOptionsTableViewCell]()
    
    var option1: StepperOption!
    var option2: StepperOption!
    var option3: SwitchOption!
    var option4: SwitchOption!
    
    private func prepareStaticCells() {
        
        option1 = StepperOption()
        option1.addTarget(self, action: #selector(option1ValueChanged(_:)), for: .valueChanged)
        option1.setup(title: NSLocalizedString("默认特技等级", comment: ""), minValue: 0, maxValue: 10, currentValue: 0)
        
        option2 = StepperOption()
        option2.addTarget(self, action: #selector(option2ValueChanged(_:)), for: .valueChanged)
        option2.setup(title: NSLocalizedString("默认潜能等级", comment: ""), minValue: 0, maxValue: 25, currentValue: 0)
        
        option3 = SwitchOption()
        option3.addTarget(self, action: #selector(option3ValueChanged(_:)), for: .valueChanged)
        option3.label.text = NSLocalizedString("最近使用中也包含好友的队长", comment: "")
        
        option4 = SwitchOption()
        option4.addTarget(self, action: #selector(option4ValueChanged(_:)), for: .valueChanged)
        option4.label.text = NSLocalizedString("修改最近使用中的偶像潜能同步到同角色所有卡片", comment: "")
        
        let cell1 = UnitAdvanceOptionsTableViewCell(optionStyle: .stepper(option1))
        let cell2 = UnitAdvanceOptionsTableViewCell(optionStyle: .stepper(option2))
        let cell3 = UnitAdvanceOptionsTableViewCell(optionStyle: .switch(option3))
        let cell4 = UnitAdvanceOptionsTableViewCell(optionStyle: .switch(option4))
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
        
        tableView.register(UnitAdvanceOptionsTableViewCell.self, forCellReuseIdentifier: UnitAdvanceOptionsTableViewCell.description())
    }
    
    @objc func resetAction() {
        UnitEditingAdvanceOptionsManager.default.reset()
        setupWithUserDefaults()
        tableView.reloadData()
    }
    
    private func setupWithUserDefaults() {
        option1.stepper.value = Double(UnitEditingAdvanceOptionsManager.default.defaultSkillLevel)
        option2.stepper.value = Double(UnitEditingAdvanceOptionsManager.default.defaultPotentialLevel)
        option3.switch.isOn = UnitEditingAdvanceOptionsManager.default.includeGuestLeaderInRecentUsedIdols
        option4.switch.isOn = UnitEditingAdvanceOptionsManager.default.editAllSameChara
    }
    
    @objc func option1ValueChanged(_ sender: UISlider) {
        UnitEditingAdvanceOptionsManager.default.defaultSkillLevel = Int(option1.stepper.value)
    }
    
    @objc func option2ValueChanged(_ sender: ValueStepper) {
        UnitEditingAdvanceOptionsManager.default.defaultPotentialLevel = Int(option2.stepper.value)
    }
    
    @objc func option3ValueChanged(_ sender: UISwitch) {
        UnitEditingAdvanceOptionsManager.default.includeGuestLeaderInRecentUsedIdols = option3.switch.isOn
        delegate?.recentUsedIdolsNeedToReload()
    }
    
    @objc func option4ValueChanged(_ sender: UISwitch) {
        UnitEditingAdvanceOptionsManager.default.editAllSameChara = option4.switch.isOn
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

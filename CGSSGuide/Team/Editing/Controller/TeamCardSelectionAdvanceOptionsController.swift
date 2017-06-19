//
//  TeamCardSelectionAdvanceOptionsController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/12.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class TeamCardSelectionAdvanceOptionsController: BaseTableViewController {

    var staticCells = [TeamAdvanceOptionsTableViewCell]()
    
    var option1: TeamSimulationSliderOption!
    var option2: TeamSimulationSliderOption!
    var option3: TeamSimulationSwitchOption!
//    var option4: TeamSimulationSwitchOption!
    //    weak var delegate: TeamAdvanceOptionsControllerDelegate?
    
    private func prepareStaticCells() {
        
        option1 = TeamSimulationSliderOption()
        
        option1.addTarget(self, action: #selector(option1ValueChanged(_:)), for: .valueChanged)
        option1.label.text = NSLocalizedString("默认特技等级", comment: "")
        option1.slider.maximumValue = 10
        option1.slider.minimumValue = 0
        
        option2 = TeamSimulationSliderOption()
        option2.addTarget(self, action: #selector(option2ValueChanged(_:)), for: .valueChanged)
        option2.label.text = NSLocalizedString("默认潜能等级", comment: "")
        option2.slider.maximumValue = 25
        option2.slider.minimumValue = 0
        
        option3 = TeamSimulationSwitchOption()
        option3.addTarget(self, action: #selector(option3ValueChanged(_:)), for: .valueChanged)
        option3.label.text = NSLocalizedString("最近使用中也包含好友的队长", comment: "")
        
        let cell1 = TeamAdvanceOptionsTableViewCell(optionStyle: .slider(option1))
        let cell2 = TeamAdvanceOptionsTableViewCell(optionStyle: .slider(option2))
        let cell3 = TeamAdvanceOptionsTableViewCell(optionStyle: .switch(option3))
        staticCells.append(contentsOf: [cell1, cell2])
        
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
        TeamEditingAdvanceOptionsManager.default.reset()
        setupWithUserDefaults()
        tableView.reloadData()
    }
    
    private func setupWithUserDefaults() {
        option1.currentValue = TeamEditingAdvanceOptionsManager.default.defaultSkillLevel
        option2.currentValue = TeamEditingAdvanceOptionsManager.default.defaultPotentialLevel
        option3.switch.isOn = TeamEditingAdvanceOptionsManager.default.includeGuestLeaderInRecentUsedIdols
    }
    
    func option1ValueChanged(_ sender: UISlider) {
        TeamEditingAdvanceOptionsManager.default.defaultSkillLevel = option1.currentValue
    }
    
    func option2ValueChanged(_ sender: UISlider) {
        TeamEditingAdvanceOptionsManager.default.defaultPotentialLevel = option2.currentValue
    }
    
    func option3ValueChanged(_ sender: UISwitch) {
        
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

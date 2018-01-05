//
//  LiveSimulatorSupportSkillsViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/5/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class LiveSimulatorSupportSkillsViewController: LiveSimulatorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionFooterHeight = 0
        tableView.indicator.strokeColor = Color.parade.withAlphaComponent(0.5)
        tableView.register(NoteSupportTableViewCell.self, forCellReuseIdentifier: NoteSupportTableViewCell.description())
        tableView.register(NoteSupportTableViewHeader.self, forHeaderFooterViewReuseIdentifier: NoteSupportTableViewHeader.description())
    }
    
    override func selectDisplayMode() {
        let alvc = UIAlertController.init(title: NSLocalizedString("选择模式", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        alvc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("极限模式", comment: ""), style: .default, handler: { [weak self] (action) in
            self?.displayType = .optimistic2
        }))
        
        alvc.addAction(UIAlertAction.init(title: DisplayType.simulation.description, style: .default, handler: { [weak self] (action) in
            self?.displayType = .simulation
        }))
        
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil))
        self.tabBarController?.present(alvc, animated: true, completion: nil)
    }
    
    override func reloadUI() {
        switch displayType {
        case .optimistic1:
            break
        case .optimistic2:
            navigationItem.title = NSLocalizedString("极限模式", comment: "")
            simulator.simulateOnce(options: [.maxRate, .detailLog], callback: { [weak self] (result, logs) in
                self?.logs = logs
            })
        case .simulation:
            navigationItem.title = displayType.description
            var options: LSOptions = [.detailLog]
            if LiveSimulationAdvanceOptionsManager.default.considerOverloadSkillsTriggerLifeCondition {
                options.insert(.overloadLimitByLife)
            }
            simulator.simulateOnce(options: options, callback: { [weak self] (result, logs) in
                self?.logs = logs
            })
        }
    }
    
    // MARK: TableViewDataSource & Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteSupportTableViewCell.description(), for: indexPath) as! NoteSupportTableViewCell
        cell.setup(with: logs[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoteSupportTableViewHeader.description())
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}

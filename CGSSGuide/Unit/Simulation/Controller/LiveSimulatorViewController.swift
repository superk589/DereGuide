//
//  LiveSimulatorViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/29.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class LiveSimulatorViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = IndicatorTableView()
    
    enum DisplayType: CustomStringConvertible {
        case optimistic1
        case optimistic2
        case simulation
        
        static let all: [DisplayType] = [.optimistic1, .optimistic2, .simulation]
        
        var description: String {
            switch self {
            case .optimistic1:
                return NSLocalizedString("极限分数", comment: "") + "1"
            case .optimistic2:
                return NSLocalizedString("极限分数", comment: "") + "2"
            case .simulation:
                return NSLocalizedString("随机单次模拟", comment: "")
            }
        }
    }
    
    var coordinator: LSCoordinator!
    lazy var simulator: CGSSLiveSimulator = {
        self.coordinator.generateLiveSimulator()
    }()
    
    var displayType: DisplayType = .optimistic2 {
        didSet {
            reloadUI()
        }
    }
    
    var logs = [LSLog]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.indicator.strokeColor = Color.life.withAlphaComponent(0.5)
        tableView.sectionHeaderHeight = 30
        tableView.sectionFooterHeight = 30
        
        prepareNavigationBar()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteScoreTableViewCell.self, forCellReuseIdentifier: "Note Cell")
        tableView.register(NoteScoreTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: "Note Header")
        tableView.register(NoteScoreTableViewSectionFooter.self, forHeaderFooterViewReuseIdentifier: "Note Footer")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    private func prepareNavigationBar() {
        let rightItem = UIBarButtonItem.init(title: NSLocalizedString("模式", comment: ""), style: .plain, target: self, action: #selector(selectDisplayMode))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func selectDisplayMode() {
        let alvc = UIAlertController.init(title: NSLocalizedString("选择模式", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        alvc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        for type in DisplayType.all {
            alvc.addAction(UIAlertAction.init(title: type.description, style: .default, handler: { [weak self] (action) in
                self?.displayType = type
            }))
        }
        
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil))
        self.tabBarController?.present(alvc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUI()
    }
    
    func reloadUI() {
        navigationItem.title = displayType.description
        
        switch displayType {
        case .optimistic1:
            simulator.simulateOptimistic1(options: [.detailLog, .maxRate], callback: { [weak self] (result, logs) in
                self?.logs = logs
            })
        case .optimistic2:
            simulator.simulateOnce(options: [.maxRate, .detailLog], callback: { [weak self] (result, logs) in
                self?.logs = logs
            })
        case .simulation:
            var options: LSOptions = .detailLog
            if LiveSimulationAdvanceOptionsManager.default.considerOverloadSkillsTriggerLifeCondition {
                options.insert(.overloadLimitByLife)
            }
            simulator.simulateOnce(options: options, callback: { [weak self] (result, logs) in
                self?.logs = logs
            })
        }
    }
    
    // MARK: TableViewDataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note Cell", for: indexPath) as! NoteScoreTableViewCell
        cell.setup(with: logs[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Note Header")
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Note Footer") as! NoteScoreTableViewSectionFooter
        if let baseScore = logs.first?.baseScore, let totalScore = logs.last?.sum {
            footer.setupWith(baseScore: baseScore, totalScore: totalScore)
        }
        return footer
    }

}

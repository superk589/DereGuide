//
//  LiveSimulatorViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/29.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class LiveSimulatorViewController: BaseTableViewController {
    
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
    
    private var displayType: DisplayType = .optimistic2 {
        didSet {
            reloadUI()
        }
    }
    
    private var logs = [LSLog]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        tableView.register(NoteScoreTableViewCell.self, forCellReuseIdentifier: "Note Cell")
        tableView.register(NoteScoreTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: "Note Header")
        tableView.register(NoteScoreTableViewSectionFooter.self, forHeaderFooterViewReuseIdentifier: "Note Footer")
        tableView.separatorStyle = .none
    }
    
    private func prepareNavigationBar() {
        let rightItem = UIBarButtonItem.init(title: NSLocalizedString("模式", comment: ""), style: .plain, target: self, action: #selector(selectDisplayMode))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func selectDisplayMode() {
        let alvc = UIAlertController.init(title: NSLocalizedString("选择模式", comment: ""), message: nil, preferredStyle: .actionSheet)
        
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
    
    private func reloadUI() {
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
            simulator.simulateOnce(options: [.detailLog, .overloadLimitByLife], callback: { [weak self] (result, logs) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note Cell", for: indexPath) as! NoteScoreTableViewCell
        cell.setup(with: logs[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Note Header")
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Note Footer") as! NoteScoreTableViewSectionFooter
        if let baseScore = logs.first?.baseScore, let totalScore = logs.last?.sum {
            footer.setupWith(baseScore: baseScore, totalScore: totalScore)
        }
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}

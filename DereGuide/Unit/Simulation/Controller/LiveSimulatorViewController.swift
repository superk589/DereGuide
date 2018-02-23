//
//  LiveSimulatorViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/3/29.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class LiveSimulatorViewController: BaseViewController {
    
    lazy var scoreDashboard: ScoreDashboardController = {
        let vc = ScoreDashboardController()
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        return vc
    }()
    
    lazy var supportDashboard: SupportDashboardController = {
        let vc = SupportDashboardController()
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        return vc
    }()
    
    typealias Setting = LiveSimulatorModeSelectionViewController.Setting
    
    private var setting = Setting.load() ?? Setting()
    
    private lazy var optionController: LiveSimulatorModeSelectionViewController = {
        let vc = LiveSimulatorModeSelectionViewController(style: .grouped)
        vc.setting = self.setting
        vc.delegate = self
        return vc
    }()
    
    var coordinator: LiveCoordinator!
    lazy var simulator: LiveSimulator = {
        self.coordinator.generateLiveSimulator()
    }()
    
    var logs = [LSLog]() {
        didSet {
            if setting.dashboardType == .score {
                scoreDashboard.logs = logs
            } else {
                supportDashboard.logs = logs
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()

        view.addSubview(supportDashboard.tableView)
        supportDashboard.tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        view.addSubview(scoreDashboard.tableView)
        scoreDashboard.tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        reloadUI()
        
    }
    
    private func prepareNavigationBar() {
        let rightItem = UIBarButtonItem.init(title: NSLocalizedString("选项", comment: ""), style: .plain, target: self, action: #selector(showOptions))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func showOptions() {
        let nav = BaseNavigationController(rootViewController: optionController)
        optionController.setting = setting
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true, completion: nil)
    }
    
    func reloadUI() {
        navigationItem.title = setting.dashboardType.description
        
        var options = LSOptions()
        if setting.actionMode == .afk {
            options.insert(.afk)
        }
        
        if setting.procMode == .optimistic1 || setting.procMode == .optimistic2 {
            options.insert(.optimistic)
        } else if setting.procMode == .pessimistic {
            options.insert(.pessimistic)
        }
        
        options.insert(.detailLog)
        
        if setting.procMode == .optimistic1 {
            simulator.simulateOptimistic1(options: options, callback: { [weak self] (result, logs) in
                self?.logs = logs
            })
        } else {
            simulator.simulateOnce(options: options, callback: { [weak self] (result, logs) in
                self?.logs = logs
            })
        }
        
        if setting.dashboardType == .score {
            scoreDashboard.tableView.isHidden = false
            supportDashboard.tableView.isHidden = true
        } else {
            scoreDashboard.tableView.isHidden = true
            supportDashboard.tableView.isHidden = false
        }
    }
}

extension LiveSimulatorViewController: LiveSimulatorModeSelectionViewControllerDelegate {
    func liveSimulatorModeSelectionViewController(_ liveSimulatorModeSelectionViewController: LiveSimulatorModeSelectionViewController, didSave setting: LiveSimulatorModeSelectionViewController.Setting) {
        self.setting = setting
        reloadUI()
    }
}

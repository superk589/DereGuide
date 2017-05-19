//
//  TeamSimulationController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import StoreKit

class TeamSimulationController: BaseTableViewController, PageCollectionControllerContainable, TeamCollecetionPage {
    
    var team: CGSSTeam! {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var simulatorType: CGSSLiveSimulatorType = .normal {
        didSet {
            tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: .automatic)
        }
    }
    
    var grooveType: CGSSGrooveType? {
        didSet {
            tableView.reloadRows(at: [IndexPath.init(row: 4, section: 0)], with: .automatic)
        }
    }
    
    var scene: CGSSLiveScene? {
        didSet {
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .automatic)
        }
    }
    
    lazy var liveSelectionViewController: TeamSongSelectViewController = {
        let vc = TeamSongSelectViewController()
        vc.delegate = self
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()

        tableView.register(TeamSimulationTeamCell.self, forCellReuseIdentifier: TeamSimulationTeamCell.description())
        tableView.register(TeamSimulationLiveSelectCell.self, forCellReuseIdentifier: TeamSimulationLiveSelectCell.description())

        tableView.register(TeamSimulationAppealEditingCell.self, forCellReuseIdentifier: TeamSimulationAppealEditingCell.description())
        tableView.register(TeamSimulationModeSelectionCell.self, forCellReuseIdentifier: TeamSimulationModeSelectionCell.description())
        tableView.register(TeamSimulationMainBodyCell.self, forCellReuseIdentifier: TeamSimulationMainBodyCell.description())
        tableView.register(TeamSimulationDescriptionCell.self, forCellReuseIdentifier: TeamSimulationDescriptionCell.description())
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamSimulationTeamCell.description(), for: indexPath) as! TeamSimulationTeamCell
            cell.setup(with: team)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamSimulationLiveSelectCell.description(), for: indexPath) as! TeamSimulationLiveSelectCell
            if let scene = scene {
                cell.setupWith(live: scene.live, difficulty: scene.difficulty)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamSimulationAppealEditingCell.description(), for: indexPath) as! TeamSimulationAppealEditingCell
            cell.setup(with: team)
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamSimulationModeSelectionCell.description(), for: indexPath) as! TeamSimulationModeSelectionCell
            cell.setup(with: NSLocalizedString("歌曲模式", comment: ""), rightDetail: simulatorType.description, rightColor: simulatorType.color)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamSimulationModeSelectionCell.description(), for: indexPath) as! TeamSimulationModeSelectionCell
            cell.setup(with: NSLocalizedString("Groove类别", comment: ""), rightDetail: grooveType?.description ?? "n/a", rightColor: grooveType?.color ?? Color.allType)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamSimulationMainBodyCell.description(), for: indexPath) as! TeamSimulationMainBodyCell
            cell.delegate = self
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamSimulationDescriptionCell.description(), for: indexPath) as! TeamSimulationDescriptionCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            if let team = self.team {
                let teamEditDVC = TeamEditViewController()
                teamEditDVC.delegate = self
                teamEditDVC.initWith(team)
                pageCollectionController?.navigationController?.pushViewController(teamEditDVC, animated: true)
            }
        case 1:
            pageCollectionController?.navigationController?.pushViewController(liveSelectionViewController, animated: true)
        case 3:
            let cell = tableView.cellForRow(at: indexPath)
            showActionSheetOfLiveModeSelection(at: cell as? TeamSimulationModeSelectionCell)
        case 4:
            if self.grooveType != nil {
                let cell = tableView.cellForRow(at: indexPath)
                showActionSheetOfGrooveTypeSelection(at: cell as? TeamSimulationModeSelectionCell)
            }
            
        default:
            break
        }

    }
    
    private func showActionSheetOfLiveModeSelection(at cell: TeamSimulationModeSelectionCell?) {
        let alvc = UIAlertController.init(title: NSLocalizedString("选择歌曲模式", comment: "弹出框标题"), message: nil, preferredStyle: .actionSheet)
        
        if let cell = cell {
            alvc.popoverPresentationController?.sourceView = cell.rightLabel
            alvc.popoverPresentationController?.sourceRect = CGRect(x: 0, y: cell.rightLabel.bounds.maxY / 2, width: 0, height: 0)
        } else {
            alvc.popoverPresentationController?.sourceView = tableView
            alvc.popoverPresentationController?.sourceRect = CGRect(x: tableView.frame.maxX / 2, y: tableView.frame.maxY / 2, width: 0, height: 0)
        }
        alvc.popoverPresentationController?.permittedArrowDirections = .right
        for simulatorType in CGSSLiveSimulatorType.all {
            alvc.addAction(UIAlertAction.init(title: simulatorType.description, style: .default, handler: { (a) in
                self.simulatorType = simulatorType
                if [.normal, .parade].contains(simulatorType) {
                    self.grooveType = nil
                } else if self.grooveType == nil {
                    self.grooveType = CGSSGrooveType.init(cardType: self.team.leader.cardRef?.cardType ?? .cute)
                }
            }))
        }
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "弹出框按钮"), style: .cancel, handler: nil))
        self.present(alvc, animated: true, completion: nil)
    }
    
    func showActionSheetOfGrooveTypeSelection(at cell: TeamSimulationModeSelectionCell?) {
        let alvc = UIAlertController.init(title: NSLocalizedString("选择Groove类别", comment: "弹出框标题"), message: nil, preferredStyle: .actionSheet)
        
        if let cell = cell {
            alvc.popoverPresentationController?.sourceView = cell.rightLabel
            alvc.popoverPresentationController?.sourceRect = CGRect(x: 0, y: cell.rightLabel.bounds.maxY / 2, width: 0, height: 0)
        } else {
            alvc.popoverPresentationController?.sourceView = tableView
            alvc.popoverPresentationController?.sourceRect = CGRect(x: tableView.frame.maxX / 2, y: tableView.frame.maxY / 2, width: 0, height: 0)
        }

        alvc.popoverPresentationController?.permittedArrowDirections = .right
        for grooveType in CGSSGrooveType.all {
            alvc.addAction(UIAlertAction.init(title: grooveType.rawValue, style: .default, handler: { (a) in
                self.grooveType = grooveType
            }))
        }
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "弹出框按钮"), style: .cancel, handler: nil))
        self.present(alvc, animated: true, completion: nil)
    }
       
}

extension TeamSimulationController: TeamEditViewControllerDelegate {
    func save(_ team: CGSSTeam) {
        let manager = CGSSTeamManager.default
        if let team = self.team, let index = manager.teams.index(of: team) {
            manager.teams.remove(at: index)
        }
        self.team = team
        manager.teams.insert(team, at: 0)
    }
}

extension TeamSimulationController: TeamSimulationTeamCellDelegate {
    func teamSimulationTeamCell(_ teamSimulationTeamCell: TeamSimulationTeamCell, didClick cardIcon: CGSSCardIconView) {
        if let id = cardIcon.cardId, let card = CGSSDAO.shared.findCardById(id) {
            let cardDVC = CardDetailViewController()
            cardDVC.card = card
            navigationController?.pushViewController(cardDVC, animated: true)
        }

    }
}

extension TeamSimulationController: BaseSongTableViewControllerDelegate {
    func baseSongTableViewController(_ baseSongTableViewController: BaseSongTableViewController, didSelect liveScene: CGSSLiveScene) {
        self.scene = liveScene
    }
}

extension TeamSimulationController: TeamSimulationAppealEditingCellDelegate {
    func teamSimulationAppealEditingCell(_ teamSimulationAppealEditingCell: TeamSimulationAppealEditingCell, didUpdateAt selectionIndex: Int, supportAppeal: Int, customAppeal: Int) {
        team.customAppeal = customAppeal
        team.supportAppeal = supportAppeal
        team.usingCustomAppeal = (selectionIndex == 1)
        CGSSTeamManager.default.save()
    }
}

extension TeamSimulationController: TeamSimulationMainBodyCellDelegate {
    
    private func showUnknownSkillAlert() {
        let alert = UIAlertController.init(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString("队伍中存在未知的技能类型，计算结果可能不准确。", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNotSelectSongAlert() {
        let alert = UIAlertController.init(title: NSLocalizedString("提示", comment: "弹出框标题"), message: NSLocalizedString("请先选择歌曲", comment: "弹出框正文"), preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func startSimulate(_ teamSimulationMainBodyCell: TeamSimulationMainBodyCell) {
        let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? TeamSimulationMainBodyCell
        
        func doSimulationBy(simulator: CGSSLiveSimulator, times: UInt) {
            simulator.simulate(times: times, progress: { (a, b) in
                DispatchQueue.main.async {
                    // self.teamDV.advanceProgress.progress = Float(a) / Float(b)
                    cell?.simulationButton.setTitle(NSLocalizedString("计算中...", comment: "") + "(\(String.init(format: "%d", a * 100 / b))%)", for: .normal)
                }
            }, callback: { (result, logs) in
                DispatchQueue.main.async {
                    cell?.setupSimulationResult(value1: result.get(percent: 1), value2: result.get(percent: 5), value3: result.get(percent: 20), value4: result.get(percent: 50))
                    cell?.resetSimulationButton()
                }
            })
        }
        
        if let scene = self.scene {
            cell?.clearSimulationGrid()
            if team.hasUnknownSkills() {
                showUnknownSkillAlert()
            }
            let coordinator = LSCoordinator.init(team: team, scene: scene, simulatorType: simulatorType, grooveType: grooveType, fixedAppeal: team.usingCustomAppeal ? team.customAppeal : nil)
            let simulator = coordinator.generateLiveSimulator()
            DispatchQueue.global(qos: .userInitiated).async {
                #if DEBUG
                    doSimulationBy(simulator: simulator, times: 500)
                #else
                    doSimulationBy(simulator: simulator, times: 10000)
                #endif
            }
        } else {
            showNotSelectSongAlert()
            cell?.resetSimulationButton()
        }
        
    }
    
    func startCalculate(_ teamSimulationMainBodyCell: TeamSimulationMainBodyCell) {
        let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? TeamSimulationMainBodyCell
        if let scene = self.scene {
            cell?.clearCalculationGrid()
            if team.hasUnknownSkills() {
                showUnknownSkillAlert()
            }
            let coordinator = LSCoordinator.init(team: team, scene: scene, simulatorType: simulatorType, grooveType: grooveType, fixedAppeal: team.usingCustomAppeal ? team.customAppeal : nil)
            let simulator = coordinator.generateLiveSimulator()
            let formulator = coordinator.generateLiveFormulator()
            cell?.setupAppeal(coordinator.fixedAppeal ?? coordinator.appeal)
            
            simulator.simulateOptimistic1(options: [], callback: { (result, logs) in
                cell?.setupCalculationResult(value1: coordinator.fixedAppeal ?? coordinator.appeal, value2: result.average, value3: formulator.maxScore, value4: formulator.averageScore)
                cell?.resetCalculationButton()
            })
            
            /// first time using calculator in team detail view controller, shows app store rating alert in app.
            if #available(iOS 10.3, *) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    if !UserDefaults.standard.hasRated {
                        SKStoreReviewController.requestReview()
                        UserDefaults.standard.hasRated = true
                    }
                })
            }
            
        } else {
            showNotSelectSongAlert()
            cell?.resetCalculationButton()
        }
    }
    
    func checkScoreDetail(_ teamSimulationMainBodyCell: TeamSimulationMainBodyCell) {
        if let scene = self.scene {
            let vc = LiveSimulatorViewController()
            let coordinator = LSCoordinator.init(team: team, scene: scene, simulatorType: simulatorType, grooveType: grooveType, fixedAppeal: team.usingCustomAppeal ? team.customAppeal : nil)
            vc.coordinator = coordinator
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showNotSelectSongAlert()
        }
    }
    
    func checkSupportSkillDetail(_ teamSimulationMainBodyCell: TeamSimulationMainBodyCell) {
        if let scene = self.scene {
            let vc = LiveSimulatorSupportSkillsViewController()
            let coordinator = LSCoordinator.init(team: team, scene: scene, simulatorType: simulatorType, grooveType: grooveType, fixedAppeal: team.usingCustomAppeal ? team.customAppeal : nil)
            vc.coordinator = coordinator
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showNotSelectSongAlert()
        }
    }
}


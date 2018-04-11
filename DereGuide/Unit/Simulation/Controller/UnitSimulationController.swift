//
//  UnitSimulationController.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import StoreKit
import CoreData

class UnitSimulationController: BaseTableViewController, UnitCollectionPage {
    
    var unit: Unit! {
        didSet {
            tableView?.reloadData()
            resetDataGrid()
        }
    }
    
    fileprivate func resetDataGrid() {
        let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? UnitSimulationMainBodyCell
        cell?.clearSimulationGrid()
        cell?.clearCalculationGrid()
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
    
    lazy var liveSelectionViewController: UnitSongSelectViewController = {
        let vc = UnitSongSelectViewController()
        vc.delegate = self
        return vc
    }()
    
    var simulationResult: LSResult?
    
    var afkModeResult: LSResult?
    
    weak var currentSimulator: LiveSimulator?
    
    deinit {
        currentSimulator?.cancelSimulating()
        afkModeSimulator?.cancelSimulating()
    }
    
    weak var afkModeSimulator: LiveSimulator?
    
    var titles = [NSLocalizedString("Note列表", comment: ""),
                  NSLocalizedString("高级计算", comment: ""),
                  NSLocalizedString("得分分布", comment: ""),
                  NSLocalizedString("高级选项", comment: "")]
   
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()

        tableView.register(UnitSimulationUnitCell.self, forCellReuseIdentifier: UnitSimulationUnitCell.description())
        tableView.register(UnitSimulationLiveSelectCell.self, forCellReuseIdentifier: UnitSimulationLiveSelectCell.description())

        tableView.register(UnitSimulationCommonCell.self, forCellReuseIdentifier: UnitSimulationCommonCell.description())
        tableView.register(UnitSimulationAppealEditingCell.self, forCellReuseIdentifier: UnitSimulationAppealEditingCell.description())
        tableView.register(UnitSimulationModeSelectionCell.self, forCellReuseIdentifier: UnitSimulationModeSelectionCell.description())
        tableView.register(UnitSimulationMainBodyCell.self, forCellReuseIdentifier: UnitSimulationMainBodyCell.description())
        tableView.register(UnitSimulationDescriptionCell.self, forCellReuseIdentifier: UnitSimulationDescriptionCell.description())
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if unit.hasChanges {
            unit.managedObjectContext?.saveOrRollback()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitSimulationUnitCell.description(), for: indexPath) as! UnitSimulationUnitCell
            cell.setup(with: unit)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitSimulationLiveSelectCell.description(), for: indexPath) as! UnitSimulationLiveSelectCell
            cell.setup(with: scene)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitSimulationAppealEditingCell.description(), for: indexPath) as! UnitSimulationAppealEditingCell
            cell.setup(with: unit)
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitSimulationModeSelectionCell.description(), for: indexPath) as! UnitSimulationModeSelectionCell
            cell.setup(with: NSLocalizedString("歌曲模式", comment: ""), rightDetail: simulatorType.description, rightColor: simulatorType.color)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitSimulationModeSelectionCell.description(), for: indexPath) as! UnitSimulationModeSelectionCell
            cell.setup(with: NSLocalizedString("Groove类别", comment: ""), rightDetail: grooveType?.description ?? "n/a", rightColor: grooveType?.color ?? .allType)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitSimulationMainBodyCell.description(), for: indexPath) as! UnitSimulationMainBodyCell
            cell.delegate = self
            return cell
        case 6...9:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitSimulationCommonCell.description(), for: indexPath) as! UnitSimulationCommonCell
            cell.setup(with: titles[indexPath.row - 6])
            return cell
        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitSimulationDescriptionCell.description(), for: indexPath) as! UnitSimulationDescriptionCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            if let unit = self.unit {
                let vc = UnitEditingController()
                vc.parentUnit = unit
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            navigationController?.pushViewController(liveSelectionViewController, animated: true)
        case 3:
            let cell = tableView.cellForRow(at: indexPath)
            showActionSheetOfLiveModeSelection(at: cell as? UnitSimulationModeSelectionCell)
        case 4:
            if self.grooveType != nil {
                let cell = tableView.cellForRow(at: indexPath)
                showActionSheetOfGrooveTypeSelection(at: cell as? UnitSimulationModeSelectionCell)
            }
        case 6:
            checkDetail()
        case 7:
            gotoAdvanceCalculation()
        case 8:
            checkScoreDistribution()
        case 9:
            let vc = UnitAdvanceOptionsController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func checkScoreDistribution() {
        if let result = self.simulationResult, result.scores.count > 0 {
            let vc = UnitSimulationScoreDistributionController(result: result)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            UIAlertController.showHintMessage(NSLocalizedString("至少进行一次模拟计算之后才能查看得分分布", comment: ""), in: nil)
        }
    }

    func checkDetail() {
        if let scene = self.scene {
            let vc = LiveSimulatorViewController()
            let coordinator = LiveCoordinator(unit: unit, scene: scene, simulatorType: simulatorType, grooveType: grooveType)
            vc.coordinator = coordinator
            vc.shouldSimulateWithDoubleHP = shouldSimulateWithDoubleHP
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showNotSelectSongAlert()
        }
    }
    
    func gotoAdvanceCalculation() {
        if let result = self.simulationResult, result.scores.count > 0, let scene = scene {
            let vc = UnitAdvanceCalculationController(result: result)
            let coordinator = LiveCoordinator.init(unit: unit, scene: scene, simulatorType: simulatorType, grooveType: grooveType)
            let formulator = coordinator.generateLiveFormulator()
            vc.formulator = formulator
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            UIAlertController.showHintMessage(NSLocalizedString("至少进行一次模拟计算之后才能进行高级计算", comment: ""), in: nil)
        }
    }
    
    private func showActionSheetOfLiveModeSelection(at cell: UnitSimulationModeSelectionCell?) {
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
                    self.grooveType = CGSSGrooveType.init(cardType: self.unit.leader.card?.cardType ?? .cute)
                }
            }))
        }
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "弹出框按钮"), style: .cancel, handler: nil))
        self.present(alvc, animated: true, completion: nil)
    }
    
    func showActionSheetOfGrooveTypeSelection(at cell: UnitSimulationModeSelectionCell?) {
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

extension UnitSimulationController: UnitEditingControllerDelegate {
    func unitEditingController(_ unitEditingController: UnitEditingController, didModify units: Set<Unit>) {
        if units.contains(self.unit) {
            if let vc = pageViewController as? UnitDetailController {
                vc.setNeedsReloadUnit()
                vc.reloadUnitIfNeeded()
            }
        }
    }
    
}

extension UnitSimulationController: UnitSimulationUnitCellDelegate {
    
    func unitSimulationUnitCell(_ unitSimulationUnitCell: UnitSimulationUnitCell, didClick cardIcon: CGSSCardIconView) {
        if let id = cardIcon.cardID, let card = CGSSDAO.shared.findCardById(id) {
            let cardDVC = CardDetailViewController()
            cardDVC.card = card
            navigationController?.pushViewController(cardDVC, animated: true)
        }

    }
    
}

extension UnitSimulationController: BaseSongTableViewControllerDelegate {
    
    func baseSongTableViewController(_ baseSongTableViewController: BaseLiveTableViewController, didSelect liveScene: CGSSLiveScene) {
        self.scene = liveScene
    }
}

extension UnitSimulationController: UnitSimulationAppealEditingCellDelegate {
    
    func unitSimulationAppealEditingCell(_ unitSimulationAppealEditingCell: UnitSimulationAppealEditingCell, didUpdateAt selectionIndex: Int, supportAppeal: Int, customAppeal: Int) {
        unit.customAppeal = Int64(customAppeal)
        unit.supportAppeal = Int64(supportAppeal)
        unit.usesCustomAppeal = (selectionIndex == 1)
        // save action cause tableView.reloadData(), delayed save to avoid cycling save
        // not save here
    }
}

extension UnitSimulationController: UnitSimulationMainBodyCellDelegate {
    
    func startAfkModeSimulating(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell) {
        let doSimulationBy = { [weak self] (simulator: LiveSimulator, times: UInt, scene: CGSSLiveScene) in
            simulator.simulate(times: times, options: .afk, progress: { (a, b) in
                DispatchQueue.main.async {
                    unitSimulationMainBodyCell.afkModeButton.setTitle(NSLocalizedString("计算中...", comment: "") + "(\(String.init(format: "%d", a * 100 / b))%)", for: .normal)
                }
            }, callback: { (result, logs) in
                DispatchQueue.main.async { [weak self] in
                    let survivalRate = 100 * Float(result.remainedLives.filter { $0 > 0 }.count) / Float(result.remainedLives.count)
                    let sRate = 100 * Float(result.scores.filter { $0 >= scene.sRankScore }.count) / Float(result.scores.count)
                    let maxScore = result.scores.max()
                    
                    unitSimulationMainBodyCell.setupAfkModeResult(value1: String(format: "%.2f", survivalRate), value2: String(format: "%.2f", sRate), value3: String(maxScore ?? 0))
                    //                    print(result.average)
                    unitSimulationMainBodyCell.stopAfkModeSimulationAnimating()
                    self?.afkModeResult = result
                }
            })
        }
        
        if let scene = self.scene {
            unitSimulationMainBodyCell.clearAfkModeGrid()
            unitSimulationMainBodyCell.startAfkModeSimulationAnimating()
            if unit.hasSkillType(.unknown) {
                showUnknownSkillAlert()
            }
            let coordinator = LiveCoordinator.init(unit: unit, scene: scene, simulatorType: simulatorType, grooveType: grooveType)
            let simulator = coordinator.generateLiveSimulator()
            afkModeSimulator = simulator
            DispatchQueue.global(qos: .userInitiated).async {
                #if DEBUG
                    doSimulationBy(simulator, 5000, scene)
                #else
                    doSimulationBy(simulator, UInt(LiveSimulationAdvanceOptionsManager.default.simulationTimes), scene)
                #endif
            }
        } else {
            showNotSelectSongAlert()
            unitSimulationMainBodyCell.stopSimulationAnimating()
        }
    }
    
    func cancelAfkModeSimulating(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell) {
        afkModeSimulator?.cancelSimulating()
    }
    

    fileprivate func showUnknownSkillAlert() {
        UIAlertController.showHintMessage(NSLocalizedString("队伍中存在未知的技能类型，计算结果可能不准确。", comment: ""), in: nil)
    }
    
    fileprivate func showNotSelectSongAlert() {
        UIAlertController.showHintMessage(NSLocalizedString("请先选择歌曲", comment: "弹出框正文"), in: nil)
    }
    
    private var shouldSimulateWithDoubleHP: Bool {
        return [CGSSLiveSimulatorType.visual, .dance, .vocal].contains(simulatorType) && unit.shouldHaveDoubleHPInGroove && LiveSimulationAdvanceOptionsManager.default.startGrooveWithDoubleHP
    }
    
    func startSimulate(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell) {
        let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? UnitSimulationMainBodyCell
        let options = shouldSimulateWithDoubleHP ? LSOptions.doubleHP : []

        let doSimulationBy = { [weak self] (simulator: LiveSimulator, times: UInt) in
            simulator.simulate(times: times, options: options, progress: { (a, b) in
                DispatchQueue.main.async {
                    cell?.simulationButton.setTitle(NSLocalizedString("计算中...", comment: "") + "(\(String.init(format: "%d", a * 100 / b))%)", for: .normal)
                }
            }, callback: { (result, logs) in
                DispatchQueue.main.async { [weak self] in
                    cell?.setupSimulationResult(value1: result.get(percent: 1), value2: result.get(percent: 5), value3: result.get(percent: 20), value4: result.get(percent: 50))
//                    print(result.average)
                    cell?.stopSimulationAnimating()
                    self?.simulationResult = result
                }
            })
        }
        
        if let scene = self.scene {
            cell?.clearSimulationGrid()
            cell?.startSimulationAnimating()
            if unit.hasSkillType(.unknown) {
                showUnknownSkillAlert()
            }
            let coordinator = LiveCoordinator.init(unit: unit, scene: scene, simulatorType: simulatorType, grooveType: grooveType)
            let simulator = coordinator.generateLiveSimulator()
            currentSimulator = simulator
            DispatchQueue.global(qos: .userInitiated).async {
                #if DEBUG
                    doSimulationBy(simulator, 5000)
                #else
                    doSimulationBy(simulator, UInt(LiveSimulationAdvanceOptionsManager.default.simulationTimes))
                #endif
            }
        } else {
            showNotSelectSongAlert()
            cell?.stopSimulationAnimating()
        }
        
    }
    
    func startCalculate(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell) {
        let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? UnitSimulationMainBodyCell
        if let scene = self.scene {
            cell?.clearCalculationGrid()
            if unit.hasSkillType(.unknown) {
                showUnknownSkillAlert()
            }
            
            let hasUnsupportedSkillType = unit.hasSkillType(.encore) || unit.hasSkillType(.lifeSparkle)
            let coordinator = LiveCoordinator.init(unit: unit, scene: scene, simulatorType: simulatorType, grooveType: grooveType)
            let simulator = coordinator.generateLiveSimulator()
            let formulator = coordinator.generateLiveFormulator()
            
            // setup appeal
            cell?.setupAppeal(coordinator.fixedAppeal ?? coordinator.appeal)

            // setup average
            if hasUnsupportedSkillType {
                cell?.calculationGrid[1, 3].text = "n/a"
            } else {
                cell?.calculationGrid[1, 3].text = String(formulator.averageScore)
            }
            
            var options = self.shouldSimulateWithDoubleHP ? LSOptions.doubleHP : []

            // setup optimistic 1
            simulator.simulateOptimistic1(options: options, callback: { (result, logs) in
                cell?.calculationGrid[1, 1].text = String(result.average)
            })
            
            simulator.wipeResults()
            
            options.insert(.optimistic)
            // setup optimistic 2
            simulator.simulateOnce(options: options, callback: { (result, logs) in
                cell?.calculationGrid[1, 2].text = String(result.average)
                cell?.resetCalculationButton()
            })
            
            /// first time using calculator in unit detail view controller, shows app store rating alert in app.
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
    
    func cancelSimulating(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell) {
        currentSimulator?.cancelSimulating()
    }
}

//
//  LiveSimulatorModeSelectionViewController.swift
//  DereGuide
//
//  Created by zzk on 23/02/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

protocol LiveSimulatorModeSelectionViewControllerDelegate: class {
    func liveSimulatorModeSelectionViewController(_ liveSimulatorModeSelectionViewController: LiveSimulatorModeSelectionViewController, didSave setting: LiveSimulatorModeSelectionViewController.Setting)
}

class LiveSimulatorModeSelectionViewController: UITableViewController {
    
    enum DashboardType: String, Codable, CustomStringConvertible {
        case score
        case support
        
        static var all: [DashboardType] = [.score, .support]
        
        var description: String {
            switch self {
            case .score:
                return NSLocalizedString("得分", comment: "")
            case .support:
                return NSLocalizedString("辅助技能", comment: "")
            }
        }
    }
    
    enum ActionMode: String, Codable, CustomStringConvertible {
        case ap
        case afk
        
        static var all: [ActionMode] = [.ap, .afk]
        
        var description: String {
            switch self {
            case .ap:
                return NSLocalizedString("全P", comment: "")
            case .afk:
                return NSLocalizedString("挂机", comment: "")
            }
        }
    }
    
    enum ProcMode: String, Codable, CustomStringConvertible {
        case random
        case optimistic1
        case optimistic2
        case pessimistic
        
        static var all: [ProcMode] = [.random, .optimistic1, .optimistic2, .pessimistic]
        
        var description: String {
            switch self {
            case .random:
                return NSLocalizedString("随机", comment: "")
            case .optimistic1:
                return NSLocalizedString("极限1", comment: "")
            case .optimistic2:
                return NSLocalizedString("极限2", comment: "")
            case .pessimistic:
                return NSLocalizedString("悲观", comment: "")
            }
        }
    }
    
    struct Setting: Codable {
        var dashboardType: DashboardType
        var procMode: ProcMode
        var actionMode: ActionMode
        
        func save() {
            try? JSONEncoder().encode(self).write(to: URL.init(fileURLWithPath: Path.document + "/simulatorDashboardSettings.json"))
        }
        
        static func load() -> Setting? {
            let decoder = JSONDecoder()
            guard let data = try? Data(contentsOf: URL.init(fileURLWithPath: Path.document + "/simulatorDashboardSettings.json")) else {
                return nil
            }
            let setting = try? decoder.decode(Setting.self, from: data)
            return setting
        }
        
        init() {
            dashboardType = .score
            procMode = .optimistic2
            actionMode = .ap
        }
    }

    weak var delegate: LiveSimulatorModeSelectionViewControllerDelegate?
    
    var setting = Setting.load() ?? Setting()
    
    struct Section {
        var title: String
        var items: [String]
        var rawValues: [String]
        var selectedIndex: Int
        var footer: String?
        
        var selectedRawValues: String {
            return rawValues[selectedIndex]
        }
    }
    
    private var sections = [Section]()
    
    private func prepareSections() {
        sections.removeAll()
        
        sections.append(Section(title: NSLocalizedString("表格类型", comment: ""), items: DashboardType.all.map { $0.description }, rawValues: DashboardType.all.map { $0.rawValue }, selectedIndex: DashboardType.all.index(of: setting.dashboardType) ?? 0, footer: nil))
        
        sections.append(Section(title: NSLocalizedString("动作模式", comment: ""), items: ActionMode.all.map { $0.description }, rawValues: ActionMode.all.map { $0.rawValue }, selectedIndex: ActionMode.all.index(of: setting.actionMode) ?? 0, footer: NSLocalizedString("* 全P模式中所有Note都为Perfect\n* 挂机模式中除非技能增强和SSR强判技能同时存在，所有Note都将丢失\n* 如果您在高级选项中设置了手动打前 x 秒或前 x combo，则指定范围的Note视为全P", comment: "")))
        
        sections.append(Section(title: NSLocalizedString("触发模式", comment: ""), items: ProcMode.all.map { $0.description }, rawValues: ProcMode.all.map { $0.rawValue }, selectedIndex: ProcMode.all.index(of: setting.procMode) ?? 2, footer: NSLocalizedString("* 随机模式中技能按照触发率随机触发\n* 极限1模式中所有Note取判定区间内的最大得分而且技能必定触发\n* 极限2模式中技能必定触发\n* 悲观模式中技能触发几率低于100%的技能必定不触发", comment: "")))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
        
        tableView.register(DashboardSettingTableViewCell.self, forCellReuseIdentifier: DashboardSettingTableViewCell.description())
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        prepareSections()
    }
    
    private func prepareNavigationBar() {
        navigationItem.title = NSLocalizedString("选项", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func done() {
        setting.dashboardType = DashboardType(rawValue: sections[0].selectedRawValues)!
        setting.actionMode = ActionMode(rawValue: sections[1].selectedRawValues)!
        setting.procMode = ProcMode(rawValue: sections[2].selectedRawValues)!
        setting.save()
        delegate?.liveSimulatorModeSelectionViewController(self, didSave: setting)
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardSettingTableViewCell.description(), for: indexPath) as! DashboardSettingTableViewCell
        
        let section = sections[indexPath.section]
        let title = section.items[indexPath.row]
        cell.setup(title: title, isSelected: indexPath.row == section.selectedIndex)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].selectedIndex = indexPath.row
        UIView.performWithoutAnimation {
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
    
}

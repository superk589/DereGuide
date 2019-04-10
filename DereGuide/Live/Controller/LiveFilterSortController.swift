//
//  LiveFilterSortController.swift
//  DereGuide
//
//  Created by zzk on 2017/1/13.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

protocol LiveFilterSortControllerDelegate: class {
    func doneAndReturn(filter: CGSSLiveFilter, sorter: CGSSSorter)
}

class LiveFilterSortController: BaseFilterSortController {

    weak var delegate: LiveFilterSortControllerDelegate?
    var filter: CGSSLiveFilter!
    var sorter: CGSSSorter!
    
    var songTypeTitles = ["Cute", "Cool", "Passion", NSLocalizedString("彩色曲", comment: "")]
    
    var difficultyTypeTitles = CGSSLiveDifficulty.all.map { $0.description }
    
    var eventTypeTitles = [NSLocalizedString("常规歌曲", comment: ""), NSLocalizedString("传统活动", comment: ""), NSLocalizedString("Groove活动", comment: ""), NSLocalizedString("巡演活动", comment: "")]
    
    
    var sorterMethods = ["updateId", "startDate", "bpm", "maxDiffStars", "maxNumberOfNotes", "sLength", "nameKana"]
    
    var sorterTitles = [NSLocalizedString("变更时间", comment: ""), NSLocalizedString("首次出现时间", comment: ""), "bpm", NSLocalizedString("难度", comment: ""), NSLocalizedString("note数", comment: ""), NSLocalizedString("时长", comment: ""), NSLocalizedString("五十音", comment: "")]
    
    var sorterOrderTitles = [NSLocalizedString("降序", comment: ""), NSLocalizedString("升序", comment: "")]
    
    var switchOption = SwitchOption()
    lazy var switchCell = UnitAdvanceOptionsTableViewCell.init(optionStyle: .switch(self.switchOption))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchOption.label.text = NSLocalizedString("隐藏难度文字", comment: "")
        switchCell.optionView.snp.remakeConstraints { (remake) in
            remake.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
    
    func reloadData() {
        self.tableView.reloadData()
        switchOption.switch.isOn = UserDefaults.standard.shouldHideDifficultyText
    }
    
    override func doneAction() {
        UserDefaults.standard.shouldHideDifficultyText = switchOption.switch.isOn
        delegate?.doneAndReturn(filter: filter, sorter: sorter)
        drawerController?.hide(animated: true)
    }
    
    override func resetAction() {
        filter = CGSSSorterFilterManager.DefaultFilter.live
        sorter = CGSSSorterFilterManager.DefaultSorter.live
        UserDefaults.standard.shouldHideDifficultyText = false
        switchOption.switch.isOn = UserDefaults.standard.shouldHideDifficultyText
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDelegate & DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        case 2:
            return 1
        default:
            fatalError("invalid section")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
            switch indexPath.row {
            case 0:
                cell.setup(titles: songTypeTitles, index: filter.liveTypes.rawValue, all: CGSSLiveTypes.allLives.rawValue)
            case 1:
                cell.setup(titles: difficultyTypeTitles, index: filter.difficultyTypes.rawValue, all: CGSSLiveDifficultyTypes.all.rawValue)
            case 2:
                cell.setup(titles: eventTypeTitles, index: filter.eventTypes.rawValue, all: CGSSLiveEventTypes.all.rawValue)
            default:
                break
            }
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortTableViewCell
            
            switch indexPath.row {
            case 0:
                cell.setup(titles: sorterOrderTitles)
                cell.presetIndex(index: sorter.ascending ? 1 : 0)
            case 1:
                cell.setup(titles: sorterTitles)
                if let index = sorterMethods.firstIndex(of: sorter.property) {
                    cell.presetIndex(index: UInt(index))
                }
            default:
                break
            }
            cell.delegate = self
            return cell
        case 2:
            return switchCell
        default:
            fatalError("invalid section")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("筛选", comment: "")
        case 1:
            return NSLocalizedString("排序", comment: "")
        case 2:
            return NSLocalizedString("选项", comment: "")
        default:
            fatalError("invalid section")
        }
    }
    
}


extension LiveFilterSortController: FilterTableViewCellDelegate {
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.liveTypes.insert(CGSSLiveTypes.init(rawValue: 1 << UInt(index)))
                case 1:
                    filter.difficultyTypes.insert(CGSSLiveDifficultyTypes.init(rawValue: 1 << UInt(index)))
                case 2:
                    filter.eventTypes.insert(CGSSLiveEventTypes.init(rawValue: 1 << UInt(index)))
                default:
                    break
                }
            }
        }
    }
    
    
    func filterTableViewCell(_ cell: FilterTableViewCell, didDeselect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.liveTypes.remove(CGSSLiveTypes.init(rawValue: 1 << UInt(index)))
                case 1:
                    filter.difficultyTypes.remove(CGSSLiveDifficultyTypes.init(rawValue: 1 << UInt(index)))
                case 2:
                    filter.eventTypes.remove(CGSSLiveEventTypes.init(rawValue: 1 << UInt(index)))
                default:
                    break
                }
            }
        }
    }
    
    func didSelectAll(filterTableViewCell cell: FilterTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.liveTypes = CGSSLiveTypes.allLives
                case 1:
                    filter.difficultyTypes = CGSSLiveDifficultyTypes.all
                case 2:
                    filter.eventTypes = CGSSLiveEventTypes.all
                default:
                    break
                }
            }
        }
    }
    func didDeselectAll(filterTableViewCell cell: FilterTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.liveTypes = []
                case 1:
                    filter.difficultyTypes = []
                case 2:
                    filter.eventTypes = []
                default:
                    break
                }
            }
        }
    }
}

extension LiveFilterSortController: SortTableViewCellDelegate {
    func sortTableViewCell(_ cell: SortTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    sorter.ascending = (index == 1)
                case 1:
                    sorter.property = sorterMethods[index]
                default:
                    break
                }
            }
        }
    }
}

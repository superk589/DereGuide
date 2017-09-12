//
//  SongFilterSortController.swift
//  DereGuide
//
//  Created by zzk on 04/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

protocol SongFilterSortControllerDelegate: class {
    func doneAndReturn(filter: CGSSSongFilter, sorter: CGSSSorter)
}

class SongFilterSortController: BaseFilterSortController {
    
    weak var delegate: SongFilterSortControllerDelegate?
    var filter: CGSSSongFilter!
    var sorter: CGSSSorter!
    
    var liveTypeTitles = ["Cute", "Cool", "Passion", NSLocalizedString("彩色曲", comment: "")]
    
    var eventTypes: [CGSSEventTypes] = [.tradition, .groove, .parade]
    
    lazy var eventTypeTitles = self.eventTypes.map { $0.description }
    
    var centerTypeTitles = ["Cute", "Cool", "Passion", NSLocalizedString("未指定", comment: "")]
    
    var favoriteTitles = [NSLocalizedString("已收藏", comment: ""),
                          NSLocalizedString("未收藏", comment: "")]
    
    var sorterMethods = ["liveID", "bpm"]
    
    var sorterTitles = [NSLocalizedString("首次出现时间", comment: ""), NSLocalizedString("bpm", comment: "")]
    
    var sorterOrderTitles = [NSLocalizedString("降序", comment: ""), NSLocalizedString("升序", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    override func doneAction() {
        delegate?.doneAndReturn(filter: filter, sorter: sorter)
        drawerController?.hide(animated: true)
        // 使用自定义动画效果
        /*let transition = CATransition()
         transition.duration = 0.3
         transition.type = kCATransitionReveal
         navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
         navigationController?.popViewControllerAnimated(false)*/
    }
    
    override func resetAction() {
        filter = CGSSSorterFilterManager.DefaultFilter.song
        sorter = CGSSSorterFilterManager.DefaultSorter.song
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDelegate & DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 4
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
            switch indexPath.row {
            case 0:
                cell.setup(titles: liveTypeTitles, index: filter.liveTypes.rawValue, all: CGSSLiveTypes.all.rawValue)
            case 1:
                var selected = [Int]()
                if eventTypes.contains(.tradition) { selected.append(0) }
                if eventTypes.contains(.groove) { selected.append(1) }
                if eventTypes.contains(.parade) { selected.append(2) }
                cell.setup(titles: eventTypeTitles, selected: selected)
            case 2:
                cell.setup(titles: centerTypeTitles, index: filter.centerTypes.rawValue, all: CGSSLiveTypes.all.rawValue)
            case 3:
                cell.setup(titles: favoriteTitles, index: filter.favoriteTypes.rawValue, all: CGSSFavoriteTypes.all.rawValue)
            default:
                break
            }
            cell.delegate = self
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortTableViewCell
            
            switch indexPath.row {
            case 0:
                cell.setup(titles: sorterOrderTitles)
                cell.presetIndex(index: sorter.ascending ? 1 : 0)
            case 1:
                cell.setup(titles: sorterTitles)
                if let index = sorterMethods.index(of: sorter.property) {
                    cell.presetIndex(index: UInt(index))
                }
            default:
                break
            }
            cell.delegate = self
            return cell
        }
    }
    
}


extension SongFilterSortController: FilterTableViewCellDelegate {
    
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.liveTypes.insert(CGSSLiveTypes.init(type: index))
                case 1:
                    filter.eventTypes.insert(eventTypes[index])
                case 2:
                    filter.centerTypes.insert(CGSSCardTypes.init(type: index))
                case 3:
                    filter.favoriteTypes.insert(CGSSFavoriteTypes.init(rawValue: 1 << UInt(index)))
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
                    filter.liveTypes.remove(CGSSLiveTypes.init(type: index))
                case 1:
                    filter.eventTypes.remove(eventTypes[index])
                case 2:
                    filter.centerTypes.remove(CGSSCardTypes.init(type: index))
                case 3:
                    filter.favoriteTypes.remove(CGSSFavoriteTypes.init(rawValue: 1 << UInt(index)))
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
                    filter.liveTypes = .all
                case 1:
                    filter.eventTypes = CGSSEventTypes.init(rawValue: eventTypes.reduce(0, {$0 + $1.rawValue}))
                case 2:
                    filter.centerTypes = .all
                case 3:
                    filter.favoriteTypes = .all
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
                    filter.eventTypes = []
                case 2:
                    filter.centerTypes = []
                case 3:
                    filter.favoriteTypes = []
                default:
                    break
                }
                
            }
        }
    }
}

extension SongFilterSortController: SortTableViewCellDelegate {
    
    func sortTableViewCell(_ cell: SortTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    sorter.ascending = (index == 1)
                case 1:
                    sorter.property = sorterMethods[index]
                    sorter.displayName = sorterTitles[index]
                default:
                    break
                }
            }
        }
    }
    
}


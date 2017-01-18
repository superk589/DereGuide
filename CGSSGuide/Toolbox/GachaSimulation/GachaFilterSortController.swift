//
//  GachaFilterSortController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol GachaFilterSortControllerDelegate: class {
    func doneAndReturn(filter: CGSSGachaFilter, sorter: CGSSSorter)
}

class GachaFilterSortController: BaseFilterSortController {
    
    var filter: CGSSGachaFilter!
    
    var sorter: CGSSSorter!
    
    
    weak var delegate: GachaFilterSortControllerDelegate?
    
    var gachaTypeTitles = [CGSSGachaTypes.normal.toString(),
                           CGSSGachaTypes.limit.toString(),
                           CGSSGachaTypes.fes.toString(),
                           CGSSGachaTypes.singleType.toString()]
    
    var sorterTitles = [NSLocalizedString("更新时间", comment: "")]
    var sorterMethods = ["id"]
    var sorterOrderTitles = [NSLocalizedString("降序", comment: ""), NSLocalizedString("升序", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func doneAction() {
        delegate?.doneAndReturn(filter: filter, sorter: sorter)
        CGSSClient.shared.drawerController?.hide(animated: true)
    }
    
    override func resetAction() {
        filter = CGSSSorterFilterManager.DefaultFilter.gachaPool
        sorter = CGSSSorterFilterManager.DefaultSorter.gachaPool
        tableView.reloadData()
    }
    
    // MARK: - TableViewDelegate & DataSource
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("筛选", comment: "")
        } else {
            return NSLocalizedString("排序", comment: "")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
            switch indexPath.row {
            case 0:
                cell.setup(titles: gachaTypeTitles, index: filter.gachaTypes.rawValue, all: CGSSGachaTypes.all.rawValue)
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


extension GachaFilterSortController: FilterTableViewCellDelegate {
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.gachaTypes.insert(CGSSGachaTypes.init(rawValue: 1 << UInt(index)))
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
                    filter.gachaTypes.remove(CGSSGachaTypes.init(rawValue: 1 << UInt(index)))
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
                    filter.gachaTypes = .all
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
                    filter.gachaTypes = CGSSGachaTypes.init(rawValue: 0)
                default:
                    break
                }
            }
        }
    }
    
}

extension GachaFilterSortController: SortTableViewCellDelegate {
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


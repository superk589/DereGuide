//
//  CharFilterSortController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/13.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
protocol CharFilterSortControllerDelegate: class {
    func doneAndReturn(filter: CGSSCharFilter, sorter: CGSSSorter)
}

class CharFilterSortController: BaseFilterSortController {
    
    weak var delegate: CharFilterSortControllerDelegate?
    var filter: CGSSCharFilter!
    var sorter: CGSSSorter!
    
    var charTypeTitles = ["Cute", "Cool", "Passion"]
    
    var charCVTitles = [NSLocalizedString("已付声", comment: ""), NSLocalizedString("未付声", comment: "")]
    var charAgeTitles = [NSLocalizedString("年龄", comment: "") + "<10", "10-19", "20-29", "30~", NSLocalizedString("未知", comment: "")]
    var charBloodTitles = [NSLocalizedString("血型", comment: "") + "A", "B", "AB", "O"]
    var favoriteTitles = [NSLocalizedString("已收藏", comment: ""),
                          NSLocalizedString("未收藏", comment: "")]

    var sorterMethods = ["sHeight", "sWeight", "BMI", "sAge", "sizeB", "sizeW", "sizeH", "sName", "sCharaId", "sBirthday"]
    
    var sorterTitles = [NSLocalizedString("身高", comment: ""), NSLocalizedString("体重", comment: ""), "BMI", NSLocalizedString("年龄", comment: ""), "B", "W", "H", NSLocalizedString("五十音", comment: ""), NSLocalizedString("游戏编号", comment: ""), NSLocalizedString("生日", comment: "")]
    
    var sorterOrderTitles = [NSLocalizedString("降序", comment: ""), NSLocalizedString("升序", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    override func doneAction() {
        delegate?.doneAndReturn(filter: filter, sorter: sorter)
        CGSSClient.shared.drawerController?.hide(animated: true)
        // 使用自定义动画效果
        /*let transition = CATransition()
         transition.duration = 0.3
         transition.type = kCATransitionReveal
         navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
         navigationController?.popViewControllerAnimated(false)*/
    }
    
    override func resetAction() {
        filter = CGSSCharFilter.init(typeMask: 0b111, ageMask: 0b11111, bloodMask: 0b11111, cvMask: 0b11, favoriteMask: 0b11)
        sorter = CGSSSorter.init(property: "sName", ascending: true)
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
            return 5
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
            switch indexPath.row {
            case 0:
                cell.setup(titles: charTypeTitles, index: filter.charTypes.rawValue, all: CGSSCharTypes.all.rawValue)
            case 1:
                cell.setup(titles: charCVTitles, index: filter.charCVTypes.rawValue, all: CGSSCharCVTypes.all.rawValue)
            case 2:
                cell.setup(titles: charAgeTitles, index: filter.charAgeTypes.rawValue, all: CGSSCharAgeTypes.all.rawValue)
            case 3:
                cell.setup(titles: charBloodTitles, index: filter.charBloodTypes.rawValue, all: CGSSCharBloodTypes.all.rawValue)
            case 4:
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


extension CharFilterSortController: FilterTableViewCellDelegate {
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.charTypes.insert(CGSSCharTypes.init(type: index))
                case 1:
                    filter.charCVTypes.insert(CGSSCharCVTypes.init(rawValue: 1 << UInt(index)))
                case 2:
                    filter.charAgeTypes.insert(CGSSCharAgeTypes.init(rawValue: 1 << UInt(index)))
                case 3:
                    filter.charBloodTypes.insert(CGSSCharBloodTypes.init(rawValue: 1 << UInt(index)))
                case 4:
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
                    filter.charTypes.remove(CGSSCharTypes.init(type: index))
                case 1:
                    filter.charCVTypes.remove(CGSSCharCVTypes.init(rawValue: 1 << UInt(index)))
                case 2:
                    filter.charAgeTypes.remove(CGSSCharAgeTypes.init(rawValue: 1 << UInt(index)))
                case 3:
                    filter.charBloodTypes.remove(CGSSCharBloodTypes.init(rawValue: 1 << UInt(index)))
                case 4:
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
                    filter.charTypes = .all
                case 1:
                    filter.charCVTypes = .all
                case 2:
                    filter.charAgeTypes = .all
                case 3:
                    filter.charBloodTypes = .all
                case 4:
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
                    filter.charTypes = CGSSCharTypes.init(rawValue: 0)
                case 1:
                    filter.charCVTypes = CGSSCharCVTypes.init(rawValue: 0)
                case 2:
                    filter.charAgeTypes = CGSSCharAgeTypes.init(rawValue: 0)
                case 3:
                    filter.charBloodTypes = CGSSCharBloodTypes.init(rawValue: 0)
                case 4:
                    filter.favoriteTypes = CGSSFavoriteTypes.init(rawValue: 0)
                default:
                    break
                }
                
            }
        }
    }
}

extension CharFilterSortController: SortTableViewCellDelegate {
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

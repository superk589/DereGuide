//
//  CardFilterSortController.swift
//  DereGuide
//
//  Created by zzk on 2017/1/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
protocol CardFilterSortControllerDelegate: class {
    func doneAndReturn(filter: CGSSCardFilter, sorter: CGSSSorter)
}

class CardFilterSortController: BaseFilterSortController {
    
    weak var delegate: CardFilterSortControllerDelegate?
    var filter: CGSSCardFilter!
    var sorter: CGSSSorter!
    
    var rarityTitles = ["N", "N+", "R", "R+", "SR", "SR+", "SSR", "SSR+"]
   
    var cardTypeTitles = ["Cute", "Cool", "Passion"]
    
    var attributeTitles = ["Vocal", "Dance", "Visual"]
    
    var skillTypeTitles = [
        CGSSSkillTypes.comboBonus.description,
        CGSSSkillTypes.perfectBonus.description,
        CGSSSkillTypes.overload.description,
        CGSSSkillTypes.perfectLock.description,
        CGSSSkillTypes.comboContinue.description,
        CGSSSkillTypes.heal.description,
        CGSSSkillTypes.guard.description,
        CGSSSkillTypes.concentration.description,
        CGSSSkillTypes.boost.description,
        CGSSSkillTypes.allRound.description,
        CGSSSkillTypes.deep.description,
        CGSSSkillTypes.encore.description,
        CGSSSkillTypes.lifeSparkle.description,
        CGSSSkillTypes.unknown.description,
        CGSSSkillTypes.none.description
    ]
    
    var procTitles = [CGSSProcTypes.high.description,
                     CGSSProcTypes.middle.description,
                     CGSSProcTypes.low.description,
                     CGSSProcTypes.none.description]
    
    var conditionTitles = [CGSSConditionTypes.c4.description,
                           CGSSConditionTypes.c6.description,
                           CGSSConditionTypes.c7.description,
                           CGSSConditionTypes.c9.description,
                           CGSSConditionTypes.c11.description,
                           CGSSConditionTypes.c13.description,
                           CGSSConditionTypes.other.description]
    
    var availableTitles = [CGSSAvailableTypes.fes.description,
                           CGSSAvailableTypes.limit.description,
                           CGSSAvailableTypes.normal.description,
                           CGSSAvailableTypes.event.description,
                           CGSSAvailableTypes.free.description]
    
    var favoriteTitles = [NSLocalizedString("已收藏", comment: ""),
                          NSLocalizedString("未收藏", comment: "")]
    
    var sorterTitles = ["Total", "Vocal", "Dance", "Visual", NSLocalizedString("更新时间", comment: ""), NSLocalizedString("稀有度", comment: ""), NSLocalizedString("相册编号", comment: "")]
    var sorterMethods = ["overall", "vocal", "dance", "visual", "update_id", "sRarity", "sAlbumId"]
    
    var sorterOrderTitles = [NSLocalizedString("降序", comment: ""), NSLocalizedString("升序", comment: "")]
    
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
        if delegate is CardTableViewController {
            filter = CGSSSorterFilterManager.DefaultFilter.card
            sorter = CGSSSorterFilterManager.DefaultSorter.card
        } else if delegate is UnitCardSelectTableViewController {
            filter = CGSSSorterFilterManager.DefaultFilter.unitCard
            sorter = CGSSSorterFilterManager.DefaultSorter.unitCard
        } else {
            filter = CGSSSorterFilterManager.DefaultFilter.gacha
            sorter = CGSSSorterFilterManager.DefaultSorter.gacha
        }
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
            return 8
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
            switch indexPath.row {
            case 0:
                cell.setup(titles: rarityTitles, index: filter.rarityTypes.rawValue, all: CGSSRarityTypes.all.rawValue)
            case 1:
                cell.setup(titles: cardTypeTitles, index: filter.cardTypes.rawValue, all: CGSSCardTypes.all.rawValue)
            case 2:
                cell.setup(titles: attributeTitles, index: filter.attributeTypes.rawValue, all: CGSSAttributeTypes.all.rawValue)
            case 3:
                cell.setup(titles: skillTypeTitles, index: filter.skillTypes.rawValue, all: CGSSSkillTypes.all.rawValue)
            case 4:
                cell.setup(titles: procTitles, index: filter.procTypes.rawValue, all: CGSSProcTypes.all.rawValue)
            case 5:
                cell.setup(titles: conditionTitles, index: filter.conditionTypes.rawValue, all: CGSSConditionTypes.all.rawValue)
            case 6:
                cell.setup(titles: availableTitles, index: filter.gachaTypes.rawValue, all: CGSSAvailableTypes.all.rawValue)
            case 7:
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


extension CardFilterSortController: FilterTableViewCellDelegate {
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.rarityTypes.insert(CGSSRarityTypes.init(rarity: index))
                case 1:
                    filter.cardTypes.insert(CGSSCardTypes.init(type: index))
                case 2:
                    filter.attributeTypes.insert(CGSSAttributeTypes.init(type: index))
                case 3:
                    filter.skillTypes.insert(CGSSSkillTypes.init(rawValue: 1 << UInt(index)))
                case 4:
                    filter.procTypes.insert(CGSSProcTypes.init(rawValue: 1 << UInt(index)))
                case 5:
                    filter.conditionTypes.insert(CGSSConditionTypes.init(rawValue: 1 << UInt(index)))
                case 6:
                    filter.gachaTypes.insert(CGSSAvailableTypes.init(rawValue: 1 << UInt(index)))
                case 7:
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
                    filter.rarityTypes.remove(CGSSRarityTypes.init(rarity: index))
                case 1:
                    filter.cardTypes.remove(CGSSCardTypes.init(type: index))
                case 2:
                    filter.attributeTypes.remove(CGSSAttributeTypes.init(type: index))
                case 3:
                    filter.skillTypes.remove(CGSSSkillTypes.init(rawValue: 1 << UInt(index)))
                case 4:
                    filter.procTypes.remove(CGSSProcTypes.init(rawValue: 1 << UInt(index)))
                case 5:
                    filter.conditionTypes.remove(CGSSConditionTypes.init(rawValue: 1 << UInt(index)))
                case 6:
                    filter.gachaTypes.remove(CGSSAvailableTypes.init(rawValue: 1 << UInt(index)))
                case 7:
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
                    filter.rarityTypes = CGSSRarityTypes.all
                case 1:
                    filter.cardTypes = CGSSCardTypes.all
                case 2:
                    filter.attributeTypes = CGSSAttributeTypes.all
                case 3:
                    filter.skillTypes = CGSSSkillTypes.all
                case 4:
                    filter.procTypes = CGSSProcTypes.all
                case 5:
                    filter.conditionTypes = CGSSConditionTypes.all
                case 6:
                    filter.gachaTypes = .all
                case 7:
                    filter.favoriteTypes = CGSSFavoriteTypes.all
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
                    filter.rarityTypes = CGSSRarityTypes.init(rawValue: 0)
                case 1:
                    filter.cardTypes = CGSSCardTypes.init(rawValue: 0)
                case 2:
                    filter.attributeTypes = CGSSAttributeTypes.init(rawValue: 0)
                case 3:
                    filter.skillTypes = CGSSSkillTypes.init(rawValue: 0)
                case 4:
                    filter.procTypes = CGSSProcTypes.init(rawValue: 0)
                case 5:
                    filter.conditionTypes = CGSSConditionTypes.init(rawValue: 0)
                case 6:
                    filter.gachaTypes = CGSSAvailableTypes.init(rawValue: 0)
                case 7:
                    filter.favoriteTypes = CGSSFavoriteTypes.init(rawValue: 0)
                default:
                    break
                }
            }
        }
    }
    
}

extension CardFilterSortController: SortTableViewCellDelegate {
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

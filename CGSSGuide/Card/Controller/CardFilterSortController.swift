//
//  CardFilterSortController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
protocol CardFilterSortControllerDelegate: class {
    func doneAndReturn(filter: CGSSCardFilter, sorter: CGSSSorter)
}

class CardFilterSortController: BaseFilterSortController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    weak var delegate: CardFilterSortControllerDelegate?
    var filter: CGSSCardFilter!
    var sorter: CGSSSorter!
    
    var rarityTitles = ["N", "N+", "R", "R+", "SR", "SR+", "SSR", "SSR+"]
   
    var cardTypeTitles = ["Cute", "Cool", "Passion"]
    
    var attributeTitles = ["Vocal", "Dance", "Visual"]
    
    var skillTypeTitles = [
        CGSSSkillTypes.comboBonus.toString(),
        CGSSSkillTypes.perfectBonus.toString(),
        CGSSSkillTypes.overload.toString(),
        CGSSSkillTypes.perfectLock.toString(),
        CGSSSkillTypes.comboContinue.toString(),
        CGSSSkillTypes.heal.toString(),
        CGSSSkillTypes.guard.toString(),
        CGSSSkillTypes.none.toString()
    ]
    
    var favoriteTitles = [NSLocalizedString("已收藏", comment: ""),
                          NSLocalizedString("未收藏", comment: "")]
    
    var sorterTitles = ["Total", "Vocal", "Dance", "Visual", NSLocalizedString("更新时间", comment: ""), NSLocalizedString("稀有度", comment: ""), NSLocalizedString("相册编号", comment: "")]
    var sorterMethods = ["overall", "vocal", "dance", "visual", "update_id", "sRarity", "sAlbumId"]
    
    var sorterOrderTitles = [NSLocalizedString("降序", comment: ""), NSLocalizedString("升序", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
    }
    
    func prepareUI() {
        
        tableView = UITableView()
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.register(SortTableViewCell.self, forCellReuseIdentifier: "SortCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 44, right: 0)
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.estimatedRowHeight = 50
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(20)
        }
        
        view.bringSubview(toFront: toolbar)
        
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
        if delegate is CardTableViewController {
            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, skillMask: 0b111111111, gachaMask: 0b1111, favoriteMask: nil)
            sorter = CGSSSorter.init(property: "update_id")
        } else if delegate is TeamCardSelectTableViewController {
            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b10100000, skillMask: 0b000000111, gachaMask: 0b1111, favoriteMask: nil)
            sorter = CGSSSorter.init(property: "update_id")
        } else {
            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11111111, skillMask: 0b111111111, gachaMask: 0b1111, favoriteMask: nil)
            sorter = CGSSSorter.init(property: "sRarity")
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDelegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("筛选", comment: "")
        } else {
            return NSLocalizedString("排序", comment: "")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 5
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
            switch indexPath.row {
            case 0:
                cell.setup(titles: rarityTitles)
                cell.presetIndex(index: filter.rarityTypes.rawValue)
            case 1:
                cell.setup(titles: cardTypeTitles)
                cell.presetIndex(index: filter.cardTypes.rawValue)
            case 2:
                cell.setup(titles: attributeTitles)
                cell.presetIndex(index: filter.attributeTypes.rawValue)
            case 3:
                cell.setup(titles: skillTypeTitles)
                cell.presetIndex(index: filter.skillTypes.rawValue)
            case 4:
                cell.setup(titles: favoriteTitles)
                cell.presetIndex(index: filter.favoriteTypes.rawValue)
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
                    filter.favoriteTypes.remove(CGSSFavoriteTypes.init(rawValue: 1 << UInt(index)))
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

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

class CardFilterSortController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var orderView: SortOrderView!
    var attributeSorterView: SortView!
    var otherSorterView: SortView!
    
    weak var delegate: CardFilterSortControllerDelegate?
    var filter: CGSSCardFilter!
    var sorter: CGSSSorter!
    
    var rarityTitles = ["SSR+", "SSR", "SR+", "SR", "R+", "R", "N+", "N"]
    var rarityColors = Array<UIColor>.init(repeating: Color.parade, count: 8)
    
    var cardTypeTitles = ["Cute", "Cool", "Passion"]
    var cardTypeColors = [Color.cute, Color.cool, Color.passion]
    
    var attributeTitles = ["Vocal", "Dance", "Visual"]
    var attributeColors = [Color.vocal, Color.dance, Color.visual]
    
    var skillTypeColors = Array<UIColor>.init(repeating: Color.parade, count: 8)
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
    var favoriteColors = [Color.parade, Color.parade]
    
    
    var sorterTitles = ["vocal", "dance", "visual", "overall", "update_id", "sRarity", "sAlbumId"]
    var sorterColors = [Color.vocal, Color.dance, Color.visual, Color.allType, Color.parade, Color.parade, Color.parade]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNaviBar()
        prepareUI()
        setupUI()
        
    }
    
    func prepareNaviBar() {
        let backButton = UIBarButtonItem.init(title: NSLocalizedString("完成", comment: "导航栏按钮"), style: .plain, target: self, action: #selector(doneAction))
        self.navigationItem.leftBarButtonItem = backButton
        
        let resetButton = UIBarButtonItem.init(title: NSLocalizedString("重置", comment: "导航栏按钮"), style: .plain, target: self, action: #selector(resetAction))
        self.navigationItem.rightBarButtonItem = resetButton
    }
    
    func setupUI() {
        
    }
    
    func prepareUI() {
        
        tableView = UITableView()
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.delegate = self
        tableView.dataSource = self
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Screen.width, height: 20))
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    func doneAction() {
        delegate?.doneAndReturn(filter: filter, sorter: sorter)
        _ = self.navigationController?.popViewController(animated: true)
        // 使用自定义动画效果
        /*let transition = CATransition()
         transition.duration = 0.3
         transition.type = kCATransitionReveal
         navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
         navigationController?.popViewControllerAnimated(false)*/
    }
    
    func resetAction() {
        if delegate is CardTableViewController {
            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, skillMask: 0b111111111, gachaMask: 0b1111, favoriteMask: nil)
            sorter = CGSSSorter.init(att: "update_id")
        } else if delegate is TeamCardSelectTableViewController {
            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b10100000, skillMask: 0b000000111, gachaMask: 0b1111, favoriteMask: nil)
            sorter = CGSSSorter.init(att: "update_id")
        } else {
            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11111111, skillMask: 0b111111111, gachaMask: 0b1111, favoriteMask: nil)
            sorter = CGSSSorter.init(att: "sRarity")
        }
        setupUI()
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
            return "筛选"
        } else {
            return "排序"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 5
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
            switch indexPath.row {
            case 0:
                cell.setup(titles: rarityTitles, colors: rarityColors)
                cell.presetIndex(index: filter.rarityTypes.rawValue)
            case 1:
                cell.setup(titles: cardTypeTitles, colors: cardTypeColors)
                cell.presetIndex(index: filter.cardTypes.rawValue)
            case 2:
                cell.setup(titles: attributeTitles, colors: attributeColors)
                cell.presetIndex(index: filter.attributeTypes.rawValue)
            case 3:
                cell.setup(titles: skillTypeTitles, colors: skillTypeColors)
                cell.presetIndex(index: filter.skillTypes.rawValue)
            case 4:
                cell.setup(titles: favoriteTitles, colors: favoriteColors)
                cell.presetIndex(index: filter.favoriteTypes.rawValue)
            default:
                break
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }

}


extension CardFilterSortController: FilterTableViewCellDelegate {
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.rarityTypes.insert(CGSSRarityTypes.init(rarity: 7 - index))
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
                    filter.rarityTypes.remove(CGSSRarityTypes.init(rarity: 7 - index))
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

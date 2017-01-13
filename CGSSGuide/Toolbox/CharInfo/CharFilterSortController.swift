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

class CharFilterSortController: BaseFilterSortController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
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
        filter = CGSSCharFilter.init(typeMask: 0b111, ageMask: 0b11111, bloodMask: 0b11111, cvMask: 0b11, favoriteMask: 0b11)
        sorter = CGSSSorter.init(att: "sName", ascending: true)
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
                cell.setup(titles: charTypeTitles)
                cell.presetIndex(index: filter.charTypes.rawValue)
            case 1:
                cell.setup(titles: charCVTitles)
                cell.presetIndex(index: filter.charCVTypes.rawValue)
            case 2:
                cell.setup(titles: charAgeTitles)
                cell.presetIndex(index: filter.charAgeTypes.rawValue)
            case 3:
                cell.setup(titles: charBloodTitles)
                cell.presetIndex(index: filter.charBloodTypes.rawValue)
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
                if let index = sorterMethods.index(of: sorter.att) {
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
    
}

extension CharFilterSortController: SortTableViewCellDelegate {
    func sortTableViewCell(_ cell: SortTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    sorter.ascending = (index == 1)
                case 1:
                    sorter.att = sorterMethods[index]
                default:
                    break
                }
            }
        }
    }
}

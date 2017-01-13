//
//  SongFilterSortController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/13.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol SongFilterSortControllerDelegate: class {
    func doneAndReturn(filter: CGSSSongFilter, sorter: CGSSSorter)
}

class SongFilterSortController: BaseFilterSortController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    weak var delegate: SongFilterSortControllerDelegate?
    var filter: CGSSSongFilter!
    var sorter: CGSSSorter!
    
    var songTypeTitles = ["Cute", "Cool", "Passion", "All"]
    
    var eventTypeTitles = [NSLocalizedString("常规歌曲", comment: ""), NSLocalizedString("传统活动", comment: ""), NSLocalizedString("Groove活动", comment: ""), NSLocalizedString("LIVE Parade", comment: "")]
    
    
    var sorterMethods = ["updateId", "bpm", "maxDiffStars"]
    
    var sorterTitles = [NSLocalizedString("更新时间", comment: ""), "bpm", NSLocalizedString("最大难度", comment: "")]
    
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
        filter = CGSSSongFilter.init(typeMask: 0b1111, eventMask: 0b1111)
        sorter = CGSSSorter.init(att: "updateId")
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
            return 2
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterTableViewCell
            switch indexPath.row {
            case 0:
                cell.setup(titles: songTypeTitles)
                cell.presetIndex(index: filter.songTypes.rawValue)
            case 1:
                cell.setup(titles: eventTypeTitles)
                cell.presetIndex(index: filter.eventTypes.rawValue)
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


extension SongFilterSortController: FilterTableViewCellDelegate {
    func filterTableViewCell(_ cell: FilterTableViewCell, didSelect index: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    filter.songTypes.insert(CGSSSongTypes.init(rawValue: 1 << UInt(index)))
                case 1:
                    filter.eventTypes.insert(CGSSSongEventTypes.init(rawValue: 1 << UInt(index)))
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
                    filter.songTypes.remove(CGSSSongTypes.init(rawValue: 1 << UInt(index)))
                case 1:
                    filter.eventTypes.remove(CGSSSongEventTypes.init(rawValue: 1 << UInt(index)))
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
                    sorter.att = sorterMethods[index]
                default:
                    break
                }
            }
        }
    }
}

//
//  GachaCardTableViewController.swift
//  DereGuide
//
//  Created by zzk on 2016/9/16.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class GachaCardTableViewController: BaseCardTableViewController {
    
    var _filter: CGSSCardFilter = CGSSSorterFilterManager.DefaultFilter.gacha
    var _sorter: CGSSSorter = CGSSSorterFilterManager.DefaultSorter.gacha
    
    override var filter: CGSSCardFilter {
        get {
            return _filter
        }
        set {
            _filter = newValue
        }
    }
    override var sorter: CGSSSorter {
        get {
            return _sorter
        }
        set {
            _sorter = newValue
        }
    }
    
    override var filterVC: CardFilterSortController {
        set {
            _filterVC = newValue as! GachaCardFilterSortController
        }
        get {
            return _filterVC
        }
    }
    
    lazy var _filterVC: GachaCardFilterSortController = {
        let vc = GachaCardFilterSortController()
        vc.filter = self.filter
        vc.sorter = self.sorter
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        leftItem.width = 44
        navigationItem.leftBarButtonItem = leftItem

        self.tableView.register(GachaCardTableViewCell.self, forCellReuseIdentifier: GachaCardTableViewCell.description())
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    var defaultCardList : [CGSSCard]!
    var rewardTable: [Int: Reward]!
    
    func setup(with pool: CGSSGacha) {
        defaultCardList = pool.cardList.map {
            $0.odds = pool.rewardTable[$0.id!]?.relativeOdds ?? 0
            return $0
        }
        rewardTable = pool.rewardTable
    }
    
    // 根据设定的筛选和排序方法重新展现数据
    override func updateUI() {
        filter.searchText = searchBar.text ?? ""
        self.cardList = filter.filter(defaultCardList)
        sorter.sortList(&self.cardList)
        
        tableView.reloadData()
        // 滑至tableView的顶部 暂时不需要
        // tableView.scrollToRowAtIndexPath(IndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let vc = CDTabViewController(card: cardList[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func doneAndReturn(filter: CGSSCardFilter, sorter: CGSSSorter) {
        self.filter = filter
        self.sorter = sorter
        updateUI()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GachaCardTableViewCell.description(), for: indexPath) as! GachaCardTableViewCell
        let row = indexPath.row
        let card = cardList[row]
        if let odds = rewardTable[card.id]?.relativeOdds {
            cell.setupWith(card, odds)
        } else {
            cell.setup(with: card)
        }
        return cell
    }
}

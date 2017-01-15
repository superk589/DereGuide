//
//  GachaCardTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/16.
//  Copyright © 2016年 zzk. All rights reserved.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        leftItem.width = 44
        navigationItem.leftBarButtonItem = leftItem

    }
    
    func backAction() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    var defaultCardList : [CGSSCard]!
    // 根据设定的筛选和排序方法重新展现数据
    override func refresh() {
        filter.searchText = searchBar.text ?? ""
        self.cardList = filter.filter(defaultCardList)
        sorter.sortList(&self.cardList)
        
        tableView.reloadData()
        // 滑至tableView的顶部 暂时不需要
        // tableView.scrollToRowAtIndexPath(IndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let cardDetailVC = CardDetailViewController()
        cardDetailVC.card = cardList[indexPath.row]
        cardDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cardDetailVC, animated: true)
    }
    override func doneAndReturn(filter: CGSSCardFilter, sorter: CGSSSorter) {
        self.filter = filter
        self.sorter = sorter
        refresh()
    }
}

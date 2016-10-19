//
//  GachaCardTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class GachaCardTableViewController: BaseCardTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(tbBack))
    
        toolbarItems = [backItem]

        prepareFilterAndSorter()
    }
    
    func tbBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    var defaultCardList : [CGSSCard]!
    // 根据设定的筛选和排序方法重新展现数据
    override func refresh() {
        let dao = CGSSDAO.sharedDAO
        self.cardList = filter.filterCardList(defaultCardList)
        if searchBar.text != "" {
            self.cardList = dao.getCardListByName(self.cardList, string: searchBar.text!)
        }
        dao.sortListInPlace(&self.cardList!, sorter: sorter)
        tableView.reloadData()
        // 滑至tableView的顶部 暂时不需要
        // tableView.scrollToRowAtIndexPath(IndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func prepareFilterAndSorter() {
        // 设置初始顺序和筛选
        filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11111111, skillMask: 0b111111111, gachaMask: 0b1111, favoriteMask: nil)
        sorter = CGSSSorter.init(att: "sRarity")
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
    
    override func doneAndReturn(_ filter: CGSSCardFilter, sorter: CGSSSorter) {
        self.filter = filter
        self.sorter = sorter
    }
}

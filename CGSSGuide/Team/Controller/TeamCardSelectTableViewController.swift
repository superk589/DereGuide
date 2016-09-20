//
//  TeamCardSelectTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamCardSelectTableViewController: BaseCardTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(tbBack))

        toolbarItems = [backItem]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func tbBack() {
        _ = navigationController?.popViewController(animated: true)
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
        // 设置初始顺序和筛选 默认按album_id降序 只显示SSR SSR+ SR SR+
        filter = CGSSSorterFilterManager.defaultManager.teamCardfilter
        // 按更新顺序排序
        sorter = CGSSSorterFilterManager.defaultManager.teamCardSorter
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func doneAndReturn(_ filter: CGSSCardFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.defaultManager.teamCardfilter = filter
        CGSSSorterFilterManager.defaultManager.teamCardSorter = sorter
        CGSSSorterFilterManager.defaultManager.saveForTeam()
    }
}

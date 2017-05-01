//
//  TeamCardSelectTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamCardSelectTableViewController: BaseCardTableViewController {
    
    override var filter: CGSSCardFilter {
        set {
            CGSSSorterFilterManager.default.teamCardfilter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.teamCardfilter
        }
    }
    override var sorter: CGSSSorter {
        set {
            CGSSSorterFilterManager.default.teamCardSorter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.teamCardSorter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = leftItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func backAction() {
        _ = navigationController?.popViewController(animated: true)
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
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func doneAndReturn(filter: CGSSCardFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.teamCardfilter = filter
        CGSSSorterFilterManager.default.teamCardSorter = sorter
        CGSSSorterFilterManager.default.saveForTeam()
        updateUI()
    }
}

//
//  UnitCardSelectTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class UnitCardSelectTableViewController: BaseCardTableViewController {
    
    override var filter: CGSSCardFilter {
        set {
            CGSSSorterFilterManager.default.unitCardfilter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.unitCardfilter
        }
    }
    override var sorter: CGSSSorter {
        set {
            CGSSSorterFilterManager.default.unitCardSorter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.unitCardSorter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func backAction() {
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
        CGSSSorterFilterManager.default.unitCardfilter = filter
        CGSSSorterFilterManager.default.unitCardSorter = sorter
        CGSSSorterFilterManager.default.saveForUnitCard()
        updateUI()
    }
}

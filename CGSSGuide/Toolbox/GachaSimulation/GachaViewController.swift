//
//  GachaViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class GachaViewController: RefreshableTableViewController, ZKDrawerControllerDelegate, GachaFilterSortControllerDelegate {
    
    var defaultList: [CGSSGachaPool]!
    
    var poolList = [CGSSGachaPool]()
    
    var filterVC: GachaFilterSortController!
    var filter: CGSSGachaFilter {
        set {
            CGSSSorterFilterManager.default.gachaPoolFilter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.gachaPoolFilter
        }
    }
    var sorter: CGSSSorter {
        set {
            CGSSSorterFilterManager.default.gachaPoolSorter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.gachaPoolSorter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(GachaTableViewCell.self, forCellReuseIdentifier: "GachaCell")
        tableView.estimatedRowHeight = GachaTableViewCell.estimatedHeight
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
        
        let filterItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = filterItem
        
        navigationItem.titleView = searchBar
        searchBar.placeholder = NSLocalizedString("卡池名称或描述", comment: "")
        
        filterVC = GachaFilterSortController()
        filterVC.delegate = self
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        reloadData()
        
    }
    
    func backAction() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func filterAction() {
        CGSSClient.shared.drawerController?.show(animated: true)
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, didHide vc: UIViewController) {
        
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, willShow vc: UIViewController) {
        filterVC.filter = filter
        filterVC.sorter = sorter
        filterVC.reloadData()
    }
    
    func doneAndReturn(filter: CGSSGachaFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.gachaPoolFilter = filter
        CGSSSorterFilterManager.default.gachaPoolSorter = sorter
        CGSSSorterFilterManager.default.saveForGachaPool()
        self.refresh()
    }
    
    func reloadData() {
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            CGSSGameResource.shared.master.getValidGacha(callback: { (pools) in
                self?.defaultList = pools
                DispatchQueue.main.async {
                    CGSSLoadingHUDManager.default.hide()
                    self?.refresh()
                }
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CGSSNotificationCenter.add(self, selector: #selector(reloadData), name: CGSSNotificationCenter.updateEnd, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CGSSNotificationCenter.removeAll(self)
        CGSSClient.shared.drawerController?.rightVC = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let drawer = CGSSClient.shared.drawerController
        drawer?.rightVC = filterVC
        drawer?.defaultRightWidth = min(Screen.width - 68, 400)
        drawer?.delegate = self
    }
    
    override func refresh() {
        self.filter.searchText = self.searchBar.text ?? ""
        self.poolList = self.filter.filter(self.defaultList)
        self.sorter.sortList(&self.poolList)
        self.tableView.reloadData()
    }
    
    override func refresherValueChanged() {
        check([.card, .master])
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GachaCell", for: indexPath) as! GachaTableViewCell
        let gachaPool = poolList[indexPath.row]
        cell.setup(pool: gachaPool)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poolList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = GachaDetailController()
        vc.pool = poolList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 32, bottom: 0, right: 0)
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.init(top: 0, left: 32, bottom: 0, right: 0)
    }
}

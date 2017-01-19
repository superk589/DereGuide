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
    
    lazy var defaultList = CGSSGameResource.sharedResource.getGachaPool()
    var poolList = [CGSSGachaPool]()
    var searchBar: CGSSSearchBar!
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
        tableView.estimatedRowHeight = 66
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
        
        let filterItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = filterItem
        
        searchBar = CGSSSearchBar()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("卡池名称或描述", comment: "")
        
        filterVC = GachaFilterSortController()
        filterVC.delegate = self
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        refresh()
        
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
    
    func updateData() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.defaultList = CGSSGameResource.sharedResource.getGachaPool()
            DispatchQueue.main.async {
                CGSSLoadingHUDManager.default.hide()
                self.refresh()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CGSSNotificationCenter.add(self, selector: #selector(updateData), name: CGSSNotificationCenter.updateEnd, object: nil)
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
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async {
            self.filter.searchText = self.searchBar.text ?? ""
            self.poolList = self.filter.filter(self.defaultList)
            self.sorter.sortList(&self.poolList)
            DispatchQueue.main.async {
                CGSSLoadingHUDManager.default.hide()
                self.tableView.reloadData()
            }
        }
    }
    
    override func refresherValueChanged() {
        check(0b1000001)
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//MARK: searchBar的协议方法
extension GachaViewController: UISearchBarDelegate {
    
    // 文字改变时
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refresh()
    }
    // 开始编辑时
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    // 点击搜索按钮时
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    // 点击searchbar自带的取消按钮时
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        refresh()
    }
}

//MARK: scrollView的协议方法
extension GachaViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 向下滑动时取消输入框的第一响应者
        searchBar.resignFirstResponder()
    }
}

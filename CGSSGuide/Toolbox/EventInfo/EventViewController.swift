//
//  EventViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class EventViewController: RefreshableTableViewController, ZKDrawerControllerDelegate, EventFilterSortControllerDelegate {

    var defaultList = CGSSGameResource.sharedResource.getEvent()
    var eventList = [CGSSEvent]()
    var searchBar: CGSSSearchBar!
    var filterVC: EventFilterSortController!
    var filter: CGSSEventFilter {
        set {
            CGSSSorterFilterManager.default.eventFilter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.eventFilter
        }
    }
    var sorter: CGSSSorter {
        set {
            CGSSSorterFilterManager.default.eventSorter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.eventSorter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventList = defaultList
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.estimatedRowHeight = 66
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
        
        let filterItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = filterItem
        
        searchBar = CGSSSearchBar()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("活动名", comment: "")
        
        filterVC = EventFilterSortController()
        filterVC.delegate = self
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        
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
    
    func doneAndReturn(filter: CGSSEventFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.eventFilter = filter
        CGSSSorterFilterManager.default.eventSorter = sorter
        CGSSSorterFilterManager.default.saveForEvent()
        self.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CGSSNotificationCenter.add(self, selector: #selector(refresh), name: CGSSNotificationCenter.updateEnd, object: nil)
        refresh()
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
        filter.searchText = searchBar.text ?? ""
        eventList = filter.filter(defaultList)
        sorter.sortList(&eventList)
        tableView.reloadData()
    }
    
    override func refresherValueChanged() {
        check(0b1000001)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        let event = eventList[indexPath.row]
        cell.setup(event: event)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bannerId = eventList.count - indexPath.row + 1
        let vc = EventDetailController()
        vc.bannerId = bannerId
        vc.event = eventList[indexPath.row]
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
extension EventViewController: UISearchBarDelegate {
    
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
extension EventViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 向下滑动时取消输入框的第一响应者
        searchBar.resignFirstResponder()
    }
}

//
//  EventViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class EventViewController: RefreshableTableViewController, ZKDrawerControllerDelegate {

    var eventList:[CGSSEvent]!
    var searchBar: CGSSSearchBar!
    var filterVC: EventFilterController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventList = CGSSGameResource.sharedResource.getEvent()
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.rowHeight = 66
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
        
        let filterItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = filterItem
        
        searchBar = CGSSSearchBar()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("活动名", comment: "")
        
        filterVC = EventFilterController()
        
        
    }
    
    func backAction() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func filterAction() {
        
    }

    func drawerController(_ drawerVC: ZKDrawerController, didHide vc: UIViewController) {
        
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, willShow vc: UIViewController) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CGSSNotificationCenter.add(self, selector: #selector(refresh), name: CGSSNotificationCenter.updateEnd, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CGSSNotificationCenter.removeAll(self)
    }
    
    override func refresh() {
        tableView.reloadData()
    }
    
    override func refresherValueChanged() {
        check(0b1000001)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        let bannerId = eventList.count - indexPath.row > 16 ? eventList.count - indexPath.row + 2 : eventList.count - indexPath.row + 1
        cell.setupWith(event: eventList[indexPath.row], bannerId: bannerId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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

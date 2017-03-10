//
//  EventViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class EventViewController: RefreshableTableViewController, ZKDrawerControllerDelegate, EventFilterSortControllerDelegate, BannerViewAnimatorProvider {

    var defaultList: [CGSSEvent]!
    var eventList = [CGSSEvent]()
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
    
    lazy var bannerViewAnimator: BannerViewAnimator = {
        let animator = BannerViewAnimator()
        return animator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.estimatedRowHeight = EventTableViewCell.estimatedHeight
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
        
        let filterItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = filterItem
        
        navigationItem.titleView = searchBar
        searchBar.placeholder = NSLocalizedString("活动名", comment: "")
        
        filterVC = EventFilterSortController()
        filterVC.delegate = self
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        self.reloadData()
    }
    
    func reloadData() {
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            CGSSGameResource.shared.master.getEvents(callback: { (events) in
                self?.defaultList = events
                DispatchQueue.main.async {
                    CGSSLoadingHUDManager.default.hide()
                    self?.refresh()
                }
            })
        }
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
        filter.searchText = searchBar.text ?? ""
        eventList = filter.filter(defaultList)
        sorter.sortList(&eventList)
        tableView.reloadData()
    }
    
    override func refresherValueChanged() {
        check([.master, .card])
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
        let cell = tableView.cellForRow(at: indexPath) as? EventTableViewCell
        self.bannerViewAnimator.sourceBannerView = cell?.banner
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

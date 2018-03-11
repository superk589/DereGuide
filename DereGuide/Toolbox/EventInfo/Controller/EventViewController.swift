//
//  EventViewController.swift
//  DereGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class EventViewController: BaseModelTableViewController, ZKDrawerControllerDelegate, EventFilterSortControllerDelegate, BannerAnimatorProvider, BannerContainer {

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
    
    lazy var bannerAnimator: BannerAnimator = {
        let animator = BannerAnimator()
        return animator
    }()
    
    var bannerView: BannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.estimatedRowHeight = EventTableViewCell.estimatedHeight
        tableView.separatorStyle = .none
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
        
        let filterItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = filterItem
        
        if #available(iOS 11.0, *) {
            navigationItem.titleView = searchBarWrapper
        } else {
            navigationItem.titleView = searchBar
        }
        searchBar.placeholder = NSLocalizedString("活动名", comment: "")
        
        filterVC = EventFilterSortController()
        filterVC.delegate = self
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
    }
    
    override func reloadData() {
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            CGSSGameResource.shared.master.getEvents(callback: { (events) in
                self?.defaultList = events
                DispatchQueue.main.async {
                    CGSSLoadingHUDManager.default.hide()
                    self?.updateUI()
                }
            })
        }
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func filterAction() {
        drawerController?.show(.right, animated: true)
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
        self.updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setNeedsReloadData), name: .updateEnd, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        drawerController?.rightViewController = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let drawer = drawerController
        drawer?.rightViewController = filterVC
        drawer?.defaultRightWidth = min(view.shortSide - 68, 400)
        drawer?.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.drawerController?.defaultRightWidth = min(size.shortSide - 68, 400)
            }, completion: nil)
    }
    
    override func updateUI() {
        filter.searchText = searchBar.text ?? ""
        eventList = filter.filter(defaultList)
        sorter.sortList(&eventList)
        tableView.reloadData()
    }
    
    override func checkUpdate() {
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
        bannerView = cell?.banner
        navigationController?.pushViewController(vc, animated: true)
    }
}

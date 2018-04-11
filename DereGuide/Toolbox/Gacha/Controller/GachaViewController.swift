//
//  GachaViewController.swift
//  DereGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class GachaViewController: BaseModelTableViewController, ZKDrawerControllerDelegate, GachaFilterSortControllerDelegate, BannerAnimatorProvider, BannerContainer {
    
    var defaultList: [CGSSGacha]!
    
    var poolList = [CGSSGacha]()
    
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
    
    var bannerAnimator: BannerAnimator = {
        let animator = BannerAnimator()
        return animator
    }()
    
    var bannerView: BannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(GachaTableViewCell.self, forCellReuseIdentifier: "GachaCell")
        tableView.estimatedRowHeight = GachaTableViewCell.estimatedHeight
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
        searchBar.placeholder = NSLocalizedString("卡池名称或描述", comment: "")
        
        filterVC = GachaFilterSortController()
        filterVC.delegate = self
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter        
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
    
    func doneAndReturn(filter: CGSSGachaFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.gachaPoolFilter = filter
        CGSSSorterFilterManager.default.gachaPoolSorter = sorter
        CGSSSorterFilterManager.default.saveForGachaPool()
        self.updateUI()
    }
    
    override func reloadData() {
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            CGSSGameResource.shared.master.getValidGacha(callback: { (pools) in
                self?.defaultList = pools
                DispatchQueue.main.async {
                    CGSSLoadingHUDManager.default.hide()
                    self?.updateUI()
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
        if drawerController?.rightViewController == filterVC {
            drawerController?.defaultRightWidth = min(size.shortSide - 68, 400)
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func updateUI() {
        self.filter.searchText = self.searchBar.text ?? ""
        self.poolList = self.filter.filter(self.defaultList)
        self.sorter.sortList(&self.poolList)
        self.tableView.reloadData()
    }
    
    override func checkUpdate() {
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
        vc.gacha = poolList[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as? GachaTableViewCell
        bannerView = cell?.banner
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

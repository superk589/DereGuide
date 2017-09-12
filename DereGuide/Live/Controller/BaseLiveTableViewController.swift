//
//  BaseLiveTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/8/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

protocol BaseSongTableViewControllerDelegate: class {
    func baseSongTableViewController(_ baseSongTableViewController: BaseLiveTableViewController, didSelect liveScene: CGSSLiveScene)
}

class BaseLiveTableViewController: BaseModelTableViewController, ZKDrawerControllerDelegate, LiveFilterSortControllerDelegate {
    weak var delegate: BaseSongTableViewControllerDelegate?
    var defualtLiveList = [CGSSLive]()
    var liveList: [CGSSLive] = [CGSSLive]()
    var sorter: CGSSSorter {
        get {
            return CGSSSorterFilterManager.default.liveSorter
        }
        set {
            CGSSSorterFilterManager.default.liveSorter = newValue
        }
    }
    var filter: CGSSLiveFilter {
        get {
            return CGSSSorterFilterManager.default.liveFilter
        }
        set {
            CGSSSorterFilterManager.default.liveFilter = newValue
        }
    }
    var filterVC: LiveFilterSortController!
    
    // 根据设定的筛选和排序方法重新展现数据
    override func updateUI() {
        
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            DispatchQueue.main.sync {
                self?.filter.searchText = self?.searchBar.text ?? ""
            }
            var newList = self?.filter.filter(self?.defualtLiveList ?? [CGSSLive]()) ?? [CGSSLive]()
            self?.sorter.sortList(&newList)
            DispatchQueue.main.async {
                CGSSLoadingHUDManager.default.hide()
                //确保cardList在主线程中改变的原子性, 防止筛选过程中tableView滑动崩溃
                self?.liveList = newList
                self?.tableView.reloadData()
            }
        }
    }
    
    func cancelAction() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        updateUI()
    }
    
    override func checkUpdate() {
        check([.beatmap, .master])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let drawer = drawerController
        drawer?.rightViewController = filterVC
        drawer?.delegate = self
        drawer?.defaultRightWidth = min(Screen.shortSide - 86, 400)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        drawerController?.rightViewController = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化导航栏的搜索条
        navigationItem.titleView = searchBar
        searchBar.placeholder = NSLocalizedString("歌曲名", comment: "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        tableView.register(LiveTableViewCell.self, forCellReuseIdentifier: "SongCell")
        tableView.rowHeight = 86
        tableView.separatorStyle = .none
        
        filterVC = LiveFilterSortController()
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged(notification:)), name: .updateEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged(notification:)), name: .dataRemoved, object: nil)
        
        reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func reloadData() {
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            CGSSGameResource.shared.master.getLives { (lives) in
                self?.defualtLiveList = lives
                DispatchQueue.main.async {
                    CGSSLoadingHUDManager.default.hide()
                    self?.updateUI()
                }
            }
        }
    }
    
    @objc func dataChanged(notification: Notification) {
        if let types = notification.userInfo?[CGSSUpdateDataTypesName] as? CGSSUpdateDataTypes {
            if types.contains(.master) || types.contains(.beatmap) {
                self.setNeedsReloadData()
            }
        }
    }
    
    @objc func filterAction() {
        drawerController?.show(.right, animated: true)
        // navigationController?.pushViewController(filterVC, animated: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return liveList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! LiveTableViewCell
        
        cell.setup(with: liveList[indexPath.row])
        cell.delegate = self
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let live = liveList[indexPath.row]
        
        let difficulty = live.selectableMaxDifficulty
        let scene = CGSSLiveScene(live: live, difficulty: difficulty)
        if scene.beatmap != nil {
            selectScene(scene)
        } else {
            showBeatmapNotFoundAlert()
        }
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, didHide vc: UIViewController) {
        
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, willShow vc: UIViewController) {
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.reloadData()
    }

    func doneAndReturn(filter: CGSSLiveFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.liveFilter = filter
        CGSSSorterFilterManager.default.liveSorter = sorter
        CGSSSorterFilterManager.default.saveForLive()
        updateUI()
    }
    
    // 此方法应该被override或者通过代理来响应
    func selectScene(_ scene: CGSSLiveScene) {
        searchBar.resignFirstResponder()
        delegate?.baseSongTableViewController(self, didSelect: scene)
    }
    
    func showBeatmapNotFoundAlert() {
        let alert = UIAlertController.init(title: NSLocalizedString("数据缺失", comment: "弹出框标题"), message: NSLocalizedString("未找到对应谱面，建议等待当前更新完成，或尝试下拉歌曲列表手动更新数据。如果更新后仍未找到，可能是官方还未更新此谱面。", comment: "弹出框正文"), preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

//MARK: SongTableViewCell的协议方法
extension BaseLiveTableViewController: LiveViewDelegate {
    
    func liveView(_ liveView: LiveView, didSelect scene: CGSSLiveScene) {
        if scene.beatmap != nil {
            selectScene(scene)
        } else {
            showBeatmapNotFoundAlert()
        }
    }
    
}

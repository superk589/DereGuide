//
//  BaseSongTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

protocol BaseSongTableViewControllerDelegate: class {
    func selectSong(_ live: CGSSLive, beatmaps: [CGSSBeatmap], diff: Int)
}
class BaseSongTableViewController: RefreshableTableViewController, ZKDrawerControllerDelegate {
    weak var delegate: BaseSongTableViewControllerDelegate?
    lazy var defualtLiveList: [CGSSLive] = {
        var result = [CGSSLive]()
        let semaphore = DispatchSemaphore.init(value: 0)
        CGSSGameResource.shared.master.getLives(callback: { (lives) in
            result = lives
            semaphore.signal()
        })
        semaphore.wait()
        return result
    }()
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
    var filterVC: SongFilterSortController!
    
    // 根据设定的筛选和排序方法重新展现数据
    override func refresh() {
        filter.searchText = searchBar.text ?? ""
        self.liveList = filter.filter(defualtLiveList)
        sorter.sortList(&self.liveList)
        tableView.reloadData()
    }
    
    func reloadData() {
        CGSSGameResource.shared.master.getLives { (lives) in
            self.defualtLiveList = lives
            self.refresh()
        }
    }
    
    func cancelAction() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        refresh()
    }
    
    override func refresherValueChanged() {
        check([.beatmap, .master])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let drawer = CGSSClient.shared.drawerController
        drawer?.rightVC = filterVC
        drawer?.delegate = self
        drawer?.defaultRightWidth = min(Screen.width - 86, 400)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CGSSClient.shared.drawerController?.rightVC = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化导航栏的搜索条
        self.navigationItem.titleView = searchBar
        searchBar.placeholder = NSLocalizedString("歌曲名", comment: "")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        self.tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongCell")
        self.tableView.rowHeight = 86
        
        filterVC = SongFilterSortController()
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.delegate = self
        
        CGSSNotificationCenter.add(self, selector: #selector(reloadData), name: CGSSNotificationCenter.updateEnd, object: nil)
    }
    
    deinit {
        CGSSNotificationCenter.removeAll(self)
    }
    
    func filterAction() {
        CGSSClient.shared.drawerController?.show(animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        
        cell.initWith(liveList[indexPath.row])
        cell.delegate = self
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let live = liveList[indexPath.row]
        let maxDiff = (live.masterPlus == 0) ? 4 : 5
        if let beatmaps = checkBeatmapData(live) {
            selectLive(live, beatmaps: beatmaps, diff: maxDiff)
        } else {
            // 手动取消选中状态
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, didHide vc: UIViewController) {
        
    }
    func drawerController(_ drawerVC: ZKDrawerController, willShow vc: UIViewController) {
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.reloadData()
    }

    
    // 此方法应该被override或者通过代理来响应
    func selectLive(_ live: CGSSLive, beatmaps: [CGSSBeatmap], diff: Int) {
        searchBar.resignFirstResponder()
        delegate?.selectSong(live, beatmaps: beatmaps, diff: diff)
    }
    
    func checkBeatmapData(_ live: CGSSLive) -> [CGSSBeatmap]? {
        if let beatmaps = CGSSGameResource.shared.getBeatmaps(liveId: live.id), beatmaps.count == (live.maxDiff == 5 ? 5 : 4) {
            return beatmaps
        } else {
            let alert = UIAlertController.init(title: NSLocalizedString("数据缺失", comment: "弹出框标题"), message: NSLocalizedString("未找到对应谱面，建议等待当前更新完成，或尝试下拉歌曲列表手动更新数据。", comment: "弹出框正文"), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
            return nil
        }
    }
}

//MARK: SongTableViewCell的协议方法
extension BaseSongTableViewController: SongTableViewCellDelegate {
    func diffSelected(_ live: CGSSLive, diff: Int) {
        if let beatmaps = checkBeatmapData(live) {
            selectLive(live, beatmaps: beatmaps, diff: diff)
        }
    }
}


extension BaseSongTableViewController: SongFilterSortControllerDelegate {
    func doneAndReturn(filter: CGSSLiveFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.liveFilter = filter
        CGSSSorterFilterManager.default.liveSorter = sorter
        CGSSSorterFilterManager.default.saveForLive()
        refresh()
    }
}

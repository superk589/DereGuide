//
//  BaseSongTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol BaseSongTableViewControllerDelegate: class {
    func selectSong(_ live: CGSSLive, beatmaps: [CGSSBeatmap], diff: Int)
}
class BaseSongTableViewController: RefreshableTableViewController {
    weak var delegate: BaseSongTableViewControllerDelegate?
    var liveList: [CGSSLive]!
    var sorter: CGSSSorter!
    var filter: CGSSSongFilter!
    var searchBar: UISearchBar!
    
    func prepareFilterAndSorter() {
        // 设置初始顺序和筛选 默认按album_id降序 只显示SSR SSR+ SR SR+
        filter = CGSSSorterFilterManager.defaultManager.songFilter
        // 按更新顺序排序
        sorter = CGSSSorterFilterManager.defaultManager.songSorter
    }
    
    // 根据设定的筛选和排序方法重新展现数据
    override func refresh() {
        prepareFilterAndSorter()
        let dao = CGSSDAO.sharedDAO
        liveList = filter.filterSongList(Array(dao.validLiveDict.values))
//        for live in liveList {
//            if CGSSShiftingBPMLive.checkIsShifting(live) {
//                print(live.musicRef?.title, CGSSShiftingBPMLive.checkIsShifting(live))
//            }
//        }
        if searchBar.text != "" {
            liveList = dao.getLiveListByName(liveList, string: searchBar.text!)
        }
        dao.sortListInPlace(&liveList!, sorter: sorter)
        tableView.reloadData()
    }
    func cancelAction() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        refresh()
    }
    
    // func filterAction() {
    // let sb = self.storyboard!
    // let filterVC = sb.instantiateViewControllerWithIdentifier("SongFilterTable") as! SongFilterTable
    // filterVC.filter = self.filter
    // //navigationController?.pushViewController(filterVC, animated: true)
    //
    //
    // //使用自定义动画效果
    // let transition = CATransition()
    // transition.duration = 0.3
    // transition.type = kCATransitionFade
    // navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
    // navigationController?.pushViewController(filterVC, animated: false)
    //
    // }
    
    override func refresherValueChanged() {
        check(0b11100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dao = CGSSDAO.sharedDAO
        liveList = Array(dao.validLiveDict.values)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        // 初始化导航栏的搜索条
        searchBar = UISearchBar()
        for sub in searchBar.subviews.first!.subviews {
            if let iv = sub as? UIImageView {
                iv.alpha = 0
            }
        }
        self.navigationItem.titleView = searchBar
        searchBar.returnKeyType = .done
        // searchBar.showsCancelButton = true
        searchBar.placeholder = NSLocalizedString("歌曲名", comment: "")
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.delegate = self
        // self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "889-sort-descending-toolbar"), style: .Plain, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: self, action: #selector(cancelAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "889-sort-descending-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        self.tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongCell")
        self.tableView.rowHeight = 86
        sorter = CGSSSorter.init(att: "updateId")
        dao.sortListInPlace(&liveList!, sorter: sorter)
    }
    
    func filterAction() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let filterVC = sb.instantiateViewController(withIdentifier: "SongFilterAndSorterTableViewController") as! SongFilterAndSorterTableViewController
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.hidesBottomBarWhenPushed = true
        filterVC.delegate = self
        // navigationController?.pushViewController(filterVC, animated: true)
        
        // 使用自定义动画效果
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(filterVC, animated: false)
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
    
    // 此方法应该被override或者通过代理来响应
    func selectLive(_ live: CGSSLive, beatmaps: [CGSSBeatmap], diff: Int) {
        searchBar.resignFirstResponder()
        delegate?.selectSong(live, beatmaps: beatmaps, diff: diff)
    }
    
    func checkBeatmapData(_ live: CGSSLive) -> [CGSSBeatmap]? {
        var beatmaps = [CGSSBeatmap]()
        let maxDiff = (live.masterPlus == 0) ? 4 : 5
        let dao = CGSSDAO.sharedDAO
        for i in 1...maxDiff {
            if let beatmap = dao.findBeatmapById(live.id!, diffId: i) {
                beatmaps.append(beatmap)
            } else {
                let msg = NSLocalizedString("缺少难度为%@的歌曲,建议等待当前更新完成，或尝试下拉歌曲列表手动更新数据。", comment: "弹出框正文")
                let alert = UIAlertController.init(title: NSLocalizedString("数据缺失", comment: "弹出框标题"), message: String.init(format: msg, CGSSGlobal.diffStringFromInt(i: i)), preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
                self.navigationController?.present(alert, animated: true, completion: nil)
                return nil
            }
        }
        return beatmaps
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

//MARK: searchBar的协议方法
extension BaseSongTableViewController: UISearchBarDelegate {
    
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
extension BaseSongTableViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 向下滑动时取消输入框的第一响应者
        searchBar.resignFirstResponder()
    }
}

extension BaseSongTableViewController: SongFilterAndSorterTableViewControllerDelegate {
    func doneAndReturn(_ filter: CGSSSongFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.defaultManager.songFilter = filter
        CGSSSorterFilterManager.defaultManager.songSorter = sorter
        CGSSSorterFilterManager.defaultManager.saveForSong()
    }
}

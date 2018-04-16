//
//  BaseLiveTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/8/7.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController
import EasyTipView

protocol BaseSongTableViewControllerDelegate: class {
    func baseSongTableViewController(_ baseSongTableViewController: BaseLiveTableViewController, didSelect liveScene: CGSSLiveScene)
}

class BaseLiveTableViewController: BaseModelTableViewController, ZKDrawerControllerDelegate, LiveFilterSortControllerDelegate, LiveTableViewCellDelegate {
    
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
            var newList = self?.filter.filter(self?.defualtLiveList ?? [CGSSLive]()).filter { $0.selectedLiveDetails.count != 0 } ?? [CGSSLive]()
            self?.sorter.sortList(&newList)
            DispatchQueue.main.async {
                CGSSLoadingHUDManager.default.hide()
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
        
        // a bug that only in iPhone X, from landscape poping to this page will cause layout issue, use gcd after to avoid it
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let drawer = self.drawerController
            drawer?.rightViewController = self.filterVC
            drawer?.delegate = self
            drawer?.defaultRightWidth = min(self.view.shortSide - 86, 400)
            if UserDefaults.standard.firstTimeShowLiveView {
                self.showHelpTips()
                UserDefaults.standard.firstTimeShowLiveView = false
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if drawerController?.rightViewController == filterVC {
            drawerController?.defaultRightWidth = min(size.shortSide - 86, 400)
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        drawerController?.rightViewController = nil
        hideHelpTips()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化导航栏的搜索条
        if #available(iOS 11.0, *) {
            navigationItem.titleView = searchBarWrapper
        } else {
            navigationItem.titleView = searchBar
        }
        searchBar.placeholder = NSLocalizedString("歌曲名", comment: "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        tableView.register(LiveTableViewCell.self, forCellReuseIdentifier: LiveTableViewCell.description())
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 86
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
    
    var tip: EasyTipView?
    var maskView: UIView?
    
    private func showHelpTips() {
        if tip == nil {
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont.boldSystemFont(ofSize: 14)
            preferences.drawing.foregroundColor = .white
            preferences.drawing.backgroundColor = UIColor.trick.darkened()
            
            tip = EasyTipView(text: NSLocalizedString("如需隐藏某些难度，或隐藏难度描述文字，请使用侧边菜单", comment: ""), preferences: preferences, delegate: nil)
            
        }
        tip?.show(forItem: navigationItem.rightBarButtonItem!)
        maskView = UIView()
        navigationController?.view.addSubview(maskView!)
        maskView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        maskView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideHelpTips)))
    }
    
    @objc func hideHelpTips() {
        tip?.dismiss()
        maskView?.removeFromSuperview()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveTableViewCell.description(), for: indexPath) as! LiveTableViewCell
        
        cell.setup(live: liveList[indexPath.row])
        
        // important, because the new height of the cell may be different with the previuous one, we should let system know to calculate it again.
        cell.setNeedsUpdateConstraints()
        cell.delegate = self
        // Configure the cell...
        return cell
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
    
    // MARK: LiveTableViewCellDelegate
    func liveTableViewCell(_ liveTableViewCell: LiveTableViewCell, didSelect jacketImageView: BannerView, musicDataID: Int) {
        CGSSGameResource.shared.master.getMusicInfo(musicDataID: musicDataID) { (songs) in
            DispatchQueue.main.async {
                let vc = SongDetailController()
                vc.setup(songs: songs, index: 0)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func liveTableViewCell(_ liveTableViewCell: LiveTableViewCell, didSelect liveScene: CGSSLiveScene) {
        if liveScene.beatmap != nil {
            selectScene(liveScene)
        } else {
            showBeatmapNotFoundAlert()
        }
    }
}

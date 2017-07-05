//
//  CharInfoViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/18.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class CharInfoViewController: BaseModelTableViewController, CharFilterSortControllerDelegate, ZKDrawerControllerDelegate {
    
    var charList: [CGSSChar]!
    var filter: CGSSCharFilter {
        set {
            CGSSSorterFilterManager.default.charFilter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.charFilter
        }
    }
    var sorter: CGSSSorter {
        set {
            CGSSSorterFilterManager.default.charSorter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.charSorter
        }
    }
    
    var filterVC: CharFilterSortController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchBar
        searchBar.placeholder = NSLocalizedString("日文名/罗马音/CV", comment: "角色信息页面")
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: self, action: #selector(cancelAction))
//        
        self.tableView.register(CharInfoTableViewCell.self, forCellReuseIdentifier: "CharCell")
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = backItem
        
        filterVC = CharFilterSortController()
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNeedsReloadData), name: .favoriteCharasChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func backAction() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // 根据设定的筛选和排序方法重新展现数据
    override func updateUI() {
        filter.searchText = searchBar.text ?? ""
        self.charList = filter.filter(CGSSDAO.shared.charDict.allValues as! [CGSSChar])
        sorter.sortList(&self.charList!)
        tableView.reloadData()
        // 滑至tableView的顶部 暂时不需要
        // tableView.scrollToRowAtIndexPath(IndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    override func reloadData() {
        updateUI()
    }
    
    override func checkUpdate() {
        check([.card, .master])
    }
    
    func filterAction() {
        CGSSClient.shared.drawerController?.show(.right, animated: true)
    }
    
    func cancelAction() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let drawer = CGSSClient.shared.drawerController
        drawer?.rightViewController = filterVC
        drawer?.defaultRightWidth = min(Screen.shortSide - 68, 400)
        drawer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CGSSClient.shared.drawerController?.rightViewController = nil
        // self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, didHide vc: UIViewController) {
        
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, willShow vc: UIViewController) {
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharCell", for: indexPath) as! CharInfoTableViewCell
        cell.setup(charList[indexPath.row], sorter: self.sorter)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charList?.count ?? 0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let CharDVC = CharDetailViewController()
        CharDVC.char = charList[indexPath.row]
        CharDVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(CharDVC, animated: true)
    }
    
    func doneAndReturn(filter: CGSSCharFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.charFilter = filter
        CGSSSorterFilterManager.default.charSorter = sorter
        CGSSSorterFilterManager.default.saveForChar()
        self.updateUI()
    }
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

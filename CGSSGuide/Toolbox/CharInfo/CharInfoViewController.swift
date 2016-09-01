//
//  CharInfoViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/18.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CharInfoViewController: BaseTableViewController, CharFilterAndSorterTableViewControllerDelegate {
    
    var charList: [CGSSChar]!
    var searchBar: UISearchBar!
    var filter: CGSSCharFilter!
    var sorter: CGSSSorter!
    var tb: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化导航栏的搜索条
        searchBar = UISearchBar()
        // 为了避免push/pop时闪烁,searchBar的背景图设置为透明的
        for sub in searchBar.subviews.first!.subviews {
            if let iv = sub as? UIImageView {
                iv.alpha = 0
            }
        }
        self.navigationItem.titleView = searchBar
        searchBar.returnKeyType = .Done
        // searchBar.showsCancelButton = true
        searchBar.placeholder = "日文名/罗马字/CV"
        searchBar.autocapitalizationType = .None
        searchBar.autocorrectionType = .No
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "889-sort-descending-toolbar"), style: .Plain, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Stop, target: self, action: #selector(cancelAction))
        
        self.tableView.registerClass(CharInfoTableViewCell.self, forCellReuseIdentifier: "CharCell")
        tb = UIToolbar.init(frame: CGRectMake(0, CGSSGlobal.height - 40, CGSSGlobal.width, 40))
        tableView.tableFooterView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 40))
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .Plain, target: self, action: #selector(tbBack))
        
        tb.items = [backItem]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func tbBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let superview = tableView.superview {
            superview.addSubview(tb)
            tb.fy = superview.fheight - 40
        }
    }
    
    func prepareFilterAndSorter() {
        // 设置初始顺序和筛选 默认按album_id降序 只显示SSR SSR+ SR SR+
        filter = CGSSSorterFilterManager.defaultManager.charFilter
        // 按更新顺序排序
        sorter = CGSSSorterFilterManager.defaultManager.charSorter
    }
    // 根据设定的筛选和排序方法重新展现数据
    func refresh() {
        prepareFilterAndSorter()
        let dao = CGSSDAO.sharedDAO
        self.charList = dao.getCharListByFilter(filter)
        if searchBar.text != "" {
            self.charList = dao.getCharListByName(charList, string: searchBar.text!)
        }
        dao.sortListInPlace(&charList!, sorter: sorter)
        tableView.reloadData()
        // 滑至tableView的顶部 暂时不需要
        // tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func filterAction() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let filterVC = sb.instantiateViewControllerWithIdentifier("CharFilterAndSorterTableViewController") as! CharFilterAndSorterTableViewController
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.hidesBottomBarWhenPushed = true
        filterVC.delegate = self
        // navigationController?.pushViewController(filterVC, animated: true)
        
        // 使用自定义动画效果
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
        navigationController?.pushViewController(filterVC, animated: false)
    }
    
    func cancelAction() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 页面出现时根据设定刷新排序和搜索内容
        searchBar.resignFirstResponder()
        refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CharCell", forIndexPath: indexPath) as! CharInfoTableViewCell
        cell.setup(charList[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charList?.count ?? 0
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let CharDVC = CharDetailViewController()
        CharDVC.char = charList[indexPath.row]
        CharDVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(CharDVC, animated: true)
    }
    
    func doneAndReturn(filter: CGSSCharFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.defaultManager.charFilter = filter
        CGSSSorterFilterManager.defaultManager.charSorter = sorter
        CGSSSorterFilterManager.defaultManager.saveForChar()
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

//MARK: searchBar的协议方法
extension CharInfoViewController: UISearchBarDelegate {
    
    // 文字改变时
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        refresh()
    }
    // 开始编辑时
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        return true
    }
    // 点击搜索按钮时
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    // 点击searchbar自带的取消按钮时
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        refresh()
    }
}

//MARK: scrollView的协议方法
extension CharInfoViewController {
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // 向下滑动时取消输入框的第一响应者
        searchBar.resignFirstResponder()
    }
}

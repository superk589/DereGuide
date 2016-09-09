//
//  BaseCardTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol BaseCardTableViewControllerDelegate {
    func selectCard(card: CGSSCard)
}

class BaseCardTableViewController: RefreshableTableViewController, CardFilterAndSorterTableViewControllerDelegate {
    
    var cardList: [CGSSCard]!
    var searchBar: UISearchBar!
    var filter: CGSSCardFilter!
    var sorter: CGSSSorter!
    var delegate: BaseCardTableViewControllerDelegate?
    
    func check(mask: UInt) {
        let updater = CGSSUpdater.defaultUpdater
        if updater.isUpdating {
            refresher.endRefreshing()
            return
        }
        self.updateStatusView.setContent("检查更新中", hasProgress: false)
        updater.checkUpdate(mask, complete: { (items, errors) in
            if !errors.isEmpty && items.count == 0 {
                self.updateStatusView.hidden = true
                let alert = UIAlertController.init(title: "检查更新失败", message: errors.joinWithSeparator("\n"), preferredStyle: .Alert)
                alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
                // 使用tabBarController来展现UIAlertController的原因是, 该方法处于异步子线程中,当执行时可能这个ViewController已经不在前台,会造成不必要的警告(虽然不会崩溃,但是官方不建议这样)
                self.tabBarController?.presentViewController(alert, animated: true, completion: nil)
            } else {
                if items.count == 0 {
                    self.updateStatusView.setContent("数据是最新版本", hasProgress: false)
                    self.updateStatusView.activityIndicator.stopAnimating()
                    UIView.animateWithDuration(2.5, animations: {
                        self.updateStatusView.alpha = 0
                        }, completion: { (b) in
                        self.updateStatusView.hidden = true
                        self.updateStatusView.alpha = 1
                    })
                    return
                }
                self.updateStatusView.setContent("更新数据中", total: items.count)
                updater.updateItems(items, progress: { (process, total) in
                    self.updateStatusView.updateProgress(process, b: total)
                    }, complete: { (success, total) in
                    let alert = UIAlertController.init(title: "更新完成", message: "成功\(success),失败\(total-success)", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
                    self.tabBarController?.presentViewController(alert, animated: true, completion: nil)
                    self.updateStatusView.hidden = true
                    self.refresh()
                })
            }
        })
        refresher.endRefreshing()
    }
    
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
        searchBar.placeholder = "日文名/罗马字/技能/稀有度"
        searchBar.autocapitalizationType = .None
        searchBar.autocorrectionType = .No
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "889-sort-descending-toolbar"), style: .Plain, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Stop, target: self, action: #selector(cancelAction))
        
        self.tableView.registerClass(CardTableViewCell.self, forCellReuseIdentifier: "CardCell")
        
    }
    
    func prepareFilterAndSorter() {
        // 设置初始顺序和筛选 默认按album_id降序 只显示SSR SSR+ SR SR+
        filter = CGSSSorterFilterManager.defaultManager.cardfilter
        // 按更新顺序排序
        sorter = CGSSSorterFilterManager.defaultManager.cardSorter
    }
    // 根据设定的筛选和排序方法重新展现数据
    func refresh() {
        prepareFilterAndSorter()
        let dao = CGSSDAO.sharedDAO
        self.cardList = dao.getCardListByMask(filter)
        if searchBar.text != "" {
            self.cardList = dao.getCardListByName(self.cardList, string: searchBar.text!)
        }
        dao.sortListInPlace(&self.cardList!, sorter: sorter)
        tableView.reloadData()
        // 滑至tableView的顶部 暂时不需要
        // tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    override func refresherValueChanged() {
        super.refresherValueChanged()
        check(0b11)
    }
    
    func filterAction() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let filterVC = sb.instantiateViewControllerWithIdentifier("CardFilterAndSorterTableViewController") as! CardFilterAndSorterTableViewController
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CGSSNotificationCenter.removeAll(self)
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 页面出现时根据设定刷新排序和搜索内容
        searchBar.resignFirstResponder()
        refresh()
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cardList?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CardCell", forIndexPath: indexPath) as! CardTableViewCell
        
        let row = indexPath.row
        let card = cardList[row]
        if let name = card.chara?.name, let conventional = card.chara?.conventional {
            cell.cardNameLabel.text = name + "  " + conventional
        }
        
        cell.cardIconView?.setWithCardId(card.id!)
        cell.cardIconView?.userInteractionEnabled = false
        
        // textLabel?.text = self.cardList[row] as? String
        
        // 显示数值
        cell.lifeLabel.text = String(card.life)
        cell.vocalLabel.text = String(card.vocal)
        cell.danceLabel.text = String(card.dance)
        cell.visualLabel.text = String(card.visual)
        cell.totalLabel.text = String(card.overall)
        
        // 显示稀有度
        cell.rarityLabel.text = card.rarity?.rarityString ?? ""
        
        // 显示title
        cell.titleLabel.text = card.title ?? ""
        
        // 显示主动技能类型
        if let skill = card.skill {
            if CGSSGlobal.width > 360 {
                cell.skillLabel.text = "\(skill.condition)s/\(skill.procTypeShort)/\(skill.skillType)"
            } else {
                cell.skillLabel.text = "\(skill.skillType)"
            }
        } else {
            cell.skillLabel.text = ""
        }
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.selectCard(cardList[indexPath.row])
    }
    
    func doneAndReturn(filter: CGSSCardFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.defaultManager.cardfilter = filter
        CGSSSorterFilterManager.defaultManager.cardSorter = sorter
        CGSSSorterFilterManager.defaultManager.saveForCard()
    }
    
}

//MARK: searchBar的协议方法
extension BaseCardTableViewController: UISearchBarDelegate {
    
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
extension BaseCardTableViewController {
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // 向下滑动时取消输入框的第一响应者
        searchBar.resignFirstResponder()
    }
}
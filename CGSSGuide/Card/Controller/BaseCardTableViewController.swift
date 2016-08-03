//
//  BaseCardTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol BaseCardTableViewControllerDelegate {
    func selectCard(card:CGSSCard)
}

class BaseCardTableViewController: RefreshableTableViewController {
    
    var cardList:[CGSSCard]!
    var searchBar:UISearchBar!
    var filter:CGSSCardFilter!
    var sorter:CGSSSorter!
    var delegate:BaseCardTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化导航栏的搜索条
        searchBar = UISearchBar()
        self.navigationItem.titleView = searchBar
        searchBar.returnKeyType = .Done
        //searchBar.showsCancelButton = true
        searchBar.placeholder = "日文名/罗马字/技能/稀有度"
        searchBar.autocapitalizationType = .None
        searchBar.autocorrectionType = .No
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "889-sort-descending-toolbar"), style: .Plain, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Stop, target: self, action: #selector(cancelAction))
        
        self.tableView.registerClass(CardTableViewCell.self, forCellReuseIdentifier: "CardCell")
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //设置初始顺序和筛选 默认按album_id降序 只显示SSR SSR+ SR SR+
        filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, favoriteMask: nil)
        
        //按更新顺序排序
        sorter = CGSSSorter.init(att: "update_id")
        
        
    }
    
    //根据设定的筛选和排序方法重新展现数据
    func refresh() {
        let dao = CGSSDAO.sharedDAO
        self.cardList = dao.getCardListByMask(filter)
        if searchBar.text != "" {
            self.cardList = dao.getCardListByName(self.cardList, string: searchBar.text!)
        }
        dao.sortCardListByAttibuteName(&self.cardList!, sorter: sorter)
        tableView.reloadData()
        //滑至tableView的顶部 暂时不需要
        //tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CGSSNotificationCenter.removeAll(self)
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //页面出现时根据设定刷新排序和搜索内容
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
        
        //textLabel?.text = self.cardList[row] as? String
        
        //显示数值
        cell.lifeLabel.text = String(card.life)
        cell.vocalLabel.text = String(card.vocal)
        cell.danceLabel.text = String(card.dance)
        cell.visualLabel.text = String(card.visual)
        cell.totalLabel.text = String(card.overall)
        
        //显示稀有度
        cell.rarityLabel.text = card.rarity?.rarityString ?? ""
        
        //显示主动技能类型
        cell.skillLabel.text = card.skill?.skill_type ?? ""
        
        //显示title
        cell.titleLabel.text = card.title ?? ""
        
        
        // Configure the cell...
        
        return cell
    }
    
    func filterAction() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let filterVC = sb.instantiateViewControllerWithIdentifier("CardFilterAndSorterTableView") as! CardFilterAndSorterTableViewController
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        //navigationController?.pushViewController(filterVC, animated: true)
        
        
        //使用自定义动画效果
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
        navigationController?.pushViewController(filterVC, animated: false)
    }
    
    
    func cancelAction() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        //恢复初始筛选
        filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, favoriteMask: nil)
        sorter = CGSSSorter.init(att: "update_id")
        refresh()
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.selectCard(cardList[indexPath.row])
    }
    
}

//MARK: searchBar的协议方法
extension BaseCardTableViewController : UISearchBarDelegate {
    
    //文字改变时
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        refresh()
    }
    //开始编辑时
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        return true
    }
    //点击搜索按钮时
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    //点击searchbar自带的取消按钮时
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        refresh()
    }
}

//MARK: scrollView的协议方法
extension BaseCardTableViewController {
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //向下滑动时取消输入框的第一响应者
        searchBar.resignFirstResponder()
    }
}
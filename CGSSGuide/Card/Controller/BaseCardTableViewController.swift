//
//  BaseCardTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol BaseCardTableViewControllerDelegate {
    func selectCard(_ card: CGSSCard)
}

class BaseCardTableViewController: RefreshableTableViewController, CardFilterAndSorterTableViewControllerDelegate {
    
    var cardList: [CGSSCard]!
    var searchBar: UISearchBar!
    var filter: CGSSCardFilter!
    var sorter: CGSSSorter!
    var delegate: BaseCardTableViewControllerDelegate?
    
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
        searchBar.returnKeyType = .done
        // searchBar.showsCancelButton = true
        searchBar.placeholder = NSLocalizedString("日文名/罗马音/技能/稀有度", comment: "搜索框文字, 不宜过长")
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "889-sort-descending-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: self, action: #selector(cancelAction))
        
        self.tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "CardCell")
        
    }
    
    func prepareFilterAndSorter() {
        // 设置初始顺序和筛选 默认按album_id降序 只显示SSR SSR+ SR SR+
        filter = CGSSSorterFilterManager.defaultManager.cardfilter
        // 按更新顺序排序
        sorter = CGSSSorterFilterManager.defaultManager.cardSorter
    }
    // 根据设定的筛选和排序方法重新展现数据
    override func refresh() {
        prepareFilterAndSorter()
        let dao = CGSSDAO.sharedDAO
        self.cardList = dao.getCardListByMask(filter)
        if searchBar.text != "" {
            self.cardList = dao.getCardListByName(self.cardList, string: searchBar.text!)
        }
        dao.sortListInPlace(&self.cardList!, sorter: sorter)
        tableView.reloadData()
        // 滑至tableView的顶部 暂时不需要
        // tableView.scrollToRowAtIndexPath(IndexPath.init(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    override func refresherValueChanged() {
        check(0b1000011)
    }
    
    func filterAction() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let filterVC = sb.instantiateViewController(withIdentifier: "CardFilterAndSorterTableViewController") as! CardFilterAndSorterTableViewController
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 页面出现时根据设定刷新排序和搜索内容
        searchBar.resignFirstResponder()
        refresh()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cardList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardTableViewCell
        
        let row = indexPath.row
        let card = cardList[row]
        if let name = card.chara?.name, let conventional = card.chara?.conventional {
            cell.cardNameLabel.text = name + "  " + conventional
        }
        
        cell.cardIconView?.setWithCardId(card.id!)
        cell.cardIconView?.isUserInteractionEnabled = false
        
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
                cell.skillLabel.text = "\(skill.condition!)s/\(skill.procTypeShort)/\(skill.skillFilterType.toString())"
            } else {
                cell.skillLabel.text = "\(skill.skillType!)"
            }
        } else {
            cell.skillLabel.text = ""
        }
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        delegate?.selectCard(cardList[indexPath.row])
    }
    
    func doneAndReturn(_ filter: CGSSCardFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.defaultManager.cardfilter = filter
        CGSSSorterFilterManager.defaultManager.cardSorter = sorter
        CGSSSorterFilterManager.defaultManager.saveForCard()
    }
    
}

//MARK: searchBar的协议方法
extension BaseCardTableViewController: UISearchBarDelegate {
    
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
extension BaseCardTableViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 向下滑动时取消输入框的第一响应者
        searchBar.resignFirstResponder()
    }
}

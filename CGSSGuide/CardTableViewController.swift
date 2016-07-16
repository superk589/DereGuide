//
//  CardTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardTableViewController: UITableViewController {
    
    var cardList:[CGSSCard]!
    //var cardTableArray:Array<CGSSCard>
    var searchBar:UISearchBar!
    var filter:CGSSCardFilter!
    var sorter:CGSSCardSorter!
    var updater:CGSSUpdater = CGSSUpdater()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSHomeDirectory())
        //启动时根据用户设置检查更新
        if NSUserDefaults.standardUserDefaults().valueForKey("DownloadAtStart") as? Bool ?? true {
//            let checkUpdateLabel = UILabel()
//            checkUpdateLabel.frame = CGRectMake(0, 0, 130, 30)
//            checkUpdateLabel.text = "正在检查更新..."
//            checkUpdateLabel.center = view.center
//            view.addSubview(checkUpdateLabel)
            updater.checkUpdate()
        }
        //添加下拉刷新
//        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.updater.checkUpdate()
//        })
        
        //self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.tabBarItem = UITabBarItem.init(title: "卡片", image: nil, tag: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Stop, target: self, action: #selector(cancelAction))
        //初始化导航栏的搜索条
        searchBar = UISearchBar()
        self.navigationItem.titleView = searchBar
        searchBar.returnKeyType = .Done
        //searchBar.showsCancelButton = true
        searchBar.placeholder = "日文名/罗马字/技能类型/稀有度等"
        searchBar.autocapitalizationType = .None
        searchBar.autocorrectionType = .No
        searchBar.delegate = self
        
        
        //
        
        
//        self.tableView.separatorInset = UIEdgeInsetsZero
//        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        //let updater = CGSSUpdater()
        //updater.getCardImages("")
        //updater.getFullImages("")
        
        //updater.getDataFromWebApi()
        //updater.getCardIconData()
        
        //设置初始顺序和筛选 默认按album_id降序 只显示SSR SSR+ SR SR+
        filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, favoriteMask: nil)

        //按更新顺序排序
        sorter = CGSSCardSorter.init(att: "update_id")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CGSSNotificationCenter.removeAll(self)
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        
        CGSSNotificationCenter.add(self, selector: #selector(updateFinished), name: "UPDATE_DATA_SAVED", object: nil)
       
        //页面出现时根据设定刷新排序和搜索内容
        searchBar.resignFirstResponder()
        let dao = CGSSDAO.sharedDAO
        self.cardList = dao.getCardListByMask(filter)
        if searchBar.text != "" {
            self.cardList = dao.getCardListByName(self.cardList, string: searchBar.text!)
        }
        dao.sortCardListByAttibuteName(&self.cardList!, sorter: sorter)
        tableView.reloadData()
  
        
    }
    
    func updateFinished() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        let dao = CGSSDAO.sharedDAO
        self.cardList = dao.getCardListByMask(filter)
        dao.sortCardListByAttibuteName(&self.cardList!, sorter: sorter)
        tableView.reloadData()
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
        
        
        cell.cardIconView?.image = CGSSDAO.sharedDAO.getIconFromCardId(card.id!)
        
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
        let sb = self.storyboard!
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
        let dao = CGSSDAO.sharedDAO
        searchBar.text = ""
        self.cardList = dao.getCardListByMask(filter)
        dao.sortCardListByAttibuteName(&self.cardList!, sorter: sorter)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cardDetailVC = CardDetailViewController()
        cardDetailVC.card = self.cardList[indexPath.row]
        //cardDetailVC.modalTransitionStyle = .CoverVertical
        self.navigationController?.pushViewController(cardDetailVC, animated: true)
        //使用自定义动画效果
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = kCATransitionMoveIn
//        transition.subtype = kCATransitionFromRight
//        navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
//        navigationController?.pushViewController(cardDetailVC, animated: false)
        
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CardTableViewController : UISearchBarDelegate {
    
    //文字改变时
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let dao = CGSSDAO.sharedDAO
        self.cardList = dao.getCardListByMask(filter)
        dao.sortCardListByAttibuteName(&self.cardList!, sorter: sorter)
        if searchText != "" {
            self.cardList = dao.getCardListByName(self.cardList, string: searchText)
        }
        self.tableView.reloadData()
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
        let dao = CGSSDAO.sharedDAO
        self.cardList = dao.getCardListByMask(filter)
        dao.sortCardListByAttibuteName(&self.cardList!, sorter: sorter)
        self.tableView.reloadData()
    }
}

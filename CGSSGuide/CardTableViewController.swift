//
//  CardTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CGSSFoundation

class CardTableViewController: UITableViewController {
    
    var cardList:[CGSSCard]!
    //var cardTableArray:Array<CGSSCard>
    var searchBar:UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.tabBarItem = UITabBarItem.init(title: "卡片", image: nil, tag: 1)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Stop, target: self, action: #selector(cancelAction))
        //初始化导航栏的搜索条
        searchBar = UISearchBar()
        self.navigationItem.titleView = searchBar
        searchBar.returnKeyType = .Done
        //searchBar.showsCancelButton = true
        searchBar.placeholder = "输入角色日文名或罗马字"
        searchBar.autocapitalizationType = .None
        searchBar.autocorrectionType = .No
        searchBar.delegate = self
       
        
        //let updater = CGSSUpdater()
        //updater.getCardImages("")
        //updater.getFullImages("")
        
        //updater.getDataFromWebApi()
        //updater.getCardIconData()
        let dao = CGSSDAO.sharedDAO

        dao.loadAllDataFromFile()
        
        self.cardList = dao.cardDict?.allValues as! [CGSSCard]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cardList.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CardTableViewCell! = tableView.dequeueReusableCellWithIdentifier("CardCell", forIndexPath: indexPath) as? CardTableViewCell
        let dao = CGSSDAO.sharedDAO
        let row = indexPath.row
        let card = cardList[row] 
        if let name = card.chara?.name, let conventional = card.chara?.conventional {
            cell.cardNameLabel.text = name + "  " + conventional
        }
        
        
        
        let cardIcon = dao.cardIconDict!.objectForKey(String(card.id!)) as! CGSSCardIcon
        
        let iconFile = cardIcon.file_name!
        

        let image = UIImage(named: iconFile)
        let cgRef = image!.CGImage
        let iconRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(96 * CGFloat(cardIcon.col!), 96 * CGFloat(cardIcon.row!) as CGFloat, 96, 96))
        let icon = UIImage.init(CGImage: iconRef!)
        cell.cardIconView?.image = icon
        
        //边角圆滑处理
        cell.cardIconView?.layer.cornerRadius = 6
        cell.cardIconView?.layer.masksToBounds = true
        
        //textLabel?.text = self.cardList[row] as? String

        //显示数值
        if let life = card.hp_max, let bonus = card.bonus_hp {
            cell.lifeLabel.text = "hp:"+String(life + bonus)
        }
        if let vocal = card.vocal_max, let bonus = card.bonus_vocal {
            cell.vocalLabel?.text = "vo:"+String(vocal + bonus)
        }
        if let dance = card.dance_max, let bonus = card.bonus_dance {
            cell.danceLabel?.text = "da:"+String(dance + bonus)
        }
        if let visual = card.visual_max, let bonus = card.bonus_visual {
            cell.visualLabel?.text = "vi:"+String(visual + bonus)
        }
        if let overall = card.overall_max, let bonus = card.overall_bonus {
            cell.totalLabel?.text = "T:"+String(overall + bonus)
        }
        
        
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
        //let
    }

    
    func cancelAction() {
        searchBar.resignFirstResponder()
        let dao = CGSSDAO.sharedDAO
        searchBar.text = ""
        self.cardList = dao.cardDict?.allValues as! [CGSSCard]
        self.tableView.reloadData()
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
        if searchText == "" {
            self.cardList = dao.cardDict?.allValues as! [CGSSCard]
        } else {
            self.cardList = dao.getCardListByName(searchText)
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

        self.cardList = dao.cardDict?.allValues as! [CGSSCard]
        self.tableView.reloadData()
    }
}

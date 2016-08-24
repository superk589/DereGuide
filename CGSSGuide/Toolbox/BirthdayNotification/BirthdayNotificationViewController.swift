//
//  BirthdayNotificationViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BirthdayNotificationViewController: UITableViewController {
    
    var headerView: UITableView!
    var headerCells: [UITableViewCell]!
    let sectionTitles = ["今天", "明天", "七天内", "一个月内"]
    var presentChars = [[CGSSChar]].init(count: 4, repeatedValue: [CGSSChar]())
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSettingCells()
        prepareChars()
        headerView = UITableView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 87), style: .Plain)
        headerView.delegate = self
        headerView.dataSource = self
        headerView.allowsSelection = false
        headerView.tableFooterView = UIView.init(frame: CGRectZero)
        
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        tableView.separatorStyle = .None
        tableView.registerClass(BirthdayNotificationTableViewCell.self, forCellReuseIdentifier: "BirthdayNotificationCell")
        
        if #available(iOS 9.0, *) {
            headerView.cellLayoutMarginsFollowReadableWidth = false
            tableView.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
//    init() {
//        super.init(style: .Grouped)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewWillLayoutSubviews() {
        // 对齐tableview和headerview的左边界
        tableView.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 0)
    }
    func prepareChars() {
        for i in 0...3 {
            presentChars[i].removeAll()
        }
        let bc = BirthdayCenter.defaultCenter
        presentChars[0].appendContentsOf(bc.getRecent(0, endDays: 0))
        presentChars[1].appendContentsOf(bc.getRecent(1, endDays: 1))
        presentChars[2].appendContentsOf(bc.getRecent(2, endDays: 6))
        presentChars[3].appendContentsOf(bc.getRecent(7, endDays: 30))
        
    }
    func prepareSettingCells() {
        headerCells = [UITableViewCell]()
        let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "BirthDaySettingCell")
        let swich1 = UISwitch.init(frame: CGRectZero)
        cell.accessoryView = swich1
        cell.textLabel?.text = "开启生日通知提醒"
        let birthdayNotice = NSUserDefaults.standardUserDefaults().valueForKey("BirthdayNotice") as? Bool ?? false
        swich1.on = birthdayNotice
        swich1.addTarget(self, action: #selector(valueChanged), forControlEvents: .ValueChanged)
        headerCells.append(cell)
        
        let cell2 = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: "BirthDaySettingCell")
        cell2.textLabel?.text = "时区"
        cell2.detailTextLabel?.text = NSUserDefaults.standardUserDefaults().valueForKey("BirthdayTimeZone") as? String ?? "Asia/Tokyo"
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectTimeZone))
        cell2.addGestureRecognizer(tap)
        headerCells.append(cell2)
        
    }
    
    func valueChanged(sw: UISwitch) {
        NSUserDefaults.standardUserDefaults().setValue(sw.on, forKey: "BirthdayNotice")
        refreshData()
    }
    
    func selectTimeZone() {
        let alvc = UIAlertController.init(title: "选择提醒时区", message: nil, preferredStyle: .ActionSheet)
        alvc.popoverPresentationController?.sourceView = headerCells[1].detailTextLabel
        alvc.popoverPresentationController?.sourceRect = CGRectMake(headerCells[1].detailTextLabel!.fwidth / 2, headerCells[1].detailTextLabel!.fheight, 0, 0)
        alvc.addAction(UIAlertAction.init(title: "System", style: .Default, handler: { (a) in
            NSUserDefaults.standardUserDefaults().setValue("System", forKey: "BirthdayTimeZone")
            self.headerCells[1].detailTextLabel?.text = "System"
            self.refreshData()
            }))
        alvc.addAction(UIAlertAction.init(title: "Asia/Tokyo", style: .Default, handler: { (a) in
            NSUserDefaults.standardUserDefaults().setValue("Asia/Tokyo", forKey: "BirthdayTimeZone")
            self.headerCells[1].detailTextLabel?.text = "Asia/Tokyo"
            self.refreshData()
            }))
        alvc.addAction(UIAlertAction.init(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alvc, animated: true, completion: nil)
    }
    
    func refreshData() {
        if NSUserDefaults.standardUserDefaults().shouldPostBirthdayNotice {
            (UIApplication.sharedApplication().delegate as! AppDelegate).registerAPNS()
            /*if UIApplication.sharedApplication().currentUserNotificationSettings()?.types == nil || UIApplication.sharedApplication().currentUserNotificationSettings()?.types == UIUserNotificationType.None {
             let alert = UIAlertController.init(title: "警告", message: "CGSSGuide的通知被禁用了，请前往手机设置中打开", preferredStyle: .Alert)
             alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
             self.presentViewController(alert, animated: true, completion: nil)
             }*/
                   BirthdayCenter.defaultCenter.sortInside()
            BirthdayCenter.defaultCenter.scheduleNotifications()
        } else {
            BirthdayCenter.defaultCenter.removeNotification()
        }
 
        prepareChars()
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshData), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if tableView == headerView {
            return 1
        } else {
            return 4
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == headerView {
            return 44
        } else {
            return presentChars[indexPath.section].count > 0 ? 89 : 0
        }
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == headerView {
            return nil
        } else {
            return sectionTitles[section]
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == headerView {
            return headerCells.count
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == headerView {
            return headerCells[indexPath.row]
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("BirthdayNotificationCell", forIndexPath: indexPath) as! BirthdayNotificationTableViewCell
            cell.initWith(presentChars[indexPath.section])
            cell.cv.contentInset.left = cell.layoutMargins.left - 10
            cell.cv.reloadData()
            // Configure the cell...
            
            return cell
        }
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

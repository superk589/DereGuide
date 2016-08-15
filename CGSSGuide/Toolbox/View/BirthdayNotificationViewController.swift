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
        headerView = UITableView.init(frame: CGRectMake(0, 0, CGSSTool.width, 87), style: .Plain)
        headerView.delegate = self
        headerView.dataSource = self
        headerView.allowsSelection = false
        headerView.tableFooterView = UIView.init(frame: CGRectZero)
        
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        tableView.separatorStyle = .None
        tableView.registerClass(BirthdayNotificationTableViewCell.self, forCellReuseIdentifier: "BirthdayNotificationCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
//    init() {
//        super.init(style: .Grouped)
//    }
    
    private func getTimeZone() -> NSTimeZone {
        let timeZoneString = NSUserDefaults.standardUserDefaults().valueForKey("BirthdayTimeZone") as? String ?? "Asia/Tokyo"
        switch timeZoneString {
        case "System":
            return NSTimeZone.systemTimeZone()
        default:
            return NSTimeZone.init(name: timeZoneString)!
        }
        
    }
    
    func prepareChars() {
        let dao = CGSSDAO.sharedDAO
        let nowDate = NSDate()
        let timeZone = getTimeZone()
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        gregorian?.timeZone = timeZone
        let nowComp = gregorian!.components(NSCalendarUnit.init(rawValue: NSCalendarUnit.Year.rawValue | NSCalendarUnit.Month.rawValue | NSCalendarUnit.Day.rawValue), fromDate: nowDate)
        
        let chars = dao.charDict.allValues as! [CGSSChar]
        for char in chars {
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "yyyyMMdd"
            dateformatter.timeZone = timeZone
            let dateString = String.init(format: "%04d%02d%02d", nowComp.year, char.birth_month!, char.birth_day!)
            let date = dateformatter.dateFromString(dateString)
            let newDate = dateformatter.dateFromString(String.init(format: "%04d%02d%02d", nowComp.year, nowComp.month, nowComp.day))
            let result = gregorian!.components(NSCalendarUnit.Day, fromDate: newDate!, toDate: date!, options: NSCalendarOptions(rawValue: 0))
            if result.day == 0 {
                presentChars[0].append(char)
            } else if result.day == 1 {
                presentChars[1].append(char)
            } else if result.day > 1 && result.day <= 6 {
                presentChars[2].append(char)
            } else if result.day > 6 && result.day <= 30 {
                presentChars[3].append(char)
            }
        }
    }
    func prepareSettingCells() {
        headerCells = [UITableViewCell]()
        let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "BirthDaySettingCell")
        let swich1 = UISwitch.init(frame: CGRectZero)
        cell.accessoryView = swich1
        cell.textLabel?.text = "开启生日提醒"
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
    
    func removeNotification() {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notification in notifications {
                if notification.category == "Birthday" {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                }
            }
        }
        
    }
    func prepareNotification() {
        removeNotification()
        let dao = CGSSDAO.sharedDAO
        let chars = dao.charDict.allValues as! [CGSSChar]
        for char in chars {
            
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "MMdd"
            
            dateformatter.timeZone = getTimeZone()
            let dateString = String.init(format: "%02d%02d", char.birth_month!, char.birth_day!)
            let date = dateformatter.dateFromString(dateString)
            let localNotification = UILocalNotification()
            localNotification.fireDate = date
            // print(NSDate())
            // print(date)
            // localNotification.timeZone = NSTimeZone.systemTimeZone()
            localNotification.repeatInterval = NSCalendarUnit.Year
            localNotification.alertBody = "今天是\(char.name!)的生日(\(char.birth_month!)月\(char.birth_day!)日)"
            localNotification.category = "Birthday"
//            if #available(iOS 8.2, *) {
//                localNotification.alertTitle = "title"
//            } else {
//                // Fallback on earlier versions
//            }
            
            // localNotification.alertAction = ""
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        // UIApplication.sharedApplication().cancelLocalNotification(notification: UILocalNotification)
        
    }
    
    func valueChanged(sw: UISwitch) {
        NSUserDefaults.standardUserDefaults().setValue(sw.on, forKey: "BirthdayNotice")
        refreshData()
    }
    
    func selectTimeZone() {
        let alvc = UIAlertController.init(title: "选择提醒时区", message: nil, preferredStyle: .ActionSheet)
        alvc.addAction(UIAlertAction.init(title: "当前系统时区", style: .Default, handler: { (a) in
            NSUserDefaults.standardUserDefaults().setValue("System", forKey: "BirthdayTimeZone")
            self.headerCells[1].detailTextLabel?.text = "当前系统时区"
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
        if NSUserDefaults.standardUserDefaults().valueForKey("BirthdayNotice") as? Bool ?? false {
            (UIApplication.sharedApplication().delegate as! AppDelegate).registerAPNS()
            prepareNotification()
            
        } else {
            removeNotification()
        }
        prepareChars()
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

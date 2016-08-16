//
//  RefreshableTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class RefreshableTableViewController: BaseTableViewController, UpdateStatusViewDelegate {
    
    var refresher: UIRefreshControl!
    var updateStatusView: UpdateStatusView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refreshControl = refresher
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString.init(string: "下拉检查更新")
        refreshControl = refresher
        refresher.addTarget(self, action: #selector(refresherValueChanged), forControlEvents: .ValueChanged)
        
        updateStatusView = UpdateStatusView.init(frame: CGRectMake(0, 0, 150, 50))
        updateStatusView.center = view.center
        updateStatusView.center.y = view.center.y - 100
        updateStatusView.hidden = true
        updateStatusView.delegate = self
        UIApplication.sharedApplication().keyWindow?.addSubview(updateStatusView)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func cancelUpdate() {
        let updater = CGSSUpdater.defaultUpdater
        updater.cancelCurrentSession()
    }
    
    // 当该页面作为二级页面被销毁时 仍有未完成的下载任务时 强行终止下载(作为tabbar的一级页面时 永远不会销毁 不会触发此方法)
    deinit {
        if !self.updateStatusView.hidden {
            updateStatusView.hidden = true
            let updater = CGSSUpdater.defaultUpdater
            updater.cancelCurrentSession()
        }
    }
    
    func refresherValueChanged() {
//        if refresher.refreshing {
//            refresher.attributedTitle = NSAttributedString.init(string: "开始更新")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

     // Configure the cell...

     return cell
     }
     */
    
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

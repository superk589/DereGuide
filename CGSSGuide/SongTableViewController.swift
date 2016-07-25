//
//  SongTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class SongTableViewController: RefreshableTableViewController {

    var liveList:[CGSSLive]!
    var sorter:CGSSSorter!

    func check(mask:UInt) {
        let updater = CGSSUpdater.defaultUpdater
        if updater.isUpdating {
            refresher.endRefreshing()
            return
        }
        self.updateStatusView.setContent("检查更新中", hasProgress: false)
        updater.checkUpdate(mask, complete: { (items, errors) in
            if !errors.isEmpty {
                self.updateStatusView.hidden = true
                let alert = UIAlertController.init(title: "检查更新失败", message: errors.joinWithSeparator("\n"), preferredStyle: .Alert)
                alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
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
                self.updateStatusView.setContent("更新数据中", hasProgress: true)
                updater.updateItems(items, progress: { (process, total) in
                    self.updateStatusView.updateProgress(process, b: total)
                    }, complete: { (success, total) in
                        let alert = UIAlertController.init(title: "更新完成", message: "成功\(success),失败\(total-success)", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
                        self.tabBarController?.presentViewController(alert, animated: true, completion: nil)
                        self.updateStatusView.hidden = true
                        updater.setVersionToNewest()
                        self.refresh()
                })

            }
        })
        refresher.endRefreshing()
    }

    //根据设定的筛选和排序方法重新展现数据
    func refresh() {
        let dao = CGSSDAO.sharedDAO
        liveList = Array(dao.validLiveDict.values)
        dao.sortListByAttibuteName(&liveList!, sorter: sorter)
        tableView.reloadData()
    }
    
    override func refresherValueChanged() {
        super.refresherValueChanged()
        check(0b11100)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dao = CGSSDAO.sharedDAO
        liveList = Array(dao.validLiveDict.values)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        sorter = CGSSSorter.init(att: "updateId")
        dao.sortListByAttibuteName(&liveList!, sorter: sorter)
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
        return liveList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as! SongTableViewCell

        cell.initWith(liveList[indexPath.row])
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let beatmapVC = BeatmapViewController()
        let live = liveList[indexPath.row]
        var beatmaps = [CGSSBeatmap]()
        let dao = CGSSDAO.sharedDAO
        let max = (live.masterPlus == 0) ? 4 : 5
        for i in 1...max {
            if let beatmap = dao.findBeatmapById(live.id!, diffId: i) {
                beatmaps.append(beatmap)
            }
        }
        beatmapVC.beatmaps = beatmaps
        self.navigationController?.pushViewController(beatmapVC, animated: true)
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

//
//  SettingsTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import MessageUI
import SDWebImage

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var downloadAtStartCell: UITableViewCell! {
        didSet {
            let downloadAtStartSwitch = UISwitch()
            downloadAtStartCell.accessoryView = downloadAtStartSwitch
            let downloadAtStart = NSUserDefaults.standardUserDefaults().valueForKey("DownloadAtStart") as? Bool ?? true
            downloadAtStartSwitch.on = downloadAtStart
            downloadAtStartSwitch.addTarget(self, action: #selector(downloadAtStartValueChanged), forControlEvents: .ValueChanged)
        }
    }

    @IBOutlet weak var dataVersionLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel! {
        didSet {
            let infoDic = NSBundle.mainBundle().infoDictionary
            appVersionLabel.text = (infoDic!["CFBundleShortVersionString"] as! String)
        }
    }

    func downloadAtStartValueChanged(sender:UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "DownloadAtStart")
    }
    
    
    @IBOutlet weak var sendEmailCell: UITableViewCell! {
        didSet {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(sendEmail))
            sendEmailCell.addGestureRecognizer(tap)
        }
    }
    func sendEmail() {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            let controller = MFMailComposeViewController()
            controller.setSubject("CGSSGuide问题反馈")
            controller.mailComposeDelegate = self
            controller.setToRecipients(["superk589@vip.qq.com"])
            controller.setMessageBody("app v\(appVersionLabel.text!)\ndata v\(dataVersionLabel.text!)\n", isHTML: false)
            self.presentViewController(controller, animated: true, completion: nil)
        }else{
            let alert = UIAlertController.init(title: "打开邮箱失败", message: "未设置邮箱账户", preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBOutlet weak var wipeDataCell: UITableViewCell! {
        didSet {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(wipeData))
            wipeDataCell.addGestureRecognizer(tap)
        }
    }

    func wipeData() {
        if CGSSUpdater.defaultUpdater.isUpdating {
            return
        }
        let alert = UIAlertController.init(title: "确定要清空数据吗？", message: "将会清除所有缓存的图片、卡片、歌曲数据。除非数据出现问题，不建议使用此选项。", preferredStyle: .Alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .Destructive, handler: { (alert) in
            CGSSDAO.sharedDAO.removeAllData()
            SDImageCache.sharedImageCache().clearDisk()
            CGSSUpdater.defaultUpdater.setCurrentDataVersion(String(0), minor: String(0))
            self.refresh()
        }))
        alert.addAction(UIAlertAction.init(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func refresh() {
        dataVersionLabel.text = CGSSUpdater.defaultUpdater.getCurrentVersionString()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @IBOutlet weak var reviewCell: UITableViewCell! {
        didSet {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(postReview))
            reviewCell.addGestureRecognizer(tap)
        }
    }
    func postReview() {
        let url = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1131934691"
        UIApplication.sharedApplication().openURL(NSURL.init(string: url)!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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

//MARK: MFMailComposeViewControllerDelegate
extension SettingsTableViewController : MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    //发送邮件代理方法
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
//        switch result{
//        case MFMailComposeResultSent:
//            let alert = UIAlertController.init(title: "邮件发送成功", message: "", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        case MFMailComposeResultCancelled:
//            break //print("邮件已取消")
//        case MFMailComposeResultSaved:
//            break //print("邮件已保存")
//        case MFMailComposeResultFailed:
//            let alert = UIAlertController.init(title: "邮件发送失败", message: "", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        default:
//            //print("邮件没有发送")
//            break
//        }
    }
}

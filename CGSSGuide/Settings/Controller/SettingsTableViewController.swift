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

class SettingsTableViewController: UITableViewController, UpdateStatusViewDelegate {
    
    @IBOutlet weak var downloadAtStartCell: UITableViewCell! {
        didSet {
            let downloadAtStartSwitch = UISwitch()
            downloadAtStartCell.accessoryView = downloadAtStartSwitch
            let downloadAtStart = NSUserDefaults.standardUserDefaults().valueForKey("DownloadAtStart") as? Bool ?? true
            downloadAtStartSwitch.on = downloadAtStart
            downloadAtStartSwitch.addTarget(self, action: #selector(downloadAtStartValueChanged), forControlEvents: .ValueChanged)
        }
    }
    
    @IBOutlet weak var fullImageCacheCell: UITableViewCell! {
        didSet {
            let fullImageCacheSwitch = UISwitch()
            fullImageCacheCell.accessoryView = fullImageCacheSwitch
            let fullImageCache = NSUserDefaults.standardUserDefaults().valueForKey("FullImageCache") as? Bool ?? true
            fullImageCacheSwitch.on = fullImageCache
            fullImageCacheSwitch.addTarget(self, action: #selector(fullImageCacheChanged), forControlEvents: .ValueChanged)
        }
    }
    func fullImageCacheChanged(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "FullImageCache")
    }
    
    @IBOutlet weak var dataVersionLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel! {
        didSet {
            let infoDic = NSBundle.mainBundle().infoDictionary
            appVersionLabel.text = (infoDic!["CFBundleShortVersionString"] as! String)
        }
    }
    
    func downloadAtStartValueChanged(sender: UISwitch) {
        NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: "DownloadAtStart")
    }
    
    @IBOutlet weak var sendEmailCell: UITableViewCell! {
        didSet {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(sendEmail))
            sendEmailCell.addGestureRecognizer(tap)
        }
    }
    func sendEmail() {
        // 首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.setSubject("CGSSGuide问题反馈")
            controller.mailComposeDelegate = self
            controller.setToRecipients(["superk589@vip.qq.com"])
            controller.setMessageBody("app v\(appVersionLabel.text!)\ndata v\(dataVersionLabel.text!)\n", isHTML: false)
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            let alert = UIAlertController.init(title: "打开邮箱失败", message: "未设置邮箱账户", preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var cacheImageCell: UITableViewCell! {
        didSet {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(cacheImage))
            cacheImageCell.addGestureRecognizer(tap)
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
    
    func cacheImage() {
        if CGSSUpdater.defaultUpdater.isUpdating {
            return
        }
        let alert = UIAlertController.init(title: "确定要缓存所有图片吗？", message: "所有图片总计超过300MB，请检查您的网络环境或剩余流量，确认无误后再点击确定。", preferredStyle: .Alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .Destructive, handler: { (alert) in
            dispatch_async(dispatch_get_global_queue(0, 0)) {
                let cards = CGSSDAO.sharedDAO.cardDict.allValues as! [CGSSCard]
                var urls = [NSURL]()
                
                // 所有卡片大图和头像图
                for card in cards {
                    if card.hasSpread! {
                        let url = NSURL.init(string: card.spreadImageRef!)
                        if !SDWebImageManager.sharedManager().cachedImageExistsForURL(url) {
                            urls.append(url!)
                        }
                    }
                    let url = NSURL.init(string: CGSSUpdater.URLOfImages + "/icon_card/\(card.id!).png")
                    if !SDWebImageManager.sharedManager().cachedImageExistsForURL(url) {
                        urls.append(url!)
                    }
                }
                
                // 所有歌曲封面图
                let lives = Array(CGSSDAO.sharedDAO.validLiveDict.values)
                for live in lives {
                    let song = CGSSDAO.sharedDAO.findSongById(live.musicId!)
                    let urlStr = CGSSUpdater.URLOfDeresuteApi + "/image/jacket_\(song!.id!).png"
                    let url = NSURL.init(string: urlStr)
                    if !SDWebImageManager.sharedManager().cachedImageExistsForURL(url) {
                        urls.append(url!)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateStatusView.setContent("缓存所有图片", total: urls.count)
                })
                CGSSUpdater.defaultUpdater.isUpdating = true
                // SDWebImagePrefetcher默认在主线程, 此处改为子线程
                SDWebImagePrefetcher.sharedImagePrefetcher().prefetcherQueue = dispatch_get_global_queue(0, 0)
                SDWebImagePrefetcher.sharedImagePrefetcher().prefetchURLs(urls, progress: { (a, b) in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateStatusView.updateProgress(Int(a), b: Int(b))
                    })
                    }, completed: { (a, b) in
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertController.init(title: "缓存大图完成", message: "成功\(a - b),失败\(b)", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
                        self.tabBarController?.presentViewController(alert, animated: true, completion: nil)
                        self.updateStatusView.hidden = true
                    })
                    CGSSUpdater.defaultUpdater.isUpdating = false
                })
                
            }
            }))
        alert.addAction(UIAlertAction.init(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func cancelUpdate() {
        SDWebImagePrefetcher.sharedImagePrefetcher().cancelPrefetching()
        CGSSUpdater.defaultUpdater.isUpdating = false
        let alvc = UIAlertController.init(title: "提示", message: "已取消", preferredStyle: .Alert)
        alvc.addAction(UIAlertAction.init(title: "确定", style: .Cancel, handler: nil))
        self.tabBarController?.presentViewController(alvc, animated: true, completion: nil)
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
        let url = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(CGSSGlobal.appid)"
        UIApplication.sharedApplication().openURL(NSURL.init(string: url)!)
    }
    
    var updateStatusView: UpdateStatusView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView.init(frame: CGRectZero)
        
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
extension SettingsTableViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    // 发送邮件代理方法
    
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

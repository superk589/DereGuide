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
    
    func check(mask: UInt) {
        let updater = CGSSUpdater.defaultUpdater
        if updater.isUpdating {
            refresher.endRefreshing()
            return
        }
        self.updateStatusView.setContent("检查更新中", hasProgress: false)
        updater.checkUpdate(mask, complete: { (items, errors) in
            if !errors.isEmpty && items.count == 0 {
                self.updateStatusView.hidden = true
                let alert = UIAlertController.init(title: "检查更新失败", message: errors.joinWithSeparator("\n"), preferredStyle: .Alert)
                alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
                // 使用tabBarController来展现UIAlertController的原因是, 该方法处于异步子线程中,当执行时可能这个ViewController已经不在前台,会造成不必要的警告(虽然不会崩溃,但是官方不建议这样)
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
                self.updateStatusView.setContent("更新数据中", total: items.count)
                updater.updateItems(items, progress: { (process, total) in
                    self.updateStatusView.updateProgress(process, b: total)
                    }, complete: { (success, total) in
                    let alert = UIAlertController.init(title: "更新完成", message: "成功\(success),失败\(total-success)", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
                    self.tabBarController?.presentViewController(alert, animated: true, completion: nil)
                    self.updateStatusView.hidden = true
                    self.refresh()
                })
            }
        })
        refresher.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refreshControl = refresher
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString.init(string: "下拉检查更新")
        refreshControl = refresher
        refresher.addTarget(self, action: #selector(refresherValueChanged), forControlEvents: .ValueChanged)
        
        updateStatusView = UpdateStatusView.init(frame: CGRectMake(0, 0, 160, 50))
        updateStatusView.center = view.center
        updateStatusView.center.y = view.center.y - 120
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
    
    func refresh() {
        // to override
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
        // to override
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
    
    
}

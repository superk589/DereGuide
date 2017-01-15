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
    
    func check(_ mask: UInt) {
        let updater = CGSSUpdater.defaultUpdater
        if updater.isUpdating {
            refresher.endRefreshing()
            return
        }
        self.updateStatusView.setContent(NSLocalizedString("检查更新中", comment: "更新框"), hasProgress: false)
        updater.checkUpdate(mask, complete: { (items, errors) in
            if !errors.isEmpty && items.count == 0 {
                self.updateStatusView.isHidden = true
                let alert = UIAlertController.init(title: NSLocalizedString("检查更新失败", comment: "更新框")
                    , message: errors.joined(separator: "\n"), preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
                // 使用tabBarController来展现UIAlertController的原因是, 该方法处于异步子线程中,当执行时可能这个ViewController已经不在前台,会造成不必要的警告(虽然不会崩溃,但是官方不建议这样)
                self.tabBarController?.present(alert, animated: true, completion: nil)
            } else {
                if items.count == 0 {
                    self.updateStatusView.setContent(NSLocalizedString("数据是最新版本", comment: "更新框"), hasProgress: false)
                    self.updateStatusView.loadingView.stopAnimating()
                    UIView.animate(withDuration: 2.5, animations: {
                        // 当一个控件的alpha = 0 之后 就不会响应任何事件了 不需要再置为hidden
                        self.updateStatusView.alpha = 0
//                        }, completion: { (b) in
//                        self.updateStatusView.isHidden = true
//                        self.updateStatusView.alpha = 1
                    })
                    return
                }
                self.updateStatusView.setContent(NSLocalizedString("更新数据中", comment: "更新框"), total: items.count)
                updater.updateItems(items, progress: { (process, total) in
                    self.updateStatusView.updateProgress(process, b: total)
                    }, complete: { (success, total) in
                    let alert = UIAlertController.init(title: NSLocalizedString("更新完成", comment: "弹出框标题"), message: "\(NSLocalizedString("成功", comment: "通用")) \(success), \(NSLocalizedString("失败", comment: "通用")) \(total-success)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
                    self.tabBarController?.present(alert, animated: true, completion: nil)
                    self.updateStatusView.isHidden = true
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
        refresher.attributedTitle = NSAttributedString.init(string: NSLocalizedString("下拉检查更新", comment: "下拉刷新文字"))
        refreshControl = refresher
        refresher.addTarget(self, action: #selector(refresherValueChanged), for: .valueChanged)
        
        updateStatusView = UpdateStatusView.init(frame: CGRect(x: 0, y: 0, width: 240, height: 50))
        updateStatusView.center = view.center
        updateStatusView.center.y = view.center.y - 120
        updateStatusView.isHidden = true
        updateStatusView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(updateStatusView)
        
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
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
        if !self.updateStatusView.isHidden {
            updateStatusView.isHidden = true
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
}

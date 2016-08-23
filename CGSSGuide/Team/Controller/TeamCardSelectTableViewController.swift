//
//  TeamCardSelectTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamCardSelectTableViewController: BaseCardTableViewController {
    
    var tb: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tb = UIToolbar.init(frame: CGRectMake(0, CGSSGlobal.height - 40, CGSSGlobal.width, 40))
        tableView.tableFooterView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 40))
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .Plain, target: self, action: #selector(tbBack))
        
        tb.items = [backItem]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func tbBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let superview = tableView.superview {
            superview.addSubview(tb)
            tb.fy = superview.fheight - 40
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

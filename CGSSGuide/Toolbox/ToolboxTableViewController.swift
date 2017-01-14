//
//  ToolboxTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class ToolboxTableViewController: BaseTableViewController {
    let path = Bundle.main.path(forResource: "ToolboxList", ofType: ".plist")
    var dataSource: [[String: String]]!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = NSArray.init(contentsOfFile: path!) as! [[String: String]]
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolboxCell", for: indexPath) as! ToolboxTableViewCell
        
        cell.descLabel.text = dataSource[indexPath.row]["title"]
        cell.icon.setWithCardId(Int(dataSource[indexPath.row]["iconId"]!)!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcType = NSClassFromString("CGSSGuide." + dataSource[indexPath.row]["cName"]!) as! UIViewController.Type
        let vc = vcType.init()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

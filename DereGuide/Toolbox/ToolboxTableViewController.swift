//
//  ToolboxTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class ToolboxTableViewController: BaseTableViewController {
    
    let path = Bundle.main.path(forResource: "ToolboxList", ofType: ".plist")
    var dataSource = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = NSArray(contentsOfFile: path!) as! [[String : String]]
        tableView.register(ToolboxTableViewCell.self, forCellReuseIdentifier: ToolboxTableViewCell.description())
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.rowHeight = 68
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ToolboxTableViewCell.description(), for: indexPath) as! ToolboxTableViewCell
        cell.titleLabel.text = dataSource[indexPath.row]["title"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcType = NSClassFromString("DereGuide." + dataSource[indexPath.row]["cName"]!) as! UIViewController.Type
        let vc = vcType.init()
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.title = dataSource[indexPath.row]["title"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

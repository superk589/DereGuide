//
//  BaseTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    override var shouldAutorotate: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .pad ? .all : .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        clearsSelectionOnViewWillAppear = true
        tableView.keyboardDismissMode = .onDrag
    }
    
}

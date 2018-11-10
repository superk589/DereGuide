//
//  ImageCacheTableViewController.swift
//  DereGuide
//
//  Created by zzk on 2018/11/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class ImageCacheTableViewController: UITableViewController {
    
    struct Row {
        var isSelected: Bool
        var title: String
        var total: Int
        var downloaded: Int
    }
    
    var rows = [Row]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
}

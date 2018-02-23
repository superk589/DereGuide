//
//  SupportDashboardController.swift
//  DereGuide
//
//  Created by zzk on 23/02/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class SupportDashboardController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var tableView: IndicatorTableView = {
        let tableView = IndicatorTableView()
        tableView.indicator.strokeColor = Color.parade.withAlphaComponent(0.5)
        tableView.sectionHeaderHeight = 30
        tableView.sectionFooterHeight = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.register(NoteSupportTableViewCell.self, forCellReuseIdentifier: NoteSupportTableViewCell.description())
        tableView.register(NoteSupportTableViewHeader.self, forHeaderFooterViewReuseIdentifier: NoteSupportTableViewHeader.description())
        return tableView
    }()
    
    var logs = [LSLog]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: TableViewDataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteSupportTableViewCell.description(), for: indexPath) as! NoteSupportTableViewCell
        cell.setup(with: logs[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NoteSupportTableViewHeader.description())
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}

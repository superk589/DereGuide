//
//  EventTrendViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/4/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class EventTrendViewController: BaseTableViewController {
    
    var eventId: Int!
    
    var trends = [EventTrend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("流行曲", comment: "")
        tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView()
        
        tableView.register(EventTrendCell.self, forCellReuseIdentifier: EventTrendCell.description())
        
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            CGSSGameResource.shared.master.getLiveTrend(eventId: self.eventId) { (trends) in
                self.trends = trends
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    let now = Date()
                    for trend in trends {
                        if trend.startDate.toDate() <= now && trend.endDate.toDate() > now {
                            let index = trends.index(of: trend)!
                            self.tableView.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .top)
                        }
                    }
                    CGSSLoadingHUDManager.default.hide()
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false {
            let count = trends[indexPath.row].lives.count
            let itemsPerRow = floor((Screen.width - 15) / CGFloat(132 + 5))
            let rows = ceil(CGFloat(count) / itemsPerRow)
            guard rows >= 1 else {
                return 44
            }
            return 44 + (rows * 132) + (rows - 1) * 5 + 10
        } else {
            return 44
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTrendCell.description(), for: indexPath) as! EventTrendCell
        cell.setup(with: trends[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? EventTrendCell {
            cell.setArrowSelected(true, animated: true)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? EventTrendCell {
            cell.setArrowSelected(false, animated: true)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

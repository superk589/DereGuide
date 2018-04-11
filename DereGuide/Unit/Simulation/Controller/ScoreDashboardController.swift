//
//  ScoreDashboardController.swift
//  DereGuide
//
//  Created by zzk on 23/02/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class ScoreDashboardController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: IndicatorTableView = {
        let tableView = IndicatorTableView()
        tableView.indicator.strokeColor = UIColor.life.withAlphaComponent(0.5)
        tableView.sectionHeaderHeight = 30
        tableView.sectionFooterHeight = 30
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoteScoreTableViewCell.self, forCellReuseIdentifier: "Note Cell")
        tableView.register(NoteScoreTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: "Note Header")
        tableView.register(NoteScoreTableViewSectionFooter.self, forHeaderFooterViewReuseIdentifier: "Note Footer")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note Cell", for: indexPath) as! NoteScoreTableViewCell
        cell.setup(with: logs[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Note Header")
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Note Footer") as! NoteScoreTableViewSectionFooter
        if let baseScore = logs.first?.baseScore, let totalScore = logs.last?.sum {
            footer.setupWith(baseScore: baseScore, totalScore: totalScore)
        }
        return footer
    }
    
}

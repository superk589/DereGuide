//
//  TeamSimulationController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class TeamSimulationController: UITableViewController, PageCollectionControllerContainable {
    
    var team: CGSSTeam! {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var liveDetail: CGSSLiveDetail? {
        didSet {
            tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .automatic)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TeamSimulationTeamCell.self, forCellReuseIdentifier: TeamSimulationTeamCell.description())
        tableView.register(TeamSimulationLiveSelectCell.self, forCellReuseIdentifier: TeamSimulationLiveSelectCell.description())
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamSimulationTeamCell.description(), for: indexPath) as! TeamSimulationTeamCell
            cell.setup(with: team)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamSimulationLiveSelectCell.description(), for: indexPath) as! TeamSimulationLiveSelectCell
            if let liveDetail = liveDetail {
                cell.setup(with: liveDetail)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

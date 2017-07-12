//
//  TeamInfomationController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class TeamInfomationController: BaseTableViewController, TeamCollectionPage {
        
    var unit: Unit! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        
        tableView.register(TeamInformationTeamCell.self, forCellReuseIdentifier: TeamInformationTeamCell.description())
        tableView.register(TeamInformationLeaderSkillCell.self, forCellReuseIdentifier: TeamInformationLeaderSkillCell.description())
        tableView.register(TeamInformationAppealCell.self, forCellReuseIdentifier: TeamInformationAppealCell.description())
        tableView.register(TeamInformationSkillListCell.self, forCellReuseIdentifier: TeamInformationSkillListCell.description())
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("load cell \(indexPath.row)")
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamInformationTeamCell.description(), for: indexPath) as! TeamInformationTeamCell
            cell.setup(with: unit)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamInformationLeaderSkillCell.description(), for: indexPath) as! TeamInformationLeaderSkillCell
            cell.setup(with: unit)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamInformationAppealCell.description(), for: indexPath) as! TeamInformationAppealCell
            cell.setup(with: unit)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamInformationSkillListCell.description(), for: indexPath) as! TeamInformationSkillListCell
            cell.setup(with: unit)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}


extension TeamInfomationController: TeamInformationTeamCellDelegate {
    
    func teamInformationTeamCell(_ teamInformationTeamCell: TeamInformationTeamCell, didClick cardIcon: CGSSCardIconView) {
        if let id = cardIcon.cardId, let card = CGSSDAO.shared.findCardById(id) {
            let cardDVC = CardDetailViewController()
            cardDVC.card = card
            navigationController?.pushViewController(cardDVC, animated: true)
        }
    }
    
}

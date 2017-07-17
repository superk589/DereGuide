//
//  TeamTemplateController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/12.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import CoreData

protocol TeamTemplateControllerDelegate: class {
    func teamTemplateController(_ teamTemplateController: TeamTemplateController, didSelect unit: Unit)
}

class TeamTemplateController: BaseTableViewController {
    
    weak var delegate: TeamTemplateControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("队伍模板", comment: "")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99
        tableView.register(TeamTemplateCell.self, forCellReuseIdentifier: TeamTemplateCell.description())
        tableView.tableFooterView = UIView()
        loadTeamTemplates()
        // Do any additional setup after loading the view.
    }
    
    var parentContext: NSManagedObjectContext? {
        didSet {
            context = parentContext?.newChildContext()
        }
    }
    
    private var context: NSManagedObjectContext?
    
    private var templates = [TeamTemplate]()
    
    private func loadTeamTemplates() {
        guard let context = context else {
            fatalError("parent context not set")
        }
        if let path = Bundle.main.path(forResource: "TeamTemplate", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? [String: [Int]] {
                for (name, array) in dict {
                    var members = [Member]()
                    for id in array {
                        let card = CGSSDAO.shared.findCardById(id)
                        let member = Member.insert(into: context, cardID: id, skillLevel: 10, potential: card?.properPotential ?? .zero)
                        members.append(member)
                    }
                    guard members.count == 6 else {
                        continue
                    }
                    let unit = Unit.insert(into: context, customAppeal: 0, supportAppeal: CGSSGlobal.defaultSupportAppeal, usesCustomAppeal: false, center: members[0], guest: members[5], otherMembers: Array(members[1...4]))
                    let template = TeamTemplate(name: name, unit: unit)
                    templates.append(template)
                }
                reloadUI()
            }
        }
    }
    
    private func reloadUI() {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.teamTemplateController(self, didSelect: templates[indexPath.row].unit)
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamTemplateCell.description(), for: indexPath) as! TeamTemplateCell
        cell.setup(with: templates[indexPath.row].name, unit: templates[indexPath.row].unit)
        return cell
    }
}

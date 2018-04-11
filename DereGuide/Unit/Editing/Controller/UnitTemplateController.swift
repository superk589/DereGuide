//
//  UnitTemplateController.swift
//  DereGuide
//
//  Created by zzk on 2017/6/12.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import CoreData

protocol UnitTemplateControllerDelegate: class {
    func unitTemplateController(_ unitTemplateController: UnitTemplateController, didSelect unit: Unit)
}

class UnitTemplateController: BaseTableViewController {
    
    weak var delegate: UnitTemplateControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("队伍模板", comment: "")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99
        tableView.register(UnitTemplateCell.self, forCellReuseIdentifier: UnitTemplateCell.description())
        tableView.tableFooterView = UIView()
        loadUnitTemplates()
        // Do any additional setup after loading the view.
    }
    
    var parentContext: NSManagedObjectContext? {
        didSet {
            context = parentContext?.newChildContext()
        }
    }
    
    private var context: NSManagedObjectContext?
    
    private var templates = [UnitTemplate]()
    
    private func loadUnitTemplates() {
        guard let context = context else {
            fatalError("parent context not set")
        }
        if let path = Bundle.main.path(forResource: "UnitTemplate", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? [String: [Any]] {
                for (name, array) in dict {
                    var members = [Member]()
                    for id in array {
                        if let subDict = id as? [String: Any] {
                            if let id = subDict["id"] as? Int, let potentials = subDict["potential"] as? [String: Int] {
                                let member = Member.insert(into: context, cardID: id, skillLevel: 10, potential: CGSSPotential(vocalLevel: potentials["vocalLevel"]!, danceLevel: potentials["danceLevel"]!, visualLevel: potentials["visualLevel"]!, lifeLevel: 0))
                                members.append(member)
                            }
                        } else if let id = id as? Int {
                            let card = CGSSDAO.shared.findCardById(id)
                            let member = Member.insert(into: context, cardID: id, skillLevel: 10, potential: card?.properPotential ?? .zero)
                            members.append(member)
                        }
                    }
                    guard members.count == 6 else {
                        continue
                    }
                    let unit = Unit.insert(into: context, customAppeal: 0, supportAppeal: Config.maximumSupportAppeal, usesCustomAppeal: false, members: members)
                    let template = UnitTemplate(name: name, unit: unit)
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
        delegate?.unitTemplateController(self, didSelect: templates[indexPath.row].unit)
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnitTemplateCell.description(), for: indexPath) as! UnitTemplateCell
        cell.setup(with: templates[indexPath.row].name, unit: templates[indexPath.row].unit)
        return cell
    }
}

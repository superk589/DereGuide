//
//  TeamEditViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol TeamEditViewControllerDelegate: class {
    func save(_ team: CGSSTeam)
}

class TeamEditViewController: BaseTableViewController {
    
    weak var delegate: TeamEditViewControllerDelegate?
    
    var leader: CGSSTeamMember? {
        set {
            members[0] = newValue
        }
        get {
            return members[0]
        }
    }
    
    var friendLeader: CGSSTeamMember? {
        set {
            members[5] = newValue
        }
        get {
            return members[5]
        }
    }
    
    var supportAppeal: Int?
    var customAppeal: Int?
    var usingCustomAppeal = false
    var lastIndexPath: IndexPath?
    
    var members = [CGSSTeamMember?].init(repeating: nil, count: 6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveTeam))
        navigationItem.title = NSLocalizedString("编辑队伍", comment: "")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
        
        tableView.register(TeamMemberPlaceholderCell.self, forCellReuseIdentifier: TeamMemberPlaceholderCell.description())
        tableView.register(TeamMemberCell.self, forCellReuseIdentifier: TeamMemberCell.description())
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        prepareToolbar()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if let lastIndexPath = lastIndexPath {
//            self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
//        }
//    }
    
    func prepareToolbar() {
        let item1 = UIBarButtonItem(title: NSLocalizedString("高级选项", comment: ""), style: .plain, target: self, action: #selector(openAdvanceOptions))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item2 = UIBarButtonItem(title: NSLocalizedString("队伍模板", comment: ""), style: .plain, target: self, action: #selector(openTemplates))
        toolbarItems = [item1, spaceItem, item2]
    }
    
    func openAdvanceOptions() {
        let vc = TeamCardSelectionAdvanceOptionsController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openTemplates() {
        let vc = TeamTemplateController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setup(with team: CGSSTeam) {
        self.leader = CGSSTeamMember.initWithAnother(teamMember: team.leader)
        self.friendLeader = CGSSTeamMember.initWithAnother(teamMember: team.friendLeader)
        for i in 1...4 {
            self.members[i] = CGSSTeamMember.initWithAnother(teamMember: team.subs[i - 1])
        }
        self.supportAppeal = team.supportAppeal
        self.customAppeal = team.customAppeal
        self.usingCustomAppeal = team.usingCustomAppeal
    }
    
    func saveTeam() {
        if members.flatMap({ (m) -> CGSSTeamMember? in
            return m
        }).count == 6 {
            let team = CGSSTeam(members: members.flatMap { $0 })
            delegate?.save(team)
            navigationController?.popViewController(animated: true)
        } else {
            let alvc = UIAlertController.init(title: NSLocalizedString("队伍不完整", comment: "弹出框标题"), message: NSLocalizedString("请完善队伍后，再点击存储", comment: "弹出框正文"), preferredStyle: .alert)
            alvc.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .cancel, handler: nil))
            self.tabBarController?.present(alvc, animated: true, completion: nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let member = members[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamMemberCell.description(), for: indexPath) as! TeamMemberCell
            cell.setupWith(member: member, type: CGSSTeamMemberType.init(index: indexPath.row))
            cell.delegate = self
            cell.cardView.icon.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TeamMemberPlaceholderCell.description(), for: indexPath) as! TeamMemberPlaceholderCell
            cell.setup(type: CGSSTeamMemberType.init(index: indexPath.row))
            cell.delegate = self
            return cell
        }
    }
    
    lazy var cardSelectionViewController: TeamCardSelectTableViewController = {
        let vc = TeamCardSelectTableViewController()
        vc.delegate = self
        return vc
    }()
    
    lazy var recentUsedSelectionViewController: TeamRecentUsedSelectionController = {
        let vc = TeamRecentUsedSelectionController()
        vc.delegate = self
        return vc
    }()

}
extension TeamEditViewController: TeamMemberCellDelegate {
    
    func beginEditingPotentialAndSkillLevel(_ cell: TeamMemberCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        lastIndexPath = indexPath
        let tevc = TeamMemberEditingViewController()
        tevc.modalPresentationStyle = .popover
        tevc.preferredContentSize = CGSize.init(width: 240, height: 290)
        if let lastIndex = lastIndexPath?.row, let member = members[lastIndex] {
            tevc.setup(model: member, type: CGSSTeamMemberType.init(index: lastIndex))
        }
        let pc = tevc.popoverPresentationController
        
        pc?.delegate = self
        pc?.permittedArrowDirections = .any
        pc?.sourceView = cell.editButton
        pc?.sourceRect = CGRect.init(x: cell.editButton.fwidth / 2, y: cell.editButton.fheight / 2, width: 0, height: 0)
        present(tevc, animated: true, completion: nil)
    }
    
    func endEditingPotentialAndSkillLevel(_ cell: TeamMemberCell) {
        
    }
    
    func selectMemberUsingRecentUsedIdols(_ cell: TeamMemberCell) {
        
    }
    
    func selectMemberUsingCardList(_ cell: TeamMemberCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        lastIndexPath = indexPath
        navigationController?.pushViewController(cardSelectionViewController, animated: true)
    }
}

extension TeamEditViewController: TeamMemberPlaceholderCellDelegate {
    
    func selectFromRecentUsed(_ teamMemberPlaceholderCell: TeamMemberPlaceholderCell) {
        let indexPath = tableView.indexPath(for: teamMemberPlaceholderCell)
        lastIndexPath = indexPath
        navigationController?.pushViewController(recentUsedSelectionViewController, animated: true)
    }
    
    func selectFromFullList(_ teamMemberPlaceholderCell: TeamMemberPlaceholderCell) {
        let indexPath = tableView.indexPath(for: teamMemberPlaceholderCell)
        lastIndexPath = indexPath
        navigationController?.pushViewController(cardSelectionViewController, animated: true)
    }
}

extension TeamEditViewController: TeamRecentUsedSelectionControllerDelegate {
    func teamRecentUsedSelectionController(_ teamRecentUsedSelectionController: TeamRecentUsedSelectionController, didSelect teamMember: CGSSTeamMember) {
        
    }
}

extension TeamEditViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let vc = popoverPresentationController.presentedViewController as! TeamMemberEditingViewController
        if let lastIndexPath = lastIndexPath, let member = members[lastIndexPath.row] {
            member.skillLevel = Int(round(vc.editView.skillItem.slider.value))
            member.vocalLevel = Int(round(vc.editView.vocalItem.slider.value))
            member.danceLevel = Int(round(vc.editView.danceItem.slider.value))
            member.visualLevel = Int(round(vc.editView.visualItem.slider.value))
            let cell = tableView.cellForRow(at: lastIndexPath) as! TeamMemberCell
            cell.setupWith(member: member, type: CGSSTeamMemberType.init(index: lastIndexPath.row))
        }
    }
}

extension TeamEditViewController: BaseCardTableViewControllerDelegate {
    
    private func reload(_ indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TeamMemberCell,
            let member = members[indexPath.row] {
            cell.setupWith(member: member, type: CGSSTeamMemberType.init(index: indexPath.row))
        } else {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func selectCard(_ card: CGSSCard) {
        let skillLevel = TeamEditingAdvanceOptionsManager.default.defaultSkillLevel
        let potentialLevel = TeamEditingAdvanceOptionsManager.default.defaultPotentialLevel
        let member = CGSSTeamMember(id: card.id, skillLevel: skillLevel, potential: card.properPotentialByLevel(potentialLevel))
        guard let lastIndexPath = lastIndexPath else { return }
        
        switch lastIndexPath.row {
        case 0:
            self.leader = member
            if self.friendLeader == nil {
                self.friendLeader = CGSSTeamMember.initWithAnother(teamMember: member)
                reload(IndexPath.init(row: 5, section: 0))
            }
        case 1...5:
            self.members[lastIndexPath.row] = member
        default:
            break
        }
        
        reload(lastIndexPath)
    }
}

//MARK: CGSSIconViewDelegate
extension TeamEditViewController: CGSSIconViewDelegate {
    func iconClick(_ iv: CGSSIconView) {
        let cardIcon = iv as! CGSSCardIconView
        if let id = cardIcon.cardId {
            if let card = CGSSDAO.shared.findCardById(id) {
                let cardDVC = CardDetailViewController()
                cardDVC.card = card
                navigationController?.pushViewController(cardDVC, animated: true)
            }
        }
    }
}

extension TeamEditViewController: TeamTemplateControllerDelegate {
    func teamTemplateController(_ teamTemplateController: TeamTemplateController, didSelect team: CGSSTeam) {
        self.setup(with: team)
        tableView.reloadData()
    }
}

//extension TeamEditViewController: Transitionable {
//    var transitionViews: [String : UIView] {
//        var dict = [String: UIView]()
//        for cell in cells {
//            let icon = cell.iconView!
//            let index = cells.index(of: cell)
//            dict["\(index ?? 0)\(icon.cardId ?? 0)"] = icon
//        }
//        return dict
//    }
//}

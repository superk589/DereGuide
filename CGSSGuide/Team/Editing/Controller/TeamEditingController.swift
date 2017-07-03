//
//  TeamEditingController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import EasyTipView

protocol TeamEditingControllerDelegate: class {
    func teamEditingController(_ teamEditingController: TeamEditingController, didSave team: CGSSTeam)
    func teamEditingController(_ teamEditingController: TeamEditingController, didModify teams: Set<CGSSTeam>)
}

class TeamEditingController: BaseViewController {

    weak var delegate: TeamEditingControllerDelegate?
    
    var collectionView: UICollectionView!
    var titleLabel: UILabel!
    var editableView = TeamMemberEditableView()
    
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
    
    var members = [CGSSTeamMember?].init(repeating: nil, count: 6)
    
    lazy var recentMembers: [CGSSTeamMember] = {
        return self.generateRecentMembers()
    }()
    
    fileprivate func generateRecentMembers() -> [CGSSTeamMember] {
        var members = [CGSSTeamMember]()
        for team in CGSSTeamManager.default.teams {
            for i in 0..<(TeamEditingAdvanceOptionsManager.default.includeGuestLeaderInRecentUsedIdols ? 6 : 5) {
                if let member = team[i], !members.contains{$0 == member} {
                    members.append(member)
                }
            }
        }
        return members
    }
    
    lazy var cardSelectionViewController: TeamCardSelectTableViewController = {
        let vc = TeamCardSelectTableViewController()
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        prepareToolbar()
        prepareNavigationBar()
        automaticallyAdjustsScrollViewInsets = false
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let maxWidth = min((Screen.shortSide - 70) / 6, 96)
        layout.itemSize = CGSize(width: maxWidth, height: maxWidth + 29)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(TeamRecentUsedCell.self, forCellWithReuseIdentifier: TeamRecentUsedCell.description())
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        view.addSubview(collectionView)
        
        titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("最近使用", comment: "")
        view.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            make.left.equalTo(10)
        }
        
        let infoButton = UIButton(type: .detailDisclosure)
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(titleLabel)
        }
        infoButton.addTarget(self, action: #selector(handleInfoButton), for: .touchUpInside)
        
        editableView.delegate = self
        editableView.backgroundColor = Color.cool.withAlphaComponent(0.1)
        view.addSubview(editableView)
        editableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(traitCollection.verticalSizeClass == .compact ? -32 : -44)
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(editableView.snp.top)
        }
        
        collectionView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        editableView.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
        collectionView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        editableView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.editableView.snp.updateConstraints { (update) in
                update.bottom.equalTo(self.traitCollection.verticalSizeClass == .compact ? -32 : -44)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.firstTimeUsingTeamEditingPage {
            showHelpTips()
            UserDefaults.standard.firstTimeUsingTeamEditingPage = false
        }
    }
    
    func prepareToolbar() {
        let item1 = UIBarButtonItem(title: NSLocalizedString("高级选项", comment: ""), style: .plain, target: self, action: #selector(openAdvanceOptions))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item2 = UIBarButtonItem(title: NSLocalizedString("队伍模板", comment: ""), style: .plain, target: self, action: #selector(openTemplates))
        toolbarItems = [item1, spaceItem, item2]
    }

    func openAdvanceOptions() {
        let vc = TeamCardSelectionAdvanceOptionsController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    func openTemplates() {
        let vc = TeamTemplateController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleInfoButton() {
        showHelpTips()
    }
    
    var tip1: EasyTipView!
    var tip2: EasyTipView!
    var maskView: UIView?
    
    private func showHelpTips() {
        if tip1 == nil || tip2 == nil {
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont.boldSystemFont(ofSize: 14)
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.backgroundColor = Color.cute
            
            if Screen.width < 375 {
                preferences.positioning.maxWidth = Screen.width - 40
            }
            
            tip1 = EasyTipView(text: NSLocalizedString("最近使用中将潜能和特技等级相同的同一张卡视作同一偶像。单击将偶像添加至底部编辑区域。长按编辑偶像的潜能和特技等级，会自动更新所有包含该偶像的队伍。另外该偶像的潜能等级会自动同步到同角色所有卡片（此功能高级选项中可关闭）", comment: ""), preferences: preferences, delegate: nil)
            
            preferences.drawing.backgroundColor = Color.passion
            tip2 = EasyTipView(text: NSLocalizedString("单击选择要修改的位置，双击可以从全部卡片中选择，长按可以编辑潜能和技能等级", comment: ""), preferences: preferences, delegate: nil)
        }
        tip1.show(forView: titleLabel)
        tip2.show(forView: editableView)
        maskView = UIView()
        navigationController?.view.addSubview(maskView!)
        maskView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        maskView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideHelpTips)))
    }
    
    func hideHelpTips() {
        tip1?.dismiss()
        tip2?.dismiss()
        maskView?.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideHelpTips()
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
        editableView.setupWith(team: team)
    }

    func saveTeam() {
        if members.flatMap({ (m) -> CGSSTeamMember? in
            return m
        }).count == 6 {
            let team = CGSSTeam(members: members.flatMap { $0 })
            delegate?.teamEditingController(self, didSave: team)
            NotificationCenter.default.post(name: .teamModified, object: nil)
            navigationController?.popViewController(animated: true)
        } else {
            let alvc = UIAlertController.init(title: NSLocalizedString("队伍不完整", comment: "弹出框标题"), message: NSLocalizedString("请完善队伍后，再点击存储", comment: "弹出框正文"), preferredStyle: .alert)
            alvc.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .cancel, handler: nil))
            self.tabBarController?.present(alvc, animated: true, completion: nil)
        }
    }
    
    private func prepareNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveTeam))
        navigationItem.title = NSLocalizedString("编辑队伍", comment: "")
    }
    
    fileprivate func reload(index: Int) {
        if let member = members[index] {
            editableView.setupWithMember(member, atIndex: index)
        }
    }
    
    func insertMember(_ member: CGSSTeamMember, atIndex index: Int) {
        switch index {
        case 0:
            self.leader = member
            if self.friendLeader == nil {
                self.friendLeader = CGSSTeamMember.initWithAnother(teamMember: member)
                reload(index: 5)
            }
        case 1...5:
            self.members[editableView.currentIndex] = member
        default:
            break
        }
        
        reload(index: editableView.currentIndex)
        
        var nextIndex = index + 1
        if nextIndex == 6 {
            nextIndex = 0
        }
        editableView.currentIndex = nextIndex
    }
}

extension TeamEditingController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentMembers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamRecentUsedCell.description(), for: indexPath) as! TeamRecentUsedCell
        cell.delegate = self
        cell.setup(with: recentMembers[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let member = recentMembers[indexPath.item]
        insertMember(member, atIndex: editableView.currentIndex)
    }
}

extension TeamEditingController: TeamRecentUsedCellDelegate {
    func didLongPressAt(_ teamRecentUsedCell: TeamRecentUsedCell) {
        guard let index = collectionView.indexPath(for: teamRecentUsedCell)?.item else {
            return
        }
        let tevc = TeamMemberEditingViewController()
        tevc.modalPresentationStyle = .popover
        tevc.preferredContentSize = CGSize.init(width: 240, height: 290)
        
        let member = recentMembers[index]
        guard let card = member.cardRef else {
            return
        }
        
        tevc.setupWith(member: member, card: card)
        
        let pc = tevc.popoverPresentationController
        
        pc?.delegate = self
        pc?.permittedArrowDirections = .any
        pc?.sourceView = teamRecentUsedCell
        pc?.sourceRect = CGRect.init(x: teamRecentUsedCell.fwidth / 2, y: teamRecentUsedCell.fheight
         / 2, width: 0, height: 0)
        present(tevc, animated: true, completion: nil)
    }
}

extension TeamEditingController: TeamMemberEditableViewDelegate {
    
    func teamMemberEditableView(_ teamMemberEditableView: TeamMemberEditableView, didDoubleTap item: TeamMemberEditableItemView) {
        navigationController?.pushViewController(cardSelectionViewController, animated: true)
    }
    
    func teamMemberEditableView(_ teamMemberEditableView: TeamMemberEditableView, didLongPressAt item: TeamMemberEditableItemView) {
        guard let index = teamMemberEditableView.editableItemViews.index(of: item), let _ = members[index] else {
            return
        }
        let tevc = TeamMemberEditingViewController()
        tevc.modalPresentationStyle = .popover
        tevc.preferredContentSize = CGSize.init(width: 240, height: 290)
        
        guard let member = members[index], let card = member.cardRef else {
            return
        }
        
        tevc.setupWith(member: member, card: card)
        
        let pc = tevc.popoverPresentationController
        
        pc?.delegate = self
        pc?.permittedArrowDirections = .down
        pc?.sourceView = item
        pc?.sourceRect = CGRect.init(x: item.fwidth / 2, y: 0, width: 0, height: 0)
        present(tevc, animated: true, completion: nil)
    }
}

extension TeamEditingController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    /// commit the change to idols skill level and potential levels
    ///
    /// - Parameters:
    ///   - member: team member need to commit
    ///   - vc: view controller that holds new data
    ///   - modifySkill: modify skill level or not (when the commit is synced by another card of the same chara, need not to modify skill level
    fileprivate func modify(_ member: CGSSTeamMember, using vc: TeamMemberEditingViewController, modifySkill: Bool = true) {
        if modifySkill {
            member.skillLevel = Int(round(vc.editView.skillStepper.value))
        }
        member.vocalLevel = Int(round(vc.editView.vocalStepper.value))
        member.danceLevel = Int(round(vc.editView.danceStepper.value))
        member.visualLevel = Int(round(vc.editView.visualStepper.value))
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let vc = popoverPresentationController.presentedViewController as! TeamMemberEditingViewController
        
        if let sourceView = popoverPresentationController.sourceView as? TeamRecentUsedCell {
            if let index = collectionView.indexPath(for: sourceView)?.item {
                let selectedMember = recentMembers[index]
                var modifiedTeams = Set<CGSSTeam>()
                for team in CGSSTeamManager.default.teams {
                    for i in 0..<(TeamEditingAdvanceOptionsManager.default.includeGuestLeaderInRecentUsedIdols ? 6 : 5) {
                        if let member = team[i] {
                            if (TeamEditingAdvanceOptionsManager.default.editAllSameChara && member.cardRef?.charaId == selectedMember.cardRef?.charaId) {
                                modify(member, using: vc, modifySkill: false)
                                modifiedTeams.insert(team)
                            } else if member == selectedMember {
                                modify(member, using: vc)
                                modifiedTeams.insert(team)
                            }
                        }
                    }
                }
                modify(selectedMember, using: vc)
                delegate?.teamEditingController(self, didModify: modifiedTeams)
                NotificationCenter.default.post(name: .teamModified, object: nil)
                CGSSTeamManager.default.save()
                collectionView.reloadData()
            }
        } else if let _ = popoverPresentationController.sourceView as? TeamMemberEditableItemView {
            if let member = members[editableView.currentIndex] {
                let index = editableView.currentIndex
                member.skillLevel = Int(round(vc.editView.skillStepper.value))
                member.vocalLevel = Int(round(vc.editView.vocalStepper.value))
                member.danceLevel = Int(round(vc.editView.danceStepper.value))
                member.visualLevel = Int(round(vc.editView.visualStepper.value))
                reload(index: index)
            }
        }
    }
}

extension TeamEditingController: BaseCardTableViewControllerDelegate {
    
    func selectCard(_ card: CGSSCard) {
        let skillLevel = TeamEditingAdvanceOptionsManager.default.defaultSkillLevel
        let potentialLevel = TeamEditingAdvanceOptionsManager.default.defaultPotentialLevel
        let member = CGSSTeamMember(id: card.id, skillLevel: skillLevel, potential: card.properPotentialByLevel(potentialLevel))
        
        insertMember(member, atIndex: editableView.currentIndex)
    }
}

extension TeamEditingController: TeamTemplateControllerDelegate {
    func teamTemplateController(_ teamTemplateController: TeamTemplateController, didSelect team: CGSSTeam) {
        self.setup(with: team)
    }
}

extension TeamEditingController: TeamCardSelectionAdvanceOptionsControllerDelegate {
    func recentUsedIdolsNeedToReload() {
        self.recentMembers = generateRecentMembers()
        collectionView.reloadData()
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

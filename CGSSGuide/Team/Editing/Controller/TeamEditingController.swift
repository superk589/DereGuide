//
//  TeamEditingController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol TeamEditingControllerDelegate: class {
    func teamEditingController(_ teamEditingController: TeamEditingController, didSave team: CGSSTeam)
}

class TeamEditingController: BaseViewController {

    weak var delegate: TeamEditingControllerDelegate?
    
    var collectionView: UICollectionView!
    
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
        layout.itemSize = CGSize(width: (Screen.width - 70) / 6, height: (Screen.width - 70) / 6 + 29)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(TeamRecentUsedCell.self, forCellWithReuseIdentifier: TeamRecentUsedCell.description())
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        view.addSubview(collectionView)
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("最近使用", comment: "")
        view.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            make.left.equalTo(10)
        }
        
        editableView.delegate = self
        editableView.backgroundColor = Color.cool.withAlphaComponent(0.1)
        view.addSubview(editableView)
        editableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-44)
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(editableView.snp.top)
        }
        
        collectionView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        editableView.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
        collectionView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
        editableView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
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
        
        cell.setup(with: recentMembers[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let member = recentMembers[indexPath.item]
        insertMember(member, atIndex: editableView.currentIndex)
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
        if let member = members[index] {
            tevc.setup(model: member)
        }
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
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let vc = popoverPresentationController.presentedViewController as! TeamMemberEditingViewController
        if let member = members[editableView.currentIndex] {
            let index = editableView.currentIndex
            member.skillLevel = Int(round(vc.editView.skillItem.slider.value))
            member.vocalLevel = Int(round(vc.editView.vocalItem.slider.value))
            member.danceLevel = Int(round(vc.editView.danceItem.slider.value))
            member.visualLevel = Int(round(vc.editView.visualItem.slider.value))
            reload(index: index)
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

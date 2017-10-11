//
//  UnitEditingController.swift
//  DereGuide
//
//  Created by zzk on 2017/6/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import EasyTipView
import CoreData
import  AudioToolbox

protocol UnitEditingControllerDelegate: class {
    func unitEditingController(_ unitEditingController: UnitEditingController, didModify units: Set<Unit>)
}

class UnitEditingController: BaseViewController {
    
    weak var delegate: UnitEditingControllerDelegate?
    var collectionView: UICollectionView!
    var titleLabel: UILabel!
    var editableView = MemberGroupView()
    
    lazy var context: NSManagedObjectContext = self.parentContext.newChildContext()
    
    fileprivate var parentContext: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    private var observer: ManagedObjectObserver?
    
    var parentUnit: Unit? {
        didSet {
            if let unit = parentUnit {
                observer = ManagedObjectObserver(object: unit, changeHandler: { [weak self] (type) in
                    if type == .delete {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
                setup(withParentUnit: unit)
            }
        }
    }
    
    var unit: Unit?
    
    var members = [Int: Member]()
    
    lazy var recentMembers: [Member] = {
        return self.generateRecentMembers()
    }()
    
    fileprivate func fetchAllUnitsOfParentContext() -> [Unit] {
        let request: NSFetchRequest<Unit> = Unit.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let units = try! parentContext.fetch(request)
        return units
    }
    
    fileprivate func generateRecentMembers() -> [Member] {
        var members = [Member]()
        let units = fetchAllUnitsOfParentContext()
        for unit in units {
            for i in 0..<(UnitEditingAdvanceOptionsManager.default.includeGuestLeaderInRecentUsedIdols ? 6 : 5) {
                let member = unit[i]
                if !members.contains{$0 == member} {
                    members.append(member)
                }
            }
        }
        return members
    }
    
    lazy var cardSelectionViewController: UnitCardSelectTableViewController = {
        let vc = UnitCardSelectTableViewController()
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
        let maxWidth = min(floor((Screen.shortSide - 70) / 6), 96)
        layout.itemSize = CGSize(width: maxWidth, height: maxWidth + 29)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(RecentUsedMemberCell.self, forCellWithReuseIdentifier: RecentUsedMemberCell.description())
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
        editableView.backgroundColor = Color.cool.mixed(withColor: .white, weight: 0.9)
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
        
        collectionView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .vertical)
        editableView.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
        collectionView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        editableView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        
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
        if UserDefaults.standard.firstTimeUsingUnitEditingPage {
            showHelpTips()
            UserDefaults.standard.firstTimeUsingUnitEditingPage = false
        }
    }
    
    func prepareToolbar() {
        let item1 = UIBarButtonItem(title: NSLocalizedString("高级选项", comment: ""), style: .plain, target: self, action: #selector(openAdvanceOptions))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item2 = UIBarButtonItem(title: NSLocalizedString("队伍模板", comment: ""), style: .plain, target: self, action: #selector(openTemplates))
        toolbarItems = [item1, spaceItem, item2]
    }

    @objc func openAdvanceOptions() {
        let vc = UnitCardSelectionAdvanceOptionsController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func openTemplates() {
        let vc = UnitTemplateController()
        vc.parentContext = self.context
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleInfoButton() {
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
        maskView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        maskView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideHelpTips)))
    }
    
    @objc func hideHelpTips() {
        tip1?.dismiss()
        tip2?.dismiss()
        maskView?.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideHelpTips()
    }
    
    fileprivate func setup(withParentUnit unit: Unit) {
        self.unit = context.object(with: unit.objectID) as? Unit
        for i in 0...5 {
            self.members[i] = self.unit?.orderedMembers[i]
        }
        editableView.setup(with: unit)
    }

    @objc func saveUnit() {
        if self.unit != nil {
            context.saveOrRollback()
            parentContext.saveOrRollback()
            navigationController?.popViewController(animated: true)
        } else {
            if members.values.count == 6 {
                Unit.insert(into: context, members: members.sorted{ $0.key < $1.key }.map { $0.value })
                context.saveOrRollback()
                parentContext.saveOrRollback()
                navigationController?.popViewController(animated: true)
            } else {
                let alvc = UIAlertController.init(title: NSLocalizedString("队伍不完整", comment: "弹出框标题"), message: NSLocalizedString("请完善队伍后，再点击存储", comment: "弹出框正文"), preferredStyle: .alert)
                alvc.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .cancel, handler: nil))
                self.tabBarController?.present(alvc, animated: true, completion: nil)
            }
        }
    }
    
    private func prepareNavigationBar() {
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveUnit))
        saveItem.style = .done
        navigationItem.rightBarButtonItem = saveItem
        
        navigationItem.title = NSLocalizedString("编辑队伍", comment: "")
    }
    
    fileprivate func reload(index: Int) {
        if let member = members[index] {
            editableView.setup(with: member, at: index)
        }
    }
    
    fileprivate func createOrReplaceMember(cardID: Int, skillLevel: Int, potential: CGSSPotential, at index: Int) {
        
        let member: Member
        
        if members[index] != nil {
            member = members[index]!
            member.setBy(cardID: cardID, skillLevel: skillLevel, potential: potential)
        } else {
            member = Member.insert(into: context, cardID: cardID, skillLevel: skillLevel, potential: potential, participatedPostion: index)
            members[index] = member
        }
        
        if index == 0 && members[5] == nil {
            createOrReplaceMember(cardID: cardID, skillLevel: skillLevel, potential: potential, at: 5)
        }
        
        reload(index: index)
    }
}

extension UnitEditingController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentUsedMemberCell.description(), for: indexPath) as! RecentUsedMemberCell
        cell.delegate = self
        cell.setup(with: recentMembers[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let member = recentMembers[indexPath.item]
        createOrReplaceMember(cardID: Int(member.cardID), skillLevel: Int(member.skillLevel), potential: member.potential, at: editableView.currentIndex)
        editableView.moveIndexToNext()
    }
}

extension UnitEditingController: RecentUsedMemberCellDelegate {
    
    func didLongPressAt(_ recentUsedMemberCell: RecentUsedMemberCell) {
        guard let index = collectionView.indexPath(for: recentUsedMemberCell)?.item else {
            return
        }
        let tevc = MemberEditingViewController()
        tevc.modalPresentationStyle = .popover
        tevc.preferredContentSize = CGSize.init(width: 240, height: 290)
        
        let member = recentMembers[index]
        guard let card = member.card else {
            return
        }
        
        tevc.setupWith(member: member, card: card)
        
        let pc = tevc.popoverPresentationController
        
        pc?.delegate = self
        pc?.permittedArrowDirections = .any
        pc?.sourceView = recentUsedMemberCell
        pc?.sourceRect = CGRect.init(x: recentUsedMemberCell.fwidth / 2, y: recentUsedMemberCell.fheight
         / 2, width: 0, height: 0)
        present(tevc, animated: true, completion: nil)
        // play sound like peek(3d touch)
        AudioServicesPlaySystemSound(1519)
    }
}

extension UnitEditingController: MemberGroupViewDelegate {
    
    func memberEditableView(_ memberGroupView: MemberGroupView, didDoubleTap item: MemberEditableItemView) {
        navigationController?.pushViewController(cardSelectionViewController, animated: true)
    }
    
    func memberGroupView(_ memberGroupView: MemberGroupView, didLongPressAt item: MemberEditableItemView) {
        guard let index = memberGroupView.editableItemViews.index(of: item), let _ = members[index] else {
            return
        }
        let tevc = MemberEditingViewController()
        tevc.modalPresentationStyle = .popover
        tevc.preferredContentSize = CGSize.init(width: 240, height: 290)
        
        guard let member = members[index], let card = member.card else {
            return
        }
        
        tevc.setupWith(member: member, card: card)
        
        let pc = tevc.popoverPresentationController
        
        pc?.delegate = self
        pc?.permittedArrowDirections = .down
        pc?.sourceView = item
        pc?.sourceRect = CGRect.init(x: item.fwidth / 2, y: 0, width: 0, height: 0)
        present(tevc, animated: true, completion: nil)
        // play sound like peek(3d touch)
        AudioServicesPlaySystemSound(1519)
    }
}

extension UnitEditingController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    /// commit the change to idols skill level and potential levels
    ///
    /// - Parameters:
    ///   - member: unit member need to commit
    ///   - vc: view controller that holds new data
    ///   - modifySkill: modify skill level or not (when the commit is synced by another card of the same chara, need not to modify skill level
    fileprivate func modify(_ member: Member, using vc: MemberEditingViewController, modifySkill: Bool = true) {
        if modifySkill {
            member.skillLevel = Int16(round(vc.editView.skillStepper.value))
        }
        member.vocalLevel = Int16(round(vc.editView.vocalStepper.value))
        member.danceLevel = Int16(round(vc.editView.danceStepper.value))
        member.visualLevel = Int16(round(vc.editView.visualStepper.value))
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let vc = popoverPresentationController.presentedViewController as! MemberEditingViewController
        
        if let sourceView = popoverPresentationController.sourceView as? RecentUsedMemberCell {
            if let index = collectionView.indexPath(for: sourceView)?.item {
                let selectedMember = recentMembers[index]
                let units = fetchAllUnitsOfParentContext()
                var modifiedUnits = Set<Unit>()
                for unit in units {
                    for i in 0..<(UnitEditingAdvanceOptionsManager.default.includeGuestLeaderInRecentUsedIdols ? 6 : 5) {
                        let member = unit[i]
                        if member == selectedMember {
                            modify(member, using: vc)
                            modifiedUnits.insert(unit)
                        } else if UnitEditingAdvanceOptionsManager.default.editAllSameChara && member.card?.charaId == selectedMember.card?.charaId {
                            modify(member, using: vc, modifySkill: false)
                            modifiedUnits.insert(unit)
                        }
                    }
                }
                parentContext.saveOrRollback()
                delegate?.unitEditingController(self, didModify: modifiedUnits)
                NotificationCenter.default.post(name: .unitModified, object: nil)
                collectionView.reloadData()
            }
        } else if let _ = popoverPresentationController.sourceView as? MemberEditableItemView {
            if let member = members[editableView.currentIndex] {
                let index = editableView.currentIndex
                member.skillLevel = Int16(round(vc.editView.skillStepper.value))
                member.vocalLevel = Int16(round(vc.editView.vocalStepper.value))
                member.danceLevel = Int16(round(vc.editView.danceStepper.value))
                member.visualLevel = Int16(round(vc.editView.visualStepper.value))
                reload(index: index)
            }
        }
    }
}

extension UnitEditingController: BaseCardTableViewControllerDelegate {
    
    func selectCard(_ card: CGSSCard) {
        let skillLevel = UnitEditingAdvanceOptionsManager.default.defaultSkillLevel
        let potentialLevel = UnitEditingAdvanceOptionsManager.default.defaultPotentialLevel
        createOrReplaceMember(cardID: card.id, skillLevel: skillLevel, potential: card.properPotentialByLevel(potentialLevel), at: editableView.currentIndex)
    }
}

extension UnitEditingController: UnitCardSelectionAdvanceOptionsControllerDelegate {
    func recentUsedIdolsNeedToReload() {
        self.recentMembers = generateRecentMembers()
        collectionView.reloadData()
    }
}

extension UnitEditingController: UnitTemplateControllerDelegate {
    
    func unitTemplateController(_ unitTemplateController: UnitTemplateController, didSelect unit: Unit) {
        for i in stride(from: 5, through: 0, by: -1) {
            let member = unit[i]
            createOrReplaceMember(cardID: Int(member.cardID), skillLevel: Int(member.skillLevel), potential: member.potential, at: i)
        }
    }
}

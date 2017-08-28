//
//  ColleagueComposeViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import CoreData
import EasyTipView

protocol ColleagueComposeViewControllerDelegate: class {
    func didPost(_ colleagueComposeViewController: ColleagueComposeViewController)
    func didSave(_ colleagueComposeViewController: ColleagueComposeViewController)
    func didRevoke(_ colleagueComposeViewController: ColleagueComposeViewController)
}

class ColleagueComposeViewController: BaseTableViewController {
    
    weak var delegate: ColleagueComposeViewControllerDelegate?
    
    var remote: ProfileRemote = ProfileRemote()
    
    lazy var context: NSManagedObjectContext = self.parentContext.newChildContext()
    
    fileprivate var parentContext: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    lazy var cardSelectionViewController: UnitCardSelectTableViewController = {
        let vc = UnitCardSelectTableViewController()
        vc.delegate = self
        return vc
    }()
    
    fileprivate var cells = [UITableViewCell]()
    
    var lastSelectedMyCenterItem: MyCenterItemView?
    var lastSelectedCenterWantedItem: CenterWantedItemView?
    
    fileprivate var profile: Profile!

    fileprivate struct Row: CustomStringConvertible {
        var type: UITableViewCell.Type
        var description: String {
            return type.description()
        }
        var title: String
    }
    
    fileprivate var rows: [Row] = [
        Row(type: ColleagueInputCell.self, title: NSLocalizedString("游戏ID", comment: "")),
        Row(type: ColleagueInputCell.self, title: NSLocalizedString("昵称", comment: "")),
        Row(type: ColleagueMyCentersCell.self, title: NSLocalizedString("我的队长", comment: "")),
//        Row(type: ColleagueCentersWantedCell.self, title: NSLocalizedString("希望征集的队长", comment: "")),
        Row(type: ColleagueMessageCell.self, title: NSLocalizedString("留言", comment: "")),
        Row(type: ColleagueButtonsCell.self, title: "")
    ]
    
    var postItem: UIBarButtonItem!
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareStaticCells()
        setupStaticCells()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        
        navigationItem.title = NSLocalizedString("我的信息", comment: "")
        postItem = UIBarButtonItem(title: NSLocalizedString("发布", comment: ""), style: .done, target: self, action: #selector(postAction))
        navigationItem.rightBarButtonItem = postItem
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        }
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.color = Color.parade
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.firstTimeComposingMyProfile {
            showTip1((cells[2] as! ColleagueMyCentersCell).infoButton)
            showTip2()
            UserDefaults.standard.firstTimeComposingMyProfile = false
        }
    }
    
    var tip1: EasyTipView?
    var tip2: EasyTipView?
    var maskView: UIView?
   
    private func showMaskView() {
        if maskView == nil {
            maskView = UIView()
        }
        navigationController?.view.addSubview(maskView!)
        maskView?.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        maskView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideHelpTips)))
    }
    
    @objc func showTip1(_ button: UIButton) {
        if tip1 == nil {
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont.boldSystemFont(ofSize: 14)
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.backgroundColor = Color.cute
            tip1 = EasyTipView(text: NSLocalizedString("双击从全部卡片中选择，长按编辑潜能或者移除偶像，我的队长中至少要填一个位置才能发布", comment: ""), preferences: preferences, delegate: nil)
        }
        if maskView?.superview == nil {
            showMaskView()
        }
        tip1?.show(forView: button)
    }
    
    @objc func showTip2() {
        if tip2 == nil {
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont.boldSystemFont(ofSize: 14)
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.backgroundColor = Color.cool
            tip2 = EasyTipView(text: NSLocalizedString("向所有用户公开您的信息，重复发布会自动覆盖之前的内容并刷新更新时间", comment: ""), preferences: preferences, delegate: nil)
        }
        if maskView?.superview == nil {
            showMaskView()
        }
        tip2?.show(forItem: navigationItem.rightBarButtonItem!)
    }

    @objc func hideHelpTips() {
        tip1?.dismiss()
        tip2?.dismiss()
        maskView?.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideHelpTips()
        context.saveOrRollback()
    }
    
//    @objc func resetAction() {
//        profile.reset()
//        setupStaticCells()
//    }
    
    @objc func postAction() {
        guard validateInput() else { return }
        saveProfileFromInput()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: indicator)
        indicator.startAnimating()
        if let _ = profile.remoteIdentifier {
            remote.modify([profile], modification: { (records, commit) in
                self.context.perform {
                    if let record = records.first {
                        let localRecord = self.profile.toCKRecord()
                        localRecord.allKeys().forEach {
                            record[$0] = localRecord[$0]
                        }
                        // call commit to modify remote record, only when remote has the record.
                        commit()
                    } else {
                        // there is no matched record in remote, upload again
                        self.upload()
                    }
                }
            }, completion: { (remoteProfiles, error) in
                self.postDidCompleted(error, remoteProfiles)
            })
        } else {
            upload()
        }
    }
    
    fileprivate func dismissOrPop() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func setup(parentProfile: Profile) {
        self.profile = context.object(with: parentProfile.objectID) as! Profile
    }
    
    fileprivate func validateInput() -> Bool {
        guard let _ = (cells[0] as! ColleagueInputCell).input.text?.match(pattern: "^[0-9]{9}$").first else {
            UIAlertController.showHintMessage(NSLocalizedString("您输入的游戏ID不合法", comment: ""), in: self)
            return false
        }
        
        guard let count = (cells[1] as! ColleagueInputCell).input.text?.characters.count, count <= 10 else {
            UIAlertController.showHintMessage(NSLocalizedString("昵称不能超过10个文字", comment: ""), in: self)
            return false
        }
        
        guard (cells[2] as! ColleagueMyCentersCell).centers.contains(where: { $0.0 != 0 }) else {
            UIAlertController.showHintMessage(NSLocalizedString("至少添加一名自己的队长", comment: ""), in: self)
            return false
        }
        return true
    }
    
    fileprivate func postDidCompleted(_ error: RemoteError?, _ remoteProfiles: [ProfileRemote.R]) {
        context.perform {
            self.indicator.stopAnimating()
            self.navigationItem.rightBarButtonItem = self.postItem
            if error != nil {
                UIAlertController.showHintMessage(NSLocalizedString("发布失败，请确保iCloud已登录并且网络状态正常", comment: ""), in: self)
            } else {
                self.profile.remoteIdentifier = remoteProfiles.first?.id
                self.profile.creatorID = remoteProfiles.first?.creatorID
                self.context.saveOrRollback()
                UIAlertController.showHintMessage(NSLocalizedString("发布成功", comment: ""), in: self) {
                    self.dismissOrPop()
                    self.delegate?.didPost(self)
                }
            }
        }
    }
    
    fileprivate func upload() {
        remote.upload([profile], completion: { (remoteProfiles, error) in
            self.postDidCompleted(error, remoteProfiles)
        })
    }
    
    fileprivate func saveProfileFromInput() {
        
        profile.nickName = (cells[1] as! ColleagueInputCell).input.text ?? ""
        profile.gameID = (cells[0] as! ColleagueInputCell).input.text ?? ""
        profile.myCenters = (cells[2] as! ColleagueMyCentersCell).centers
//        profile.centersWanted = (cells[3] as! ColleagueCentersWantedCell).centers
        profile.message = (cells[3] as! ColleagueMessageCell).messageView.text.trimmingCharacters(in: ["\n", " "])
        
        context.saveOrRollback()
        parentContext.saveOrRollback()
    }
    
    private func prepareStaticCells() {
        for index in 0..<rows.count {
            let row = rows[index]
            let cell = row.type.init()
            cells.append(cell)
            (cell as? ColleagueBaseCell)?.setTitle(row.title)
            switch cell {
            case let cell as ColleagueInputCell where index == 0:
                cell.checkPattern = "^[0-9]{9}$"
            case let cell as ColleagueInputCell where index == 1:
                cell.checkPattern = "^.{0,10}$"
            case let cell as ColleagueMyCentersCell:
                cell.delegate = self
                cell.infoButton.addTarget(self, action: #selector(showTip1(_:)), for: .touchUpInside)
//            case let cell as ColleagueCentersWantedCell:
//                cell.delegate = self
//                cell.infoButton.addTarget(self, action: #selector(showTip2(_:)), for: .touchUpInside)
            case let cell as ColleagueButtonsCell:
                cell.delegate = self
            default:
                break
            }
        }
    }
    
    private func setupStaticCells() {
        for index in 0..<rows.count {
            let cell = cells[index]
            switch index {
            case 0:
                (cell as! ColleagueInputCell).setup(with: profile.gameID, keyboardType: .numberPad)
            case 1:
                (cell as! ColleagueInputCell).setup(with: profile.nickName, keyboardType: .default)
            case 2:
                (cell as! ColleagueMyCentersCell).setup(profile)
//            case 3:
//                (cell as! ColleagueCentersWantedCell).setup(profile)
            case 3:
                (cell as! ColleagueMessageCell).setup(with: profile.message ?? "")
            default:
                break
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
}

extension ColleagueComposeViewController: CenterWantedGroupViewDelegate {
    
    func centerWantedGroupView(_ centerWantedGroupView: CenterWantedGroupView, didDoubleTap item: CenterWantedItemView) {
        lastSelectedCenterWantedItem = item
        lastSelectedMyCenterItem = nil
        navigationController?.pushViewController(cardSelectionViewController, animated: true)
    }
    
    func centerWantedGroupView(_ centerWantedGroupView: CenterWantedGroupView, didLongPressAt item: CenterWantedItemView) {
        guard let id = item.cardID, let card = CGSSDAO.shared.findCardById(id) else {
            return
        }
        let vc = CenterWantedEditingViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize.init(width: 240, height: 140)
        vc.delegate = self
        lastSelectedCenterWantedItem = item
        vc.setupWith(card: card, minLevel: item.minLevel)
        
        let pc = vc.popoverPresentationController
        
        pc?.delegate = self
        pc?.sourceView = item
        pc?.sourceRect = CGRect.init(x: item.fwidth / 2, y: item.fheight / 2, width: 0, height: 0)
        present(vc, animated: true, completion: nil)
    }
}

extension ColleagueComposeViewController: MyCenterGroupViewDelegate {
    
    func profileMemberEditableView(_ profileMemberEditableView: MyCenterGroupView, didLongPressAt item: MyCenterItemView) {
        guard let id = item.cardID, let card = CGSSDAO.shared.findCardById(id) else {
            return
        }
        let vc = MyCenterEditingViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize.init(width: 240, height: 290)
        vc.delegate = self
        lastSelectedMyCenterItem = item
        vc.setupWith(card: card, potential: item.potential)
        
        let pc = vc.popoverPresentationController
        
        pc?.delegate = self
        pc?.sourceView = item
        pc?.sourceRect = CGRect.init(x: item.fwidth / 2, y: item.fheight / 2, width: 0, height: 0)
        present(vc, animated: true, completion: nil)
    }
    
    func profileMemberEditableView(_ profileMemberEditableView: MyCenterGroupView, didDoubleTap item: MyCenterItemView) {
        lastSelectedMyCenterItem = item
        lastSelectedCenterWantedItem = nil
        navigationController?.pushViewController(cardSelectionViewController, animated: true)
    }
    
    func profileMemberEditableView(_ profileMemberEditableView: MyCenterGroupView, didTap item: MyCenterItemView) {
        
    }
    
}

extension ColleagueComposeViewController: MyCenterEditingViewControllerDelegate {
    
    func didDelete(myCenterEditingViewController: MyCenterEditingViewController) {
        lastSelectedMyCenterItem?.setupWith(cardID: 0)
    }
    
}

extension ColleagueComposeViewController: CenterWantedEditingViewControllerDelegate {
    
    func didDelete(centerWantedEditingViewController: CenterWantedEditingViewController) {
        lastSelectedCenterWantedItem?.setupWith(cardID: 0)
    }
    
}

extension ColleagueComposeViewController: BaseCardTableViewControllerDelegate {
    
    func selectCard(_ card: CGSSCard) {
        lastSelectedCenterWantedItem?.setupWith(cardID: card.id, minLevel: 0)
        lastSelectedMyCenterItem?.setupWith(cardID: card.id, potential: .zero)
    }
    
}

extension ColleagueComposeViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if let vc = popoverPresentationController.presentedViewController as? MyCenterEditingViewController {
            if let view = popoverPresentationController.sourceView as? MyCenterItemView {
                view.setupWith(cardID: view.cardID, potential: vc.potential)
            }
        } else if let vc = popoverPresentationController.presentedViewController as? CenterWantedEditingViewController {
            if let view = popoverPresentationController.sourceView as? CenterWantedItemView {
                view.setupWith(cardID: view.cardID, minLevel: vc.editingView.minLevel)
            }
        }
    }
    
}

extension ColleagueComposeViewController: ColleaColleagueButtonsCellDelegate {
  
    func didSave(_ colleagueButtonsCell: ColleagueButtonsCell) {
        saveProfileFromInput()
        dismissOrPop()
        delegate?.didSave(self)
    }

    func didRevoke(_ colleagueButtonsCell: ColleagueButtonsCell) {
        colleagueButtonsCell.setRevoking(true)
        remote.removeAll { (remoteIdentifiers, errors) in
            DispatchQueue.main.async {
                colleagueButtonsCell.setRevoking(false)
                if errors.count > 0 {
                    UIAlertController.showHintMessage(NSLocalizedString("撤销失败，请确保iCloud已登录并且网络状态正常", comment: ""), in: self)
                } else {
                    UIAlertController.showHintMessage(NSLocalizedString("撤销成功", comment: ""), in: self)
                    self.delegate?.didRevoke(self)
                }
            }
        }
    }
    
}


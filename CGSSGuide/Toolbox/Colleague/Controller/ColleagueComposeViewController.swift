//
//  ColleagueComposeViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import CoreData
import EasyTipView

class ColleagueComposeViewController: BaseTableViewController {
    
    lazy var context: NSManagedObjectContext = self.parentContext.newChildContext()
    
    fileprivate var parentContext: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    lazy var cardSelectionViewController: TeamCardSelectTableViewController = {
        let vc = TeamCardSelectTableViewController()
        vc.delegate = self
        return vc
    }()
    
    private var cells = [UITableViewCell]()
    
    var lastSelectedMyCenterItem: MyCenterItemView?
    var lastSelectedCenterWantedItem: CenterWantedItemView?
    
    var profile: Profile! {
        didSet {
            tableView?.reloadData()
        }
    }

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
        Row(type: ColleagueCentersWantedCell.self, title: NSLocalizedString("希望征集的队长", comment: "")),
        Row(type: ColleagueMessageCell.self, title: NSLocalizedString("留言", comment: "")),
        Row(type: ColleaguePostButton.self, title: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareStaticCells()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView(frame: .zero)
        
        navigationItem.title = NSLocalizedString("我的信息", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("撤销发布", comment: ""), style: .done, target: self, action: #selector(revokeAction))
        navigationItem.rightBarButtonItem?.tintColor = Color.vocal
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.firstTimeComposingMyProfile {
            showTip1((cells[2] as! ColleagueMyCentersCell).infoButton)
            showTip2((cells[3] as! ColleagueCentersWantedCell).infoButton)
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
            tip1 = EasyTipView(text: NSLocalizedString("双击可以从全部卡片中选择，长按可以编辑潜能或者移除偶像，我的队长中至少要填一个位置才能发布", comment: ""), preferences: preferences, delegate: nil)
        }
        if maskView?.superview == nil {
            showMaskView()
        }
        tip1?.show(forView: button)
    }
    
    @objc func showTip2(_ button: UIButton) {
        if tip2 == nil {
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont.boldSystemFont(ofSize: 14)
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.backgroundColor = Color.cool
            tip2 = EasyTipView(text: NSLocalizedString("双击可以从全部卡片中选择，长按可以移除偶像，征集的队长所有位置都可以留空", comment: ""), preferences: preferences, delegate: nil)
        }
        if maskView?.superview == nil {
            showMaskView()
        }
        tip2?.show(forView: button)
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
    
    @objc func revokeAction() {
        UIAlertController.showConfirmAlert(title: NSLocalizedString("确认撤销发布", comment: ""), message: NSLocalizedString("撤销发布后其他人将无法搜索到您的信息，您已编辑过的信息不会被重置，随时可以再次发布。", comment: ""), confirm: {
            // confirmed
        }) {
            // cancelled
        }
    }
    
    private func prepareStaticCells() {
        for index in 0..<rows.count {
            let row = rows[index]
            let cell = row.type.init()
            cells.append(cell)
            (cell as? ColleagueBaseCell)?.setTitle(row.title)
            
            switch cell {
            case let cell as ColleagueMessageCell:
                cell.setup(with: profile.message ?? "")
            case let cell as ColleagueInputCell:
                if index == 0 {
                    cell.setup(with: profile.gameID, keyboardType: .numberPad)
                    cell.checkPattern = "^[0-9]{9}$"
                } else if index == 1 {
                    cell.setup(with: profile.nickName, keyboardType: .default)
                }
            case let cell as ColleagueMyCentersCell:
                cell.setup(profile)
                cell.delegate = self
                cell.infoButton.addTarget(self, action: #selector(showTip1(_:)), for: .touchUpInside)
            case let cell as ColleagueCentersWantedCell:
                cell.setup(profile)
                cell.delegate = self
                cell.infoButton.addTarget(self, action: #selector(showTip2(_:)), for: .touchUpInside)
            case let cell as ColleaguePostButton:
                cell.delegate = self
            default:
                fatalError("undefined cell class in ColleagueComposeViewController")
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
        vc.preferredContentSize = CGSize.init(width: 240, height: 80)
        vc.delegate = self
        lastSelectedCenterWantedItem = item
        vc.setupWith(card: card)
        
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
        lastSelectedCenterWantedItem?.setupWith(cardID: card.id)
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
        }
    }
    
}

extension ColleagueComposeViewController: ColleagueRevokeCellDelegate {

    func didRevoke(_ colleagueRevokeCell: ColleaguePostButton) {

        UIAlertController.showConfirmAlert(title: NSLocalizedString("确认发布", comment: ""), message: NSLocalizedString("同一个iCloud账号只能发布一条信息，发布操作将会覆盖你之前发布的信息", comment: ""), confirm: {
            
        }) {
            
        }
    }
    
}


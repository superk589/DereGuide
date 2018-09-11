//
//  DMComposingStepTwoController.swift
//  DereGuide
//
//  Created by zzk on 31/08/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import CoreData
import EasyTipView

protocol DMComposingStepTwoControllerDelegate: class {
    func didPost(_ colleagueComposeViewController: DMComposingStepTwoController)
    func didSave(_ colleagueComposeViewController: DMComposingStepTwoController)
    func didRevoke(_ colleagueComposeViewController: DMComposingStepTwoController)
}

class DMComposingStepTwoController: BaseTableViewController {
    
    weak var delegate: DMComposingStepTwoControllerDelegate?
    
    var remote: ProfileRemote = ProfileRemote()
    
    lazy var context: NSManagedObjectContext = self.parentContext.newChildContext()
    
    fileprivate var parentContext: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    fileprivate var cells = [UITableViewCell]()
    
    fileprivate var profile: Profile!
    
    struct Row: CustomStringConvertible {
        var type: UITableViewCell.Type
        var description: String {
            return type.description()
        }
        var title: String
    }
    
    var rows: [Row] = [
        Row(type: ColleagueDescriptionCell.self, title: NSLocalizedString("游戏ID", comment: "")),
        Row(type: ColleagueDescriptionCell.self, title: NSLocalizedString("昵称", comment: "")),
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
        indicator.color = .parade
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.firstTimeComposingDMMyProfile {
            showTip2()
            UserDefaults.standard.firstTimeComposingDMMyProfile = false
        }
    }
    
    func setup(dmProfile: DMProfile) {
        profile = Profile.findOrCreate(in: context, dmProfile: dmProfile)
    }
    
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
    
    @objc func showTip2() {
        if tip2 == nil {
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont.boldSystemFont(ofSize: 14)
            preferences.drawing.foregroundColor = .white
            preferences.drawing.backgroundColor = .cool
            tip2 = EasyTipView(text: NSLocalizedString("向所有用户公开您的信息，重复发布会自动覆盖之前的内容并刷新更新时间", comment: ""), preferences: preferences, delegate: nil)
        }
        if maskView?.superview == nil {
            showMaskView()
        }
        tip2?.show(forItem: navigationItem.rightBarButtonItem!)
    }
    
    @objc func hideHelpTips() {
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
            let controllers = navigationController?.viewControllers ?? []
            if controllers.count > 2 {
                navigationController?.popToViewController(controllers[controllers.count - 3], animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func setup(parentProfile: Profile) {
        self.profile = context.object(with: parentProfile.objectID) as? Profile
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
                self.parentContext.saveOrRollback()
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
        
        profile.nickName = (cells[1] as! ColleagueDescriptionCell).rightLabel.text ?? ""
        profile.gameID = (cells[0] as! ColleagueDescriptionCell).rightLabel.text ?? ""
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
            case let cell as ColleagueMyCentersCell:
                cell.infoButton.isHidden = true
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
                (cell as! ColleagueDescriptionCell).setup(detail: profile.gameID)
            case 1:
                (cell as! ColleagueDescriptionCell).setup(detail: profile.nickName)
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

extension DMComposingStepTwoController: UIPopoverPresentationControllerDelegate {
    
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

extension DMComposingStepTwoController: ColleaColleagueButtonsCellDelegate {
    
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

//
//  ColleagueViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import CloudKit
import CoreData
import EasyTipView
import ZKDrawerController

class ColleagueViewController: BaseTableViewController {
    
    lazy var filterController: ColleagueFilterController = {
        let vc = ColleagueFilterController(style: .grouped)
        vc.delegate = self
        return vc
    }()
    
    private var refresher = CGSSRefreshHeader()
    private var loader = CGSSRefreshFooter()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
        
        tableView.register(ColleagueTableViewCell.self, forCellReuseIdentifier: ColleagueTableViewCell.description())
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 159
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none

        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in
            self?.fetchLatestProfiles()
        }
        
        tableView.mj_footer = loader
        loader.refreshingBlock = { [weak self] in
            self?.fetchMore {
                self?.loader.state = self?.cursor == nil ? .noMoreData : .idle
            }
        }
        refresher.beginRefreshing()
    }
    
    var remote = ProfileRemote()
    
    var cursor: CKQueryCursor?
    
    var profiles = [Profile]()
    
    lazy var currentSetting: ColleagueFilterController.FilterSetting = self.filterController.setting
    
    private var isFetching: Bool = false
    
    @objc func fetchLatestProfiles() {
        isFetching = true
        remote.fetchRecordsWith([currentSetting.predicate], [remote.defaultSortDescriptor], resultsLimit: Config.cloudKitFetchLimits) { (remoteProfiles, cursor, error) in
            DispatchQueue.main.async {
                if error != nil {
                    UIAlertController.showHintMessage(NSLocalizedString("获取数据失败，请检查您的网络并确保iCloud处于登录状态", comment: ""), in: nil)
                } else {
                    self.profiles = remoteProfiles.map { Profile.insert(remoteRecord: $0, into: self.childContext) }
                }
                self.isFetching = false
                self.refresher.endRefreshing()
                self.cursor = cursor
                self.loader.state = cursor == nil ? .noMoreData : .idle
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchMore(completion: @escaping () -> ()) {
        guard let cursor = cursor else {
            completion()
            return
        }
        isFetching = true
        remote.fetchRecordsWith(cursor: cursor, resultsLimit: Config.cloudKitFetchLimits) { (remoteProfiles, cursor, error) in
            DispatchQueue.main.async {
                self.isFetching = false
                if error != nil {
                    UIAlertController.showHintMessage(NSLocalizedString("获取数据失败，请检查您的网络并确保iCloud处于登录状态", comment: ""), in: nil)
                } else {
                    let moreProfiles = remoteProfiles.map { Profile.insert(remoteRecord: $0, into: self.childContext) }
                    self.profiles.append(contentsOf: moreProfiles)
                    self.cursor = cursor
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: moreProfiles.enumerated().map { IndexPath.init(row: $0.offset + self.profiles.count - moreProfiles.count, section: 0) }, with: .automatic)
                    self.tableView.endUpdates()
                }
                completion()
            }
        }
        self.cursor = nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ColleagueTableViewCell.description(), for: indexPath) as! ColleagueTableViewCell
        
        cell.setup(profiles[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    var context: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    lazy var profile: Profile = Profile.findOrCreate(in: self.context, configure: { _ in })

    lazy var childContext: NSManagedObjectContext = self.context.newChildContext()
    
    private var item: UIBarButtonItem!
    private func prepareNavigationBar() {
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeAction))
        let filter = UIBarButtonItem(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItems = [compose, filter]
        navigationItem.title = NSLocalizedString("寻找同僚", comment: "")
    }
    
    @objc func composeAction() {
//        let vc = ColleagueComposeViewController()
//        vc.setup(parentProfile: profile)
//        vc.delegate = self
        let vc = DMComposingStepOneController()
        if UIDevice.current.userInterfaceIdiom == .pad {
            let nav = BaseNavigationController(rootViewController: vc)
            let drawer = ZKDrawerController(main: nav)
            drawer.modalPresentationStyle = .formSheet
            present(drawer, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func filterAction() {
        let nav = BaseNavigationController(rootViewController: filterController)
        let drawer = ZKDrawerController(main: nav)
        drawer.modalPresentationStyle = .formSheet
        present(drawer, animated: true, completion: nil)
    }
    
}

extension ColleagueViewController: ColleagueTableViewCellDelegate {
    
    func colleagueTableViewCell(_ cell: ColleagueTableViewCell, didTap cardIcon: CGSSCardIconView) {
        if let cardID = cardIcon.cardID, let card = CGSSDAO.shared.findCardById(cardID) {
            let vc = CDTabViewController(card: card)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @nonobjc func colleagueTableViewCell(_ cell: ColleagueTableViewCell, didTap gameID: String) {
        UIPasteboard.general.string = gameID
        UIAlertController.showHintMessage(NSLocalizedString("已复制ID到剪贴板", comment: ""), in: nil)
    }
}

extension ColleagueViewController: ColleagueComposeViewControllerDelegate {
    
    func didSave(_ colleagueComposeViewController: ColleagueComposeViewController) {
        
    }
    
    func didPost(_ colleagueComposeViewController: ColleagueComposeViewController) {
        refresher.beginRefreshing()
//        fetchLatestProfiles()
    }
    
    func didRevoke(_ colleagueComposeViewController: ColleagueComposeViewController) {
        refresher.beginRefreshing()
//        fetchLatestProfiles()
    }
    
}

extension ColleagueViewController: ColleagueFilterControllerDelegate {
    
    func didDone(_ colleagueFilterController: ColleagueFilterController) {
        currentSetting = filterController.setting
        refresher.beginRefreshing()
//        fetchLatestProfiles()
    }

}

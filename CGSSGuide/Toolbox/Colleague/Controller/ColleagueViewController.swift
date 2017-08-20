//
//  ColleagueViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017年 zzk. All rights reserved.
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
    
    fileprivate var loadMoreCell = LoadMoreTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMoreCell.delegate = self
        
        prepareNavigationBar()
        
        tableView.register(ColleagueTableViewCell.self, forCellReuseIdentifier: ColleagueTableViewCell.description())
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: NSLocalizedString("下拉刷新数据", comment: ""))
        refreshControl?.addTarget(self, action: #selector(fetchLatestProfiles), for: .valueChanged)
        refreshControl?.beginRefreshing()
        fetchLatestProfiles()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl?.endRefreshing()
    }
    
    var remote = ProfileRemote()
    
    var cursor: CKQueryCursor?
    
    var profiles = [Profile]()
    
    lazy var currentSetting: ColleagueFilterController.FilterSetting = self.filterController.setting
    
    private var isFetching: Bool = false
    
    func fetchLatestProfiles() {
        isFetching = true
        remote.fetchRecordsWith([currentSetting.predicate], [remote.defaultSortDescriptor], resultsLimit: Config.cloudKitFetchLimits) { (remoteProfiles, cursor, error) in
            DispatchQueue.main.async {
                if error != nil {
                    UIAlertController.showHintMessage(NSLocalizedString("获取数据失败，请检查您的网络", comment: ""), in: nil)
                } else {
                    self.profiles = remoteProfiles.map { Profile.insert(remoteRecord: $0, into: self.childContext) }
                }
                self.isFetching = false
                self.refreshControl?.endRefreshing()
                self.cursor = cursor
                self.loadMoreCell.setNoMoreData(cursor == nil)
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
                    UIAlertController.showHintMessage(NSLocalizedString("获取数据失败，请检查您的网络", comment: ""), in: nil)
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
        
        switch indexPath.row {
        case ..<profiles.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColleagueTableViewCell.description(), for: indexPath) as! ColleagueTableViewCell
            
            cell.setup(profiles[indexPath.row])
            cell.delegate = self
            return cell
        case profiles.count:
            return loadMoreCell
        default:
            fatalError("wrong index path")
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if profiles.count == 0 {
            return 0
        } else {
            return profiles.count + 1
        }
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
        let vc = ColleagueComposeViewController()
        vc.setup(parentProfile: profile)
        vc.delegate = self
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
        if let cardID = cardIcon.cardId, let card = CGSSDAO.shared.findCardById(cardID) {
            let vc = CardDetailViewController()
            vc.card = card
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @nonobjc func colleagueTableViewCell(_ cell: ColleagueTableViewCell, didTap gameID: String) {
        UIPasteboard.general.string = gameID
        UIAlertController.showHintMessage("已复制ID到剪贴板", in: nil)
    }
}

extension ColleagueViewController: ColleagueComposeViewControllerDelegate {
    
    func didSave(_ colleagueComposeViewController: ColleagueComposeViewController) {
        
    }
    
    func didPost(_ colleagueComposeViewController: ColleagueComposeViewController) {
        fetchLatestProfiles()
    }
    
    func didRevoke(_ colleagueComposeViewController: ColleagueComposeViewController) {
        fetchLatestProfiles()
    }
    
}

extension ColleagueViewController: ColleagueFilterControllerDelegate {
    
    func didDone(_ colleagueFilterController: ColleagueFilterController) {
        currentSetting = filterController.setting
        fetchLatestProfiles()
    }

}

extension ColleagueViewController: LoadMoreTableViewCellDelegate {
    func didLoadMore(_ loadMoreTableViewCell: LoadMoreTableViewCell) {
        loadMoreTableViewCell.loadMoreButton.setLoading(true)
        fetchMore {
            loadMoreTableViewCell.setNoMoreData(self.cursor == nil)
            loadMoreTableViewCell.loadMoreButton.setLoading(false)
        }
    }
}

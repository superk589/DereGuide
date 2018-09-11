//
//  VLTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/8/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

class VLTableViewController: UITableViewController {
    
    var models = [VersionLog.DataElement]()
    
    var currentPage = 1 {
        didSet {
            if currentPage == 1 {
                models.removeAll()
            }
            requestData(page: currentPage)
        }
    }
    
    let header = CGSSRefreshHeader()
    
    let footer = CGSSRefreshFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Version Log", comment: "")
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.estimatedSectionHeaderHeight = 60
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.register(VLTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: VLTableViewHeaderFooterView.description())
        tableView.register(VLNoScheduleTableViewCell.self, forCellReuseIdentifier: VLNoScheduleTableViewCell.description())
        tableView.register(VLTableViewCell.self, forCellReuseIdentifier: VLTableViewCell.description())
        
        tableView.mj_header = header
        header.refreshingBlock = { [weak self] in
            self?.currentPage = 1
        }
        
        tableView.mj_footer = footer
        footer.refreshingBlock = { [weak self] in
            self?.currentPage += 1
        }
        
        header.beginRefreshing()
    
    }
    
    func requestData(page: Int) {
        let currentPage = self.currentPage
        BaseRequest.default.getWith(urlString: "https://redive.estertion.win/ver_log_cgss/", params: ["page": String(page)]) { [weak self] (data, response, error) in
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let versionLog = try decoder.decode(VersionLog.self, from: data!)
                    DispatchQueue.main.async {
                        if currentPage > versionLog.pages {
                            self?.footer.state = .noMoreData
                        } else {
                            self?.footer.state = .idle
                            self?.models += versionLog.data
                            self?.tableView.reloadData()
                        }
                    }
                } catch let error {
                    print(error)
                    DispatchQueue.main.async {
                        self?.footer.endRefreshing()
                    }
                }
            } else {
                print(error!)
            }
            DispatchQueue.main.async {
                self?.header.endRefreshing()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: VLTableViewHeaderFooterView.description()) as! VLTableViewHeaderFooterView
        let model = models[section]
        header.configure(title: model.ver, subTitle: Date(timeIntervalSince1970: TimeInterval(model.time)).toString(format: "(zzz)yyyy-MM-dd HH:mm:ss", timeZone: .current))
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].list[indexPath.row]
        if model.schedule != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: VLTableViewCell.description(), for: indexPath) as! VLTableViewCell
            cell.configure(for: model)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: VLNoScheduleTableViewCell.description(), for: indexPath) as! VLNoScheduleTableViewCell
            cell.configure(for: model)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].list.count
    }
}

//
//  WipeTableViewController.swift
//  DereGuide
//
//  Created by zzk on 2016/10/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SDWebImage


class WipeTableViewController: BaseTableViewController {

    var dataTypes = [NSLocalizedString("全选", comment: ""),
                     NSLocalizedString("图片", comment: ""),
                     NSLocalizedString("卡片", comment: ""),
                     NSLocalizedString("歌曲", comment: ""),
                     NSLocalizedString("用户配置", comment: "") + "（" + NSLocalizedString("需重启应用", comment: "") + "）",
                     NSLocalizedString("其他", comment: "")]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelection = true
        tableView.setEditing(true, animated: true)
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.register(WipeTableViewCell.self, forCellReuseIdentifier: "WipeCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(wipeData))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    @objc func wipeData() {
        CGSSLoadingHUDManager.default.show()
        if let selectedIndexPaths = self.tableView.indexPathsForSelectedRows {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                for indexPath in selectedIndexPaths {
                    switch indexPath.row {
                    case 1:
                        CGSSCacheManager.shared.wipeImage()
                    case 2:
                        CGSSCacheManager.shared.wipeCard()
                        let dao = CGSSDAO.shared
                        dao.getDictForKey(.card).removeAllObjects()
                        dao.getDictForKey(.char).removeAllObjects()
                        dao.getDictForKey(.leaderSkill).removeAllObjects()
                        dao.getDictForKey(.skill).removeAllObjects()
                        NotificationCenter.default.post(name: .dataRemoved, object: self, userInfo: [CGSSUpdateDataTypesName: CGSSUpdateDataTypes.card])
                    case 3:
                        CGSSCacheManager.shared.wipeLive()
                        NotificationCenter.default.post(name: .dataRemoved, object: self, userInfo: [CGSSUpdateDataTypesName: CGSSUpdateDataTypes.beatmap])
                    case 4:
                        CGSSCacheManager.shared.wipeUserDocuments()
                    case 5:
                        CGSSCacheManager.shared.wipeOther()
                        NotificationCenter.default.post(name: .dataRemoved, object: self, userInfo: [CGSSUpdateDataTypesName: CGSSUpdateDataTypes.master])
                    default:
                        break
                    }
                }
                DispatchQueue.main.async {
                    CGSSLoadingHUDManager.default.hide()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataTypes.count
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.delete.rawValue | UITableViewCellEditingStyle.insert.rawValue)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WipeCell", for: indexPath) as! WipeTableViewCell
        if indexPath.row > 0 {
            //let indicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
            //cell?.accessoryView = indicator
            //indicator.startAnimating()
            cell.rightLabel?.text = "...."
        } else {
            //cell?.accessoryView = nil
            cell.rightLabel?.text = ""
        }
        
        switch indexPath.row {
        case 1:
            CGSSCacheManager.shared.getCacheSizeAt(path: (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first ?? "") + "/default", complete: { (sizeString) in
                cell.rightLabel?.text = sizeString
            })
        case 2:
            CGSSCacheManager.shared.getCacheSizeOfCard(complete: { (sizeString) in
                cell.rightLabel?.text = sizeString
            })
        case 3:
            CGSSCacheManager.shared.getCacheSizeOfSong(complete: { (sizeString) in
                cell.rightLabel?.text = sizeString
            })
        case 4:
            CGSSCacheManager.shared.getCacheSizeAt(path: NSHomeDirectory() + "/Documents", complete: { (sizeString) in
                cell.rightLabel?.text = sizeString
            })
        case 5:
            CGSSCacheManager.shared.getOtherSize(complete: { (sizeString) in
                cell.rightLabel?.text = sizeString
            })
        default:
            break
        }

        cell.leftLabel?.text = dataTypes[indexPath.row]
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            for i in 1..<dataTypes.count {
                tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            for i in 1..<dataTypes.count {
                tableView.deselectRow(at: IndexPath.init(row: i, section: 0), animated: false)
            }
        } else {
            tableView.deselectRow(at: IndexPath.init(row: 0, section: 0), animated: false)
        }
    }
}

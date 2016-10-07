//
//  WipeTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SDWebImage


class WipeTableViewController: UITableViewController {

    var dataTypes = [NSLocalizedString("全选", comment: ""),
                     NSLocalizedString("图片", comment: ""),
                     NSLocalizedString("卡片", comment: ""),
                     NSLocalizedString("歌曲", comment: ""),
                     NSLocalizedString("用户配置", comment: ""),
                     NSLocalizedString("其他", comment: "")]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelection = true
        tableView.setEditing(true, animated: true)
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(wipeData))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func wipeData() {
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async {
            if let selectedIndexPaths = self.tableView.indexPathsForSelectedRows {
                for indexPath in selectedIndexPaths {
                    switch indexPath.row {
                    case 1:
                        self.wipeImage()
                    case 2:
                        self.wipeCard()
                        let dao = CGSSDAO.sharedDAO
                        dao.getDictForKey(.card).removeAllObjects()
                        dao.getDictForKey(.cardIcon).removeAllObjects()
                        dao.getDictForKey(.char).removeAllObjects()
                        dao.getDictForKey(.storyContent).removeAllObjects()
                        dao.getDictForKey(.storyEpisode).removeAllObjects()
                        dao.getDictForKey(.leaderSkill).removeAllObjects()
                        dao.getDictForKey(.skill).removeAllObjects()
                    case 3:
                        self.wipeSong()
                        let dao = CGSSDAO.sharedDAO
                        dao.getDictForKey(.live).removeAllObjects()
                        dao.getDictForKey(.song).removeAllObjects()
                    case 4:
                        self.wipeUserDocuments()
                    case 5:
                        self.wipeOther()
                    default:
                        break
                    }
                }
            }
            CGSSUpdater.defaultUpdater.setCurrentDataVersion("0", minor: "0")
            DispatchQueue.main.async {
                CGSSLoadingHUDManager.default.hide()
                self.tableView.reloadData()
            }
        }
        
    }

    func wipeImage() {
        SDImageCache.shared().clearDisk()
        if let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first {
            let subPath = cachePath + "/default"
            if (FileManager.default.fileExists(atPath: subPath)) {
                do {
                    try FileManager.default.removeItem(atPath: subPath)
                } catch {
                    
                }
            }
        }
    }
    
    func wipeCard() {
        for path in getCardFiles() {
            if (FileManager.default.fileExists(atPath: path)) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    
                }
            }
        }
    }
    
    func wipeSong() {
        for path in getSongFiles() {
            if (FileManager.default.fileExists(atPath: path)) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    
                }
            }
        }
    }
    
    func wipeUserDocuments() {
        let documentPath = NSHomeDirectory() + "/Documents"
        if let files = FileManager.default.subpaths(atPath: documentPath) {
            for file in files {
                let path = documentPath.appendingFormat("/\(file)")
                if (FileManager.default.fileExists(atPath: path)) {
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func wipeOther() {
        if let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first {
            if let files = FileManager.default.subpaths(atPath: cachePath) {
                for file in files {
                    let path = cachePath.appendingFormat("/\(file)")
                    if file.contains("default") || file.contains("Data") {
                        continue
                    }
                    if (FileManager.default.fileExists(atPath: path)) {
                        do {
                            try FileManager.default.removeItem(atPath: path)
                        } catch {
                            
                        }
                    }
                }
            }
        }
    }
    
    func sizeToString(size:Int) -> String {
        var postString = "KB"
        var newSize = size
        if size > 1024 * 1024 {
            newSize /= 1024 * 1024
            postString = "MB"
        } else if size > 1024 {
            newSize /= 1024
        } else {
            // 小于1KB 忽略
            newSize = 0
        }
        return String(newSize) + postString
    }
    
    func getCardFiles() -> [String] {
        var filePaths = [String]()
        if let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first {
            let subPath = cachePath + "/Data"
            let files = ["card_icon.plist",
                         "card.plist",
                         "char.plist",
                         "leader_skill.plist",
                         "skill.plist",
                         "story_content.plist",
                         "story_episode.plist"]
            for file in files {
                let path = subPath.appendingFormat("/\(file)")
                filePaths.append(path)
            }
        }
        return filePaths
    }
    
    func getSongFiles() -> [String] {
        var filePaths = [String]()
        if let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first {
            let subPath = cachePath + "/Data"
            let files = ["live.plist",
                         "song.plist"]
            
            for file in files {
                let path = subPath.appendingFormat("/\(file)")
                filePaths.append(path)
            }
            
            let subPath2 = cachePath + "/Data/Beatmap"
            if let files = FileManager.default.subpaths(atPath: subPath2) {
                for file in files {
                    let path = subPath2.appendingFormat("/\(file)")
                    filePaths.append(path)
                }
            }
        }
        return filePaths
    }
    func getCacheSizeOfCard(complete:((String)->Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            var size = 0
            for path in self.getCardFiles() {
                if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
                    size += (attributes[FileAttributeKey.size] as! NSNumber).intValue
                }
            }
            DispatchQueue.main.async(execute: {
                complete?(self.sizeToString(size: size))
            })
        }
    }
    

    func getCacheSizeOfSong(complete:((String)->Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            var size = 0
            for path in self.getSongFiles() {
                if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
                    size += (attributes[FileAttributeKey.size] as! NSNumber).intValue
                }
            }
            DispatchQueue.main.async(execute: {
                complete?(self.sizeToString(size: size))
            })
        }
    }

    func getCacheSizeAt(path:String, complete:((String)->Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let files = FileManager.default.subpaths(atPath: path) {
                var size = 0
                for file in files {
                    let path = path.appendingFormat("/\(file)")
                    if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
                        size += (attributes[FileAttributeKey.size] as! NSNumber).intValue
                    }
                }
                DispatchQueue.main.async(execute: {
                    complete?(self.sizeToString(size: size))
                })
            }
        }
    }
    
    func getOtherSize(complete:((String)->Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first {
                if let files = FileManager.default.subpaths(atPath: cachePath) {
                    var size = 0
                    for file in files {
                        let path = cachePath.appendingFormat("/\(file)")
                        if file.contains("default") || file.contains("Data") {
                            continue
                        }
                        if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
                            size += (attributes[FileAttributeKey.size] as! NSNumber).intValue
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        complete?(self.sizeToString(size: size))
                    })
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "WipeCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "WipeCell")
        }
        if indexPath.row > 0 {
            //let indicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
            //cell?.accessoryView = indicator
            //indicator.startAnimating()
            cell?.detailTextLabel?.text = "...."
        } else {
            //cell?.accessoryView = nil
            cell?.detailTextLabel?.text = ""
        }
        
        switch indexPath.row {
        case 1:
            getCacheSizeAt(path: (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first ?? "") + "/default", complete: { (sizeString) in
                cell?.detailTextLabel?.text = sizeString
            })
        case 2:
            getCacheSizeOfCard(complete: { (sizeString) in
                cell?.detailTextLabel?.text = sizeString
            })
        case 3:
            getCacheSizeOfSong(complete: { (sizeString) in
                cell?.detailTextLabel?.text = sizeString
            })
        case 4:
            getCacheSizeAt(path: NSHomeDirectory() + "/Documents", complete: { (sizeString) in
                cell?.detailTextLabel?.text = sizeString
            })
        case 5:
            getOtherSize(complete: { (sizeString) in
                cell?.detailTextLabel?.text = sizeString
            })
        default:
            break
        }

        cell?.textLabel?.text = dataTypes[indexPath.row]
        // Configure the cell...
        return cell!
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

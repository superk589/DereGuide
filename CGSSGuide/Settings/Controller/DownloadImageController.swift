//
//  DownloadImageController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/2/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SDWebImage

typealias DownloadImageCell = WipeTableViewCell

class DownloadImageController: BaseTableViewController, UpdateStatusViewDelegate {
    
    var updateStatusView: UpdateStatusView!
    
    var dataTypes = [NSLocalizedString("全选", comment: ""),
                     NSLocalizedString("卡片大图", comment: ""),
                     NSLocalizedString("卡片图", comment: ""),
                     NSLocalizedString("卡片头像", comment: ""),
                     NSLocalizedString("签名图", comment: ""),
                     NSLocalizedString("角色头像", comment: ""),
                     NSLocalizedString("歌曲封面", comment: ""),
                     NSLocalizedString("活动封面", comment: ""),
                     NSLocalizedString("卡池封面", comment: "")]
    
    var spreadTotal = [URL]() {
        didSet {
            setupCellAtIndex(1)
        }
    }
    var spreadNeedToDownload = [URL]() {
        didSet {
            setupCellAtIndex(1)
        }
    }
    
    var cardImageTotal = [URL]() {
        didSet {
            setupCellAtIndex(2)
        }
    }
    var cardImageNeedToDownload = [URL]() {
        didSet {
            setupCellAtIndex(2)
        }
    }

    
    var cardIconTotal = [URL]() {
        didSet {
            setupCellAtIndex(3)
        }
    }
    var cardIconNeedToDownload = [URL]() {
        didSet {
            setupCellAtIndex(3)
        }
    }
    
    var cardSignTotal = [URL]() {
        didSet {
            setupCellAtIndex(4)
        }
    }
    var cardSignNeedToDownload = [URL]() {
        didSet {
            setupCellAtIndex(4)
        }
    }
    
    var charIconTotal = [URL]() {
        didSet {
            setupCellAtIndex(5)
        }
    }
    var charIconNeedToDownload = [URL]() {
        didSet {
            setupCellAtIndex(5)
        }
    }
    
    var jacketTotal = [URL]() {
        didSet {
            setupCellAtIndex(6)
        }
    }
    var jacketNeedToDownload = [URL]() {
        didSet {
            setupCellAtIndex(6)
        }
    }
    
    var eventTotal = [URL]() {
        didSet {
            setupCellAtIndex(7)
        }
    }
    var eventNeedToDownload = [URL]() {
        didSet {
            setupCellAtIndex(7)
        }
    }
    
    var gachaTotal = [URL]() {
        didSet {
            setupCellAtIndex(8)
        }
    }
    var gachaNeedToDownload = [URL]() {
        didSet {
            setupCellAtIndex(8)
        }
    }
    
    func getURLsOfNeedToDownloadBy(index: Int) -> [URL] {
        switch index {
        case 1:
            return spreadNeedToDownload
        case 2:
            return cardImageNeedToDownload
        case 3:
            return cardIconNeedToDownload
        case 4:
            return cardSignNeedToDownload
        case 5:
            return charIconNeedToDownload
        case 6:
            return jacketNeedToDownload
        case 7:
            return eventNeedToDownload
        case 8:
            return gachaNeedToDownload
        default:
            return [URL]()
        }
    }

    func getURLsBy(index: Int) -> [URL] {
        switch index {
        case 1:
            return spreadTotal
        case 2:
            return cardImageTotal
        case 3:
            return cardIconTotal
        case 4:
            return cardSignTotal
        case 5:
            return charIconTotal
        case 6:
            return jacketTotal
        case 7:
            return eventTotal
        case 8:
            return gachaTotal
        default:
            return [URL]()
        }

    }
    
    func setupCellAtIndex(_ index: Int) {
        DispatchQueue.main.async {
            let cell = self.tableView.cellForRow(at: IndexPath.init(row: index, section: 0))
            let total = self.getURLsBy(index: index).count
            let needToDownload = self.getURLsOfNeedToDownloadBy(index: index).count
            cell?.detailTextLabel?.text = "\(total - needToDownload)/\(total)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = true
        tableView.setEditing(true, animated: true)
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.register(DownloadImageCell.self, forCellReuseIdentifier: "CacheCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "703-download"), style: .plain, target: self, action: #selector(cacheData))
        
        updateStatusView = UpdateStatusView.init(frame: CGRect(x: 0, y: 0, width: 240, height: 50))
        updateStatusView.center = view.center
        updateStatusView.center.y = view.center.y - 120
        updateStatusView.isHidden = true
        updateStatusView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(updateStatusView)
        
        calculate()
        // Do any additional setup after loading the view.
    }
    
    func calculate() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.removeAllURLs()
            
            let cards = CGSSDAO.sharedDAO.cardDict.allValues as! [CGSSCard]
        
            let chars = CGSSDAO.sharedDAO.charDict.allValues as! [CGSSChar]
            // 所有卡片大图和头像图
            for card in cards {
                // 卡片大图
                if card.hasSpread! {
                    if let url = URL.init(string: card.spreadImageRef!) {
                        self.spreadTotal.append(url)
                        SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                            if !isInCache {
                                self.spreadNeedToDownload.append(url)
                            }
                        })
                    }
                }
                // 卡头像图
                if let url = URL.init(string: DataURL.Images + "/icon_card/\(card.id!).png") {
                    self.cardIconTotal.append(url)
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if !isInCache {
                            self.cardIconNeedToDownload.append(url)
                        }
                    })
                    
                }
                
                // 卡签名图
                if let url = card.signImageURL {
                    self.cardSignTotal.append(url)
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if !isInCache {
                            self.cardSignNeedToDownload.append(url)
                        }
                    })
                }
                
                // 卡片图
                if let url = URL.init(string: card.cardImageRef) {
                    self.cardImageTotal.append(url)
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if !isInCache {
                            self.cardImageNeedToDownload.append(url)
                        }
                    })
                }

            }
            
            for char in chars {
                // 角色头像图
                if let url = URL.init(string: DataURL.Images + "/icon_char/\(char.charaId!).png") {
                    self.charIconTotal.append(url)
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if !isInCache {
                            self.charIconNeedToDownload.append(url)
                        }
                    })
                }
            }
            
            // 所有歌曲封面图
            let lives = Array(CGSSDAO.sharedDAO.validLiveDict.values)
            for live in lives {
                let song = CGSSDAO.sharedDAO.findSongById(live.musicId!)
                if let url = song?.jacketURL {
                    self.jacketTotal.append(url)
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if !isInCache {
                            self.jacketNeedToDownload.append(url)
                        }
                    })
                }
            }
            
            let events = CGSSGameResource.shared.getEvent()
            for event in events {
                if let url = event.detailBannerURL {
                    self.eventTotal.append(url)
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if !isInCache {
                            self.eventNeedToDownload.append(url)
                        }
                    })

                }
            }
            
            let gachaPools = CGSSGameResource.shared.getGachaPool()
            for gachaPool in gachaPools {
                if let url = gachaPool.detailBannerURL {
                    self.gachaTotal.append(url)
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if !isInCache {
                            self.gachaNeedToDownload.append(url)
                        }
                    })
                    
                }
            }

        }
    }
    func removeAllURLs() {
        self.cardIconNeedToDownload.removeAll()
        self.cardIconTotal.removeAll()
        self.spreadTotal.removeAll()
        self.spreadNeedToDownload.removeAll()
        self.cardSignTotal.removeAll()
        self.cardSignNeedToDownload.removeAll()
        self.cardImageTotal.removeAll()
        self.cardImageNeedToDownload.removeAll()
        self.charIconTotal.removeAll()
        self.charIconNeedToDownload.removeAll()
        self.eventTotal.removeAll()
        self.eventNeedToDownload.removeAll()
        self.gachaTotal.removeAll()
        self.gachaNeedToDownload.removeAll()
        self.jacketTotal.removeAll()
        self.jacketNeedToDownload.removeAll()
    }
    
    func cacheData() {
        var urls = [URL]()
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                urls.append(contentsOf: getURLsOfNeedToDownloadBy(index: indexPath.row))
            }
        }
        
        self.updateStatusView.setContent(NSLocalizedString("缓存所有图片", comment: "设置页面"), total: urls.count)
        
        CGSSUpdater.defaultUpdater.isUpdating = true
        // SDWebImagePrefetcher默认在主线程, 此处改为子线程
        SDWebImagePrefetcher.shared().prefetcherQueue = DispatchQueue.global(qos: .userInitiated)
        SDWebImagePrefetcher.shared().prefetchURLs(urls, progress: { (a, b) in
            DispatchQueue.main.async(execute: {
                self.updateStatusView.updateProgress(Int(a), b: Int(b))
            })
        }, completed: { (a, b) in
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController.init(title: NSLocalizedString("缓存图片完成", comment: "设置页面"), message: "\(NSLocalizedString("成功", comment: "设置页面")) \(a - b), \(NSLocalizedString("失败", comment: "设置页面")) \(b)", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "设置页面"), style: .default, handler: nil))
                self.tabBarController?.present(alert, animated: true, completion: nil)
                self.updateStatusView.isHidden = true
                self.calculate()
            })
            CGSSUpdater.defaultUpdater.isUpdating = false
        })
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CacheCell", for: indexPath) as! DownloadImageCell
        if indexPath.row == 0 {
            cell.detailTextLabel?.text = ""
        } else {
            setupCellAtIndex(indexPath.row)
        }
        cell.textLabel?.text = dataTypes[indexPath.row]
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
    

    func cancelUpdate() {
        SDWebImagePrefetcher.shared().cancelPrefetching()
        CGSSUpdater.defaultUpdater.isUpdating = false
        let alvc = UIAlertController.init(title: NSLocalizedString("缓存图片取消", comment: "设置页面"), message: NSLocalizedString("缓存图片已被中止", comment: "设置页面"), preferredStyle: .alert)
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "设置页面"), style: .cancel, handler: nil))
        self.tabBarController?.present(alvc, animated: true, completion: nil)
        //updateCacheSize()
        self.calculate()
    }

}

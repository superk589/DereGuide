//
//  DownloadImageViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/2/2.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SDWebImage

typealias DownloadImageCell = WipeTableViewCell

class DownloadImageViewController: UITableViewController {
    
    var dataTypes = [NSLocalizedString("全选", comment: ""),
                     NSLocalizedString("卡片大图", comment: ""),
                     NSLocalizedString("卡片图", comment: ""),
                     NSLocalizedString("卡片头像", comment: ""),
                     NSLocalizedString("签名图", comment: ""),
                     NSLocalizedString("角色头像", comment: ""),
                     NSLocalizedString("歌曲封面", comment: ""),
                     NSLocalizedString("活动封面", comment: ""),
                     NSLocalizedString("卡池封面", comment: ""),
                     NSLocalizedString("卡片 Sprite 图", comment: "")]
    
    private struct ResourceURLs {
        var inCache = [URL]()
        var needToDownload = [URL]()
        
        var count: Int {
            return inCache.count + needToDownload.count
        }
        
        mutating func removeAll() {
            inCache.removeAll()
            needToDownload.removeAll()
        }
    }
    
    private var spreadURLs = ResourceURLs() {
        didSet {
            setupCellAtIndex(1)
        }
    }
    
    private var cardImageURLs = ResourceURLs() {
        didSet {
            setupCellAtIndex(2)
        }
    }
    
    private var cardIconURLs = ResourceURLs() {
        didSet {
            setupCellAtIndex(3)
        }
    }
    
    private var cardSignURLs = ResourceURLs() {
        didSet {
            setupCellAtIndex(4)
        }
    }
   
    private var charIconURLs = ResourceURLs() {
        didSet {
            setupCellAtIndex(5)
        }
    }
    
    private var jacketURLs = ResourceURLs() {
        didSet {
            setupCellAtIndex(6)
        }
    }
   
    private var eventURLs = ResourceURLs() {
        didSet {
            setupCellAtIndex(7)
        }
    }
   
    private var gachaURLs = ResourceURLs() {
        didSet {
            setupCellAtIndex(8)
        }
    }
    
    private var cardSpriteURLs = ResourceURLs() {
        didSet {
            setupCellAtIndex(9)
        }
    }
    
    private func getURLsBy(index: Int) -> ResourceURLs {
        switch index {
        case 1:
            return spreadURLs
        case 2:
            return cardImageURLs
        case 3:
            return cardIconURLs
        case 4:
            return cardSignURLs
        case 5:
            return charIconURLs
        case 6:
            return jacketURLs
        case 7:
            return eventURLs
        case 8:
            return gachaURLs
        case 9:
            return cardSpriteURLs
        default:
            return ResourceURLs()
        }

    }
    
    func setupCellAtIndex(_ index: Int) {
        DispatchQueue.main.async {
            let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DownloadImageCell
            let urls = self.getURLsBy(index: index)
            cell?.rightLabel.text = "\(urls.inCache.count)/\(urls.count)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = true
        tableView.setEditing(true, animated: true)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(DownloadImageCell.self, forCellReuseIdentifier: "CacheCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "703-download"), style: .plain, target: self, action: #selector(cacheData))
        
        tableView.rowHeight = 44
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        calculate()
        // Do any additional setup after loading the view.
    }
    
    func calculate() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.removeAllURLs()
            
            let cards = CGSSDAO.shared.cardDict.allValues as! [CGSSCard]
        
            let chars = CGSSDAO.shared.charDict.allValues as! [CGSSChar]
            // 所有卡片大图和头像图
            for card in cards {
                // 卡片大图
                if card.hasSpread! {
                    if let url = URL(string: card.spreadImageRef!), let key = SDWebImageManager.shared.cacheKey(for: url) {
                        SDImageCache.shared.diskImageExists(withKey: key, completion: { (isInCache) in
                            if isInCache {
                                self.spreadURLs.inCache.append(url)
                            } else {
                                self.spreadURLs.needToDownload.append(url)
                            }
                        })
                    }
                }
                
                // 卡头像图
                let url = URL.images.appendingPathComponent("/icon_card/\(card.id!).png")
                if let key = SDWebImageManager.shared.cacheKey(for: url) {
                    SDImageCache.shared.diskImageExists(withKey: key, completion: { (isInCache) in
                        if isInCache {
                            self.cardIconURLs.inCache.append(url)
                        } else {
                            self.cardIconURLs.needToDownload.append(url)
                        }
                    })
                }
                
                // 卡签名图
                if let url = card.signImageURL, let key = SDWebImageManager.shared.cacheKey(for: url) {
                    SDImageCache.shared.diskImageExists(withKey: key, completion: { (isInCache) in
                        if isInCache {
                            self.cardSignURLs.inCache.append(url)
                        } else {
                            self.cardSignURLs.needToDownload.append(url)
                        }
                    })
                }
                
                // 卡片图
                if let url = URL(string: card.cardImageRef), let key = SDWebImageManager.shared.cacheKey(for: url) {
                    SDImageCache.shared.diskImageExists(withKey: key, completion: { (isInCache) in
                        if isInCache {
                            self.cardImageURLs.inCache.append(url)
                        } else {
                            self.cardImageURLs.needToDownload.append(url)
                        }
                    })
                }

                // sprite 图
                if let url = card.spriteImageURL, let key = SDWebImageManager.shared.cacheKey(for: url) {
                    SDImageCache.shared.diskImageExists(withKey: key, completion: { (isInCache) in
                        if isInCache {
                            self.cardSpriteURLs.inCache.append(url)
                        } else {
                            self.cardSpriteURLs.needToDownload.append(url)
                        }
                    })
                }
            }
            
            for char in chars {
                // 角色头像图
                let url = URL.images.appendingPathComponent("/icon_char/\(char.charaId!).png")
                if let key = SDWebImageManager.shared.cacheKey(for: url) {
                    SDImageCache.shared.diskImageExists(withKey: key, completion: { (isInCache) in
                        if isInCache {
                            self.charIconURLs.inCache.append(url)
                        } else {
                            self.charIconURLs.needToDownload.append(url)
                        }
                    })
                }
            }
            
            // 所有歌曲封面图
            CGSSGameResource.shared.master.getLives(callback: { (lives) in
                for live in lives {
                    let url = live.jacketURL
                    if let key = SDWebImageManager.shared.cacheKey(for: url) {
                        SDImageCache.shared.diskImageExists(withKey: key, completion: { (isInCache) in
                            if isInCache {
                                self.jacketURLs.inCache.append(url)
                            } else {
                                self.jacketURLs.needToDownload.append(url)
                            }
                        })
                    }
                }
            })
            
            
            CGSSGameResource.shared.master.getEvents(callback: { (events) in
                for event in events {
                    if let url = event.detailBannerURL, let key = SDWebImageManager.shared.cacheKey(for: url) {
                        SDImageCache.shared.diskImageExists(withKey: key, completion: { (isInCache) in
                            if isInCache {
                                self.eventURLs.inCache.append(url)
                            } else {
                                self.eventURLs.needToDownload.append(url)
                            }
                        })
                    }
                }
            })
            
            CGSSGameResource.shared.master.getValidGacha(callback: { (pools) in
                for gachaPool in pools {
                    if let url = gachaPool.detailBannerURL, ![30001, 30006].contains(gachaPool.id), let key = SDWebImageManager.shared.cacheKey(for: url) {
                        // 温泉旅行和初始卡池的图片目前缺失, 故不加入待下载列表
                        SDImageCache.shared.diskImageExists(withKey: key, completion: { (isInCache) in
                            if isInCache {
                                self.gachaURLs.inCache.append(url)
                            } else {
                                self.gachaURLs.needToDownload.append(url)
                            }
                        })
                    }
                }
            })
            
        }
    }
    func removeAllURLs() {
        cardIconURLs.removeAll()
        spreadURLs.removeAll()
        cardImageURLs.removeAll()
        cardSignURLs.removeAll()
        charIconURLs.removeAll()
        eventURLs.removeAll()
        jacketURLs.removeAll()
        gachaURLs.removeAll()
        cardSpriteURLs.removeAll()
    }
    
    @objc private func cacheData() {
        if CGSSUpdater.default.isWorking || CGSSGameResource.shared.isProcessing { return }
        var urls = [URL]()
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                urls.append(contentsOf: getURLsBy(index: indexPath.row).needToDownload)
            }
        }
        CGSSUpdatingHUDManager.shared.show()
        CGSSUpdatingHUDManager.shared.cancelAction = { [weak self] in
            SDWebImagePrefetcher.shared.cancelPrefetching()
            CGSSUpdater.default.isUpdating = false
            self?.calculate()
        }
        CGSSUpdatingHUDManager.shared.setup(current: 0, total: urls.count, animated: true, cancelable: true)
        
        CGSSUpdater.default.updateImages(urls: urls, progress: { (a, b) in
            DispatchQueue.main.async {
                CGSSUpdatingHUDManager.shared.setup(current: a, total: b, animated: true, cancelable: true)
            }
        }) { [weak self] (a, b) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("缓存图片完成", comment: "设置页面"), message: "\(NSLocalizedString("成功", comment: "设置页面")) \(a), \(NSLocalizedString("失败", comment: "设置页面")) \(b - a)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "设置页面"), style: .default, handler: nil))
                UIViewController.root?.present(alert, animated: true, completion: nil)
                CGSSUpdatingHUDManager.shared.hide(animated: false)
                self?.calculate()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTypes.count
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.init(rawValue: UITableViewCell.EditingStyle.delete.rawValue | UITableViewCell.EditingStyle.insert.rawValue)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CacheCell", for: indexPath) as! DownloadImageCell
        if indexPath.row == 0 {
            cell.rightLabel.text = ""
        } else {
            setupCellAtIndex(indexPath.row)
        }
        cell.leftLabel.text = dataTypes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            for i in 1..<dataTypes.count {
                tableView.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            for i in 1..<dataTypes.count {
                tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: false)
            }
        } else {
            tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: false)
        }
    }

}

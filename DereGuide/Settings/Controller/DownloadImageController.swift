//
//  DownloadImageController.swift
//  DereGuide
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
        default:
            return ResourceURLs()
        }

    }
    
    func setupCellAtIndex(_ index: Int) {
        DispatchQueue.main.async {
            let cell = self.tableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? DownloadImageCell
            let urls = self.getURLsBy(index: index)
            cell?.rightLabel?.text = "\(urls.inCache.count)/\(urls.count)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = true
        tableView.setEditing(true, animated: true)
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.register(DownloadImageCell.self, forCellReuseIdentifier: "CacheCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "703-download"), style: .plain, target: self, action: #selector(cacheData))
        
        updateStatusView = UpdateStatusView()
        updateStatusView.isHidden = true
        updateStatusView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(updateStatusView)
        updateStatusView.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-95)
        }
        
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
                    if let url = URL.init(string: card.spreadImageRef!) {
                        SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
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
                SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                    if isInCache {
                        self.cardIconURLs.inCache.append(url)
                    } else {
                        self.cardIconURLs.needToDownload.append(url)
                    }
                })
                
                // 卡签名图
                if let url = card.signImageURL {
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if isInCache {
                            self.cardSignURLs.inCache.append(url)
                        } else {
                            self.cardSignURLs.needToDownload.append(url)
                        }
                    })
                }
                
                // 卡片图
                if let url = URL.init(string: card.cardImageRef) {
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if isInCache {
                            self.cardImageURLs.inCache.append(url)
                        } else {
                            self.cardImageURLs.needToDownload.append(url)
                        }
                    })
                }

            }
            
            for char in chars {
                // 角色头像图
                let url = URL.images.appendingPathComponent("/icon_char/\(char.charaId!).png")
                SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                    if isInCache {
                        self.charIconURLs.inCache.append(url)
                    } else {
                        self.charIconURLs.needToDownload.append(url)
                    }
                })
            }
            
            // 所有歌曲封面图
            CGSSGameResource.shared.master.getLives(callback: { (lives) in
                for live in lives {
                    let url = live.jacketURL
                    SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
                        if isInCache {
                            self.jacketURLs.inCache.append(url)
                        } else {
                            self.jacketURLs.needToDownload.append(url)
                        }
                    })
                }
            })
            
            
            CGSSGameResource.shared.master.getEvents(callback: { (events) in
                for event in events {
                    if let url = event.detailBannerURL {
                        SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
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
                    if let url = gachaPool.detailBannerURL, ![30001, 30006].contains(gachaPool.id) {
                        // 温泉旅行和初始卡池的图片目前缺失, 故不加入待下载列表
                        SDWebImageManager.shared().cachedImageExists(for: url, completion: { (isInCache) in
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
        self.cardIconURLs.removeAll()
        self.spreadURLs.removeAll()
        self.cardImageURLs.removeAll()
        self.cardSignURLs.removeAll()
        self.charIconURLs.removeAll()
        self.eventURLs.removeAll()
        self.jacketURLs.removeAll()
        self.gachaURLs.removeAll()
    }
    
    @objc func cacheData() {
        if CGSSUpdater.default.isWorking {
            return
        }
        var urls = [URL]()
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                urls.append(contentsOf: getURLsBy(index: indexPath.row).needToDownload)
            }
        }
        
        self.updateStatusView.setContent(NSLocalizedString("缓存所有图片", comment: "设置页面"), total: urls.count)
        
        CGSSUpdater.default.updateImages(urls: urls, progress: { (a, b) in
            DispatchQueue.main.async {
                self.updateStatusView.updateProgress(a, b: b)
            }
        }) { (a, b) in
            DispatchQueue.main.async {
                let alert = UIAlertController.init(title: NSLocalizedString("缓存图片完成", comment: "设置页面"), message: "\(NSLocalizedString("成功", comment: "设置页面")) \(a), \(NSLocalizedString("失败", comment: "设置页面")) \(b - a)", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "设置页面"), style: .default, handler: nil))
                self.tabBarController?.present(alert, animated: true, completion: nil)
                self.updateStatusView.isHidden = true
                self.calculate()
            }
        }
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
            cell.rightLabel?.text = ""
        } else {
            setupCellAtIndex(indexPath.row)
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
    

    func cancelUpdate() {
        SDWebImagePrefetcher.shared().cancelPrefetching()
        CGSSUpdater.default.isUpdating = false
        let alvc = UIAlertController.init(title: NSLocalizedString("缓存图片取消", comment: "设置页面"), message: NSLocalizedString("缓存图片已被中止", comment: "设置页面"), preferredStyle: .alert)
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "设置页面"), style: .cancel, handler: nil))
        self.tabBarController?.present(alvc, animated: true, completion: nil)
        //updateCacheSize()
        self.calculate()
    }

}

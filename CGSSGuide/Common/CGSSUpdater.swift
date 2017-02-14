//
//  CGSSUpdater.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON
import SDWebImage

struct DataURL {
    static let EnglishDatabase = "https://starlight.kirara.ca"
    static let ChineseDatabase = "http://starlight.346lab.org"
    static let Images = "https://hoshimoriuta.kirara.ca"
    static let manifest = "https://storages.game.starlight-stage.jp/dl/%d/manifests/iOS_AHigh_SHigh"
    static let master = "https://storages.game.starlight-stage.jp/dl/resources/Generic//%@"
    static let musicScore = DataURL.master
}

struct CGSSUpdateDataTypes: OptionSet, RawRepresentable {
    let rawValue: UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let card = CGSSUpdateDataTypes.init(rawValue: 1 << 0)
    static let master = CGSSUpdateDataTypes.init(rawValue: 1 << 1)
    static let beatmap = CGSSUpdateDataTypes.init(rawValue: 1 << 2)
    static let all: CGSSUpdateDataTypes = [.card, .master, .beatmap]
    static let image = CGSSUpdateDataTypes.init(rawValue: 1 << 3)
}


struct CGSSUpdaterError: Error {
    var localizedDescription: String
}

class CGSSUpdateItem: NSObject {
    
    var dataType: CGSSUpdateDataTypes
    var id: String
    var hashString: String
    
    var dataURL: URL? {
        switch dataType {
        case CGSSUpdateDataTypes.card:
            return URL.init(string: DataURL.ChineseDatabase + "/api/v1/card_t/\(id)")
        case CGSSUpdateDataTypes.master:
            return URL.init(string: String.init(format: DataURL.master, hashString))
        case CGSSUpdateDataTypes.beatmap:
            return URL.init(string: String.init(format: DataURL.musicScore, hashString))
        default:
            return nil
        }
    }
    
    init(dataType:CGSSUpdateDataTypes, id:String, hash: String) {
        self.dataType = dataType
        self.id = id
        self.hashString = hash
        super.init()
    }
}

typealias CGSSCheckCompletionClosure = ([CGSSUpdateItem]?, Error?) -> Void
typealias CGSSFinishedClosure = (Bool, Error?) -> Void
typealias CGSSCheckCompletionExternalClosure = ([CGSSUpdateItem], [Error]) -> Void
typealias CGSSDownloadItemFinishedClosure = (CGSSUpdateItem, Data?, Error?) -> Void
typealias CGSSProgressClosure = (_ progress: Int, _ total: Int) -> Void
typealias CGSSProgressCompleteClosure = (_ success: Int, _ total: Int) -> Void

open class CGSSUpdater: NSObject {
  
    static let defaultUpdater = CGSSUpdater()
    
    var isWorking: Bool {
        return isUpdating || isChecking
    }
    
    var isUpdating = false {
        didSet {
            DispatchQueue.main.async {
                UIApplication.shared
                    .isNetworkActivityIndicatorVisible = self.isUpdating
            }
        }
    }
    
    var isChecking = false {
        didSet {
            DispatchQueue.main.async {
                UIApplication.shared
                    .isNetworkActivityIndicatorVisible = self.isChecking
            }
        }
    }
    
    func postUpdateEndNotification(types: CGSSUpdateDataTypes) {
        CGSSNotificationCenter.post(CGSSNotificationCenter.updateEnd, object: types)
    }
    
    var dataSession: URLSession!
    var checkSession: URLSession!
    
    fileprivate override init() {
        super.init()
        configSession()
    }
    
    func configSession() {
        // 初始化用于传输数据的dataSession
        // 使用不缓存的config
        let dataSessionConfig = URLSessionConfiguration.ephemeral
        // 超时时间设置为0
        dataSessionConfig.timeoutIntervalForRequest = 0
        // sessionConfig.requestCachePolicy = .ReloadIgnoringLocalCacheData
        // 因为此处没有使用主线程来处理回调, 所以要处理ui时需要dispatch_async到主线程
        dataSession = URLSession.init(configuration: dataSessionConfig, delegate: self, delegateQueue: nil)
        
        // 初始化用于检查更新的checkSession
        let checkSessionConfig = URLSessionConfiguration.ephemeral
        checkSessionConfig.timeoutIntervalForRequest = 60
        // sessionConfig.requestCachePolicy = .ReloadIgnoringLocalCacheData
        // 因为此处没有使用主线程来处理回调, 所以要处理ui时需要dispatch_async到主线程
        checkSession = URLSession.init(configuration: checkSessionConfig, delegate: self, delegateQueue: nil)
        
    }
    
    // 废弃当前全部任务 重新开启新的session
    func cancelCurrentSession() {
        dataSession.invalidateAndCancel()
        isUpdating = false
        checkSession.invalidateAndCancel()
        isChecking = false
        configSession()
    }
    
    func checkManifest(callback: @escaping CGSSFinishedClosure) {
        let url = DataURL.ChineseDatabase + "/api/v1/info"
        let task = checkSession.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
            if error != nil {
                callback(false, error)
            } else if (response as! HTTPURLResponse).statusCode != 200 {
                let error = CGSSUpdaterError.init(localizedDescription: NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                callback(false, error)
            } else {
                let json = JSON.init(data: data!)
                let info = CGSSGameInfo.init(fromJson: json)
                
                if let truthVersion = Int(info.truthVersion), (truthVersion > UserDefaults.standard.integer(forKey: "truthVersion")) || !CGSSGameResource.shared.checkManifestExistence() {
                    let url = String.init(format: DataURL.manifest, truthVersion)
                    let task = self.dataSession.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
                        if error != nil {
                            callback(false, error)
                        } else {
                            let manifestData = LZ4Decompressor.decompress(data!)
                            CGSSGameResource.shared.saveManifest(manifestData)
                            UserDefaults.standard.set(truthVersion, forKey: "truthVersion")
                            callback(true, nil)
                        }
                    })
                    task.resume()
                } else {
                    callback(true, nil)
                }
            }
        })
        task.resume()
    }
    
    func checkCards(callback: @escaping CGSSCheckCompletionClosure) {
        let url = DataURL.ChineseDatabase + "/api/v1/list/card_t?key=id,evolution_id"
        let task = checkSession.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
            if let e = error {
                callback(nil, e)
            } else if (response as! HTTPURLResponse).statusCode != 200 {
                let error = CGSSUpdaterError.init(localizedDescription: NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                callback(nil, error)
            } else {
                let json = JSON.init(data: data!)
                var items = [CGSSUpdateItem]()
                if let cards = json["result"].array {
                    for card in cards {
                        let dao = CGSSDAO.sharedDAO
                        if let oldCard = dao.findCardById(card["id"].intValue) {
                            if oldCard.isOldVersion {
                                let item = CGSSUpdateItem.init(dataType: .card, id: card["id"].stringValue, hash: "")
                                items.append(item)
                            }
                        } else {
                            let item = CGSSUpdateItem.init(dataType: .card, id: card["id"].stringValue, hash: "")
                            items.append(item)
                            
                        }
                        
                        if let oldCard = dao.findCardById(card["evolution_id"].intValue) {
                            if oldCard.isOldVersion {
                                let item = CGSSUpdateItem.init(dataType: .card, id: card["evolution_id"].stringValue, hash: "")
                                items.append(item)
                            }
                        } else {
                            let item = CGSSUpdateItem.init(dataType: .card, id: card["evolution_id"].stringValue, hash: "")
                            items.append(item)
                        }
                    }
                    callback(items, nil)
                } else {
                    let error = CGSSUpdaterError.init(localizedDescription: NSLocalizedString("获取到的卡数据异常", comment: "弹出框正文"))
                    callback(nil, error)
                }
            }
        })
        task.resume()
    }
    
    func checkMaster(callback: CGSSCheckCompletionClosure) {
        let masterTruthVersion = UserDefaults.standard.integer(forKey: "masterTruthVersion")
        let manifestTruthVersion = UserDefaults.standard.integer(forKey: "truthVersion")
        if masterTruthVersion < manifestTruthVersion || !CGSSGameResource.shared.checkMasterExistence() {
            if let hash = CGSSGameResource.shared.getMasterHash() {
                let item = CGSSUpdateItem.init(dataType: .master, id: String(manifestTruthVersion), hash: hash)
                callback([item], nil)
            } else {
                let error = CGSSUpdaterError.init(localizedDescription: NSLocalizedString("无法获取游戏原始数据", comment: "弹出框正文"))
                callback(nil, error)
            }
        } else {
            callback(nil, nil)
        }
    }
    
    
    func checkBeatmap(callback: CGSSCheckCompletionClosure) {
        var items = [CGSSUpdateItem]()
        for (key, value) in CGSSGameResource.shared.getScoreHash() {
            let liveId = Int(key) ?? 0
            let hash = value
            if !CGSSGameResource.shared.validateBeatmap(liveId: liveId) {
                let item = CGSSUpdateItem.init(dataType: .beatmap, id: String(liveId), hash: hash)
                items.append(item)
            }
        }
        callback(items, nil)
    }
    
    // 检查指定类型的数据是否存在更新
    func checkUpdate(dataTypes: CGSSUpdateDataTypes, complete: @escaping CGSSCheckCompletionExternalClosure ) {
        isChecking = true
        // 初始化待更新数据数组
        var itemsNeedToUpdate = [CGSSUpdateItem]()
        // 初始化错误信息数组
        var errors = [Error]()
        
        // 检查卡数据和manifest
        let firstCheckGroup = DispatchGroup()
        
        // 检查master和beatmap, 因为需要先下载manifest, 故放在第二个组内检查
        let secondCheckGroup = DispatchGroup()
        
        if dataTypes.contains(.beatmap) || dataTypes.contains(.master) {
            firstCheckGroup.enter()
            checkManifest(callback: { (finished, error) in
                if let e = error {
                    errors.append(e)
                }
                firstCheckGroup.leave()
            })
        }
        
        if dataTypes.contains(.card) {
            firstCheckGroup.enter()
            checkCards(callback: { (items, error) in
                if let e = error {
                    errors.append(e)
                } else if items != nil {
                    itemsNeedToUpdate.append(contentsOf: items!)
                }
                firstCheckGroup.leave()
            })
        }
        
        firstCheckGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(block: { 
            
            if dataTypes.contains(.master) {
                secondCheckGroup.enter()
                self.checkMaster(callback: { (items, error) in
                    if let e = error {
                        errors.append(e)
                    } else if items != nil {
                        itemsNeedToUpdate.append(contentsOf: items!)
                    }
                    secondCheckGroup.leave()
                })
            }
            
            if dataTypes.contains(.beatmap) {
                secondCheckGroup.enter()
                self.checkBeatmap(callback: { (items, error) in
                    if let e = error {
                        errors.append(e)
                    } else if items != nil {
                        itemsNeedToUpdate.append(contentsOf: items!)
                    }
                    secondCheckGroup.leave()
                })
            }
            
            secondCheckGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(block: {
                self.isChecking = false
                complete(itemsNeedToUpdate, errors)
            }))
            
        }))
    }
    
    private func updateItem(item: CGSSUpdateItem, callback: @escaping CGSSDownloadItemFinishedClosure) {
        if let url = item.dataURL {
            let task = dataSession.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    callback(item, nil, error)
                } else {
                    callback(item, data, nil)
                }
            })
            task.resume()
        }
    }
    
    func updateItems(_ items: [CGSSUpdateItem], progress: @escaping (Int, Int) -> Void, complete: @escaping (Int, Int) -> Void) {
        isUpdating = true
        let total = items.count
        var success = 0
        var process = 0 {
            didSet {
                DispatchQueue.main.async(execute: {
                    progress(process, total)
                })
            }
        }
        
        var updateTypes = CGSSUpdateDataTypes.init(rawValue: 0)
        
        // 为了让较老的数据早更新 做一次排序
        let sortedItems = items.sorted { (item1, item2) -> Bool in
            var index1: Int
            var index2: Int
            if item1.dataType == .card {
                index1 = Int(item1.id)! % 1000
            } else {
                index1 = Int(item1.id) ?? 9999999
            }
            if item2.dataType == .card {
                index2 = Int(item2.id)! % 1000
            } else {
                index2 = Int(item2.id) ?? 9999999
            }
            if index1 <= index2 {
                return true
            } else {
                return false
            }
        }
        
        let group = DispatchGroup()
        
        for item in sortedItems {
            switch item.dataType {
            case CGSSUpdateDataTypes.card:
                group.enter()
                updateItem(item: item, callback: { (item, data, error) in
                    if error != nil {
                        // print("download card item error")
                    } else {
                        let json = JSON.init(data: data!)["result"][0]
                        if json != JSON.null {
                            let card = CGSSCard.init(fromJson: json)
                            let dao = CGSSDAO.sharedDAO
                            if let oldCard = dao.cardDict.object(forKey: item.id) as? CGSSCard {
                                let updateTime = oldCard.updateTime
                                card.updateTime = updateTime
                            }
                            dao.cardDict.setObject(card, forKey: item.id as NSCopying)
                            success += 1
                            updateTypes.insert(.card)
                        }
                    }
                    process += 1
                    group.leave()
                })
            case CGSSUpdateDataTypes.beatmap:
                group.enter()
                updateItem(item: item, callback: { (item, data, error) in
                    if error != nil {
                        // print("download beatmap item error")
                    } else {
                        let beatmapData = LZ4Decompressor.decompress(data!)
                        let dao = CGSSDAO.sharedDAO
                        dao.saveBeatmapData(data: beatmapData, liveId: Int(item.id) ?? 0)
                        success += 1
                        updateTypes.insert(.beatmap)
                    }
                    process += 1
                    group.leave()
                })
            case CGSSUpdateDataTypes.master:
                group.enter()
                updateItem(item: item, callback: { (item, data, error) in
                    if error != nil {
                        // print("download master error")
                    } else {
                        let masterData = LZ4Decompressor.decompress(data!)
                        CGSSGameResource.shared.saveMaster(masterData)
                        UserDefaults.standard.set(Int(item.id)!, forKey: "masterTruthVersion")
                        success += 1
                        updateTypes.insert(.master)
                    }
                    process += 1
                    group.leave()
                })
            default:
                break
            }
        }
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(block: { 
            let dao = CGSSDAO.sharedDAO
            dao.saveAll({
                // 保存成功后 将版本置为最新版
                CGSSVersionManager.default.setVersionToNewest()
            })
            self.isUpdating = false
            DispatchQueue.main.async(execute: {
                complete(success, total)
                self.postUpdateEndNotification(types: updateTypes)
            })
        }))
    }
    
    
    func updateImages(urls: [URL], progress: @escaping CGSSProgressClosure, complete: @escaping CGSSProgressClosure) {
        
        isUpdating = true
        SDWebImagePrefetcher.shared().prefetcherQueue = DispatchQueue.global(qos: .userInitiated)
        SDWebImagePrefetcher.shared().prefetchURLs(urls, progress: { (a, b) in
            progress(Int(a), Int(b))
        }, completed: { (a, b) in
            complete(Int(a - b), Int(a))
            DispatchQueue.main.async {
                self.isUpdating = false
                // self.postUpdateEndNotification(types: .image)
            }
        })

        
    }
}

extension CGSSUpdater: URLSessionDelegate, URLSessionDataDelegate {
    
}

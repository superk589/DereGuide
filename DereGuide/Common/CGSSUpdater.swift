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

extension URL {
    static let enDatabase = URL(string: "https://starlight.kirara.ca")!
    static let cnDatabase = URL(string: "http://starlight.346lab.org")!
    static let images = URL(string: "https://truecolor.kirara.ca")!
    static func manifest(truthVersion: String) -> URL {
        return URL(string: "https://storages.game.starlight-stage.jp/dl/\(truthVersion)/manifests/iOS_AHigh_SHigh")!
    }
    static func master(truthVersion: String) -> URL {
        return URL(string: "https://storages.game.starlight-stage.jp/dl/resources/Generic//\(truthVersion)")!
    }
}

// used in notification userinfo key name
let CGSSUpdateDataTypesName = "CGSSUpdateDataTypesKey"

struct CGSSUpdateDataTypes: OptionSet {
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
            return URL.cnDatabase.appendingPathComponent("/api/v1/card_t/\(id)")
        case CGSSUpdateDataTypes.master, .beatmap:
            return URL.master(truthVersion: hashString)
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


extension URLRequest {
    mutating func setUnityVersion() {
        addValue(Config.unityVersion, forHTTPHeaderField: "X-Unity-Version")
    }
}

open class CGSSUpdater: NSObject {
  
    static let `default` = CGSSUpdater()
    
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
        NotificationCenter.default.post(name: .updateEnd, object: self, userInfo: [CGSSUpdateDataTypesName: types])
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
    
    func checkApiInfo(callback: @escaping CGSSFinishedClosure) {
        let url = URL.cnDatabase.appendingPathComponent("/api/v1/info")
        let task = checkSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                callback(false, error)
            } else if (response as! HTTPURLResponse).statusCode != 200 {
                let error = CGSSUpdaterError.init(localizedDescription: NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                callback(false, error)
            } else {
                let json = JSON(data!)
                let info = ApiInfo.init(fromJson: json)
                CGSSVersionManager.default.apiInfo = info
                callback(true, nil)
            }
        }
        task.resume()
    }
    
    func checkAppVersion(callback: @escaping CGSSFinishedClosure) {
        let url = URL(string: "https://itunes.apple.com/jp/lookup?id=1016318735")!
        let task = checkSession.dataTask(with: url) { data, response, error in
            if error != nil {
                callback(false, error)
            } else if (response as! HTTPURLResponse).statusCode != 200 {
                let error = CGSSUpdaterError.init(localizedDescription: NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                callback(false, error)
            } else {
                let json = JSON(data!)
                let appVersion = json["results"][0]["version"].stringValue
                CGSSVersionManager.default.gameVersion = Version.init(string: appVersion)
                callback(true, nil)
            }
        }
        task.resume()
    }

    func checkManifest(callback: @escaping CGSSFinishedClosure) {
        if let truthVersion = CGSSVersionManager.default.apiInfo?.truthVersion, truthVersion > CGSSVersionManager.default.currentManifestTruthVersion || !CGSSGameResource.shared.checkManifestExistence() {
            let url = URL.manifest(truthVersion: truthVersion)
            var request = URLRequest(url: url)
            request.setUnityVersion()
            let task = self.dataSession.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    callback(false, error)
                } else if (response as! HTTPURLResponse).statusCode != 200 {
                    let error = CGSSUpdaterError.init(localizedDescription: NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                    callback(false, error)
                } else {
                    let manifestData = LZ4Decompressor.decompress(data!)
                    CGSSGameResource.shared.saveManifest(manifestData)
                    CGSSVersionManager.default.setManifestTruthVersionToNewest()
                    callback(true, nil)
                }
            })
            task.resume()
        } else {
            callback(true, nil)
        }
    }
    
    func checkCards(callback: @escaping CGSSCheckCompletionClosure) {
        let url = URL.cnDatabase.appendingPathComponent("/api/v1/list/card_t")
        let task = checkSession.dataTask(with: URL(string: url.absoluteString + "?key=id,evolution_id")!, completionHandler: { (data, response, error) in
            if let e = error {
                callback(nil, e)
            } else if (response as! HTTPURLResponse).statusCode != 200 {
                let error = CGSSUpdaterError.init(localizedDescription: NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                callback(nil, error)
            } else {
                let json = JSON(data!)
                var items = [CGSSUpdateItem]()
                if let cards = json["result"].array {
                    for card in cards {
                        let dao = CGSSDAO.shared
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
        if CGSSVersionManager.default.currentMasterTruthVersion < CGSSVersionManager.default.currentManifestTruthVersion || !CGSSGameResource.shared.checkMasterExistence() {
            if let hash = CGSSGameResource.shared.getMasterHash() {
                let item = CGSSUpdateItem.init(dataType: .master, id: CGSSVersionManager.default.currentManifestTruthVersion, hash: hash)
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
            if let savedHash = BeatmapHashManager.default.hashTable[key] {
                if savedHash == value && CGSSGameResource.shared.checkExistenceOfBeatmap(liveId: Int(key)!) {
                    continue
                }
            }
            let item = CGSSUpdateItem.init(dataType: .beatmap, id: key, hash: value)
            items.append(item)
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
        
        // 检查api版本号和game truthversion
        let firstCheckGroup = DispatchGroup()
        
        // 检查卡数据和manifest
        let secondCheckGroup = DispatchGroup()
        
        // 检查master和beatmap
        let thirdCheckGroup = DispatchGroup()
        
        
        firstCheckGroup.enter()
        checkApiInfo { (finished, error) in
            if let e = error {
                errors.append(e)
            }
            firstCheckGroup.leave()
        }
        
        firstCheckGroup.notify(queue: DispatchQueue.main) { [weak self] in
            if errors.count > 0 {
                self?.isChecking = false
                complete(itemsNeedToUpdate, errors)
            } else {
                
                secondCheckGroup.enter()
                self?.checkAppVersion { (finished, error) in
                    if let e = error {
                        errors.append(e)
                    }
                    secondCheckGroup.leave()
                }
                
                if dataTypes.contains(.beatmap) || dataTypes.contains(.master) {
                    secondCheckGroup.enter()
                    self?.checkManifest(callback: { (finished, error) in
                        if let e = error {
                            errors.append(e)
                        }
                        secondCheckGroup.leave()
                    })
                }
                
                if dataTypes.contains(.card) {
                    secondCheckGroup.enter()
                    self?.checkCards(callback: { (items, error) in
                        if let e = error {
                            errors.append(e)
                        } else if items != nil {
                            itemsNeedToUpdate.append(contentsOf: items!)
                        }
                        secondCheckGroup.leave()
                    })
                }
                
                secondCheckGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(block: { [weak self] in
                    if dataTypes.contains(.master) {
                        thirdCheckGroup.enter()
                        self?.checkMaster(callback: { (items, error) in
                            if let e = error {
                                errors.append(e)
                            } else if items != nil {
                                itemsNeedToUpdate.append(contentsOf: items!)
                            }
                            thirdCheckGroup.leave()
                        })
                    }
                    
                    if dataTypes.contains(.beatmap) {
                        thirdCheckGroup.enter()
                        self?.checkBeatmap(callback: { (items, error) in
                            if let e = error {
                                errors.append(e)
                            } else if items != nil {
                                itemsNeedToUpdate.append(contentsOf: items!)
                            }
                            thirdCheckGroup.leave()
                        })
                    }
                    
                    thirdCheckGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(block: { [weak self] in
                        self?.isChecking = false
                        complete(itemsNeedToUpdate, errors)
                    }))
                    
                }))

            }
            
        }
        
    }
    
    private func updateItem(item: CGSSUpdateItem, callback: @escaping CGSSDownloadItemFinishedClosure) {
        if let url = item.dataURL {
            var request = URLRequest(url: url)
            if [CGSSUpdateDataTypes.beatmap, .master].contains(item.dataType) {
                request.setUnityVersion()
            }
            let task = dataSession.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    callback(item, nil, error)
                } else if (response as! HTTPURLResponse).statusCode != 200 {
                    let error = CGSSUpdaterError.init(localizedDescription: NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
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
        let queue = DispatchQueue.init(label: "zzk.dereguide.updater_queue_progress")
        var success = 0
        var process = 0 {
            didSet {
                DispatchQueue.main.async {
                    progress(process, total)
                }
            }
        }
        
        var updateTypes = CGSSUpdateDataTypes.init(rawValue: 0)
        
        // 为了让较老的数据早更新 做一次排序
//        let sortedItems = items.sorted { (item1, item2) -> Bool in
//            var index1: Int
//            var index2: Int
//            if item1.dataType == .card {
//                index1 = Int(item1.id)! % 1000
//            } else {
//                index1 = Int(item1.id) ?? 9999999
//            }
//            if item2.dataType == .card {
//                index2 = Int(item2.id)! % 1000
//            } else {
//                index2 = Int(item2.id) ?? 9999999
//            }
//            if index1 <= index2 {
//                return true
//            } else {
//                return false
//            }
//        }
 
        let group = DispatchGroup()
        
        for item in items {
            switch item.dataType {
            case CGSSUpdateDataTypes.card:
                group.enter()
                updateItem(item: item, callback: { (item, data, error) in
                    if error != nil {
                        // print("download card item error")
                    } else {
                        let json = JSON(data!)["result"][0]
                        if json != JSON.null {
                            let card = CGSSCard.init(fromJson: json)
                            let dao = CGSSDAO.shared
                            if let oldCard = dao.cardDict.object(forKey: item.id) as? CGSSCard {
                                let updateTime = oldCard.updateTime
                                card.updateTime = updateTime
                            }
                            dao.cardDict.setObject(card, forKey: item.id as NSCopying)
                            queue.sync {
                                success += 1
                            }
                            updateTypes.insert(.card)
                        }
                    }
                    queue.sync {
                        process += 1
                    }
                    group.leave()
                })
            case CGSSUpdateDataTypes.beatmap:
                group.enter()
                updateItem(item: item, callback: { (item, data, error) in
                    if error != nil {
                        // print("download beatmap item error")
                    } else {
                        let beatmapData = LZ4Decompressor.decompress(data!)
                        let dao = CGSSDAO.shared
                        dao.saveBeatmapData(data: beatmapData, liveId: Int(item.id) ?? 0)
                        BeatmapHashManager.default.hashTable[item.id] = item.hashString
                        queue.sync {
                            success += 1
                        }
                        updateTypes.insert(.beatmap)
                    }
                    queue.sync {
                        process += 1
                    }
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
                        CGSSVersionManager.default.setMasterTruthVersionToNewest()
                        queue.sync {
                            success += 1
                        }
                        updateTypes.insert(.master)
                    }
                    queue.sync {
                        process += 1
                    }
                    group.leave()
                })
            default:
                break
            }
        }
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(block: { [weak self] in
            self?.isUpdating = false
            DispatchQueue.main.async(execute: {
                complete(success, total)
                self?.postUpdateEndNotification(types: updateTypes)
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
            DispatchQueue.main.async { [weak self] in
                self?.isUpdating = false
//                self?.postUpdateEndNotification(types: .image)
            }
        })

        
    }
}

extension CGSSUpdater: URLSessionDelegate, URLSessionDataDelegate {
    
}

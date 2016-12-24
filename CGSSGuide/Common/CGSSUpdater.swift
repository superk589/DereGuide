//
//  CGSSUpdater.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l >= r
//  default:
//    return !(lhs < rhs)
//  }
//}

struct DataURL {
    static let EnglishDatabase = "https://starlight.kirara.ca"
    static let ChineseDatabase = "http://starlight.hyspace.io"
    static let Images = "https://hoshimoriuta.kirara.ca"
    // static let Wiki = "http://imascg-slstage-wiki.gamerch.com"
    // static let URLOfIcons = "https://hoshimoriuta.kirara.ca/icons2"
    static let Deresute = "https://apiv2.deresute.info"
    static let manifest = "http://storage.game.starlight-stage.jp/dl/%@/manifests/iOS_AHigh_SHigh"
    static let master = "http://storage.game.starlight-stage.jp/dl/resources/Generic//%@"
}

open class CGSSUpdater: NSObject {
  
    
    static let defaultUpdater = CGSSUpdater()
    
    var isUpdating = false {
        didSet {
            // 此处确保当前如果在主线程,则在主线程同步发送消息,当前不在主线程则通过DispatchQueue.main.async发送
            if Thread.isMainThread {
                if self.isUpdating {
                    // CGSSNotificationCenter.post("UPDATE_START", object: nil)
                } else {
                    CGSSNotificationCenter.post(CGSSNotificationCenter.updateEnd, object: nil)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.isUpdating
            } else {
                DispatchQueue.main.async {
                    if self.isUpdating {
                        // CGSSNotificationCenter.post("UPDATE_START", object: nil)
                    } else {
                        CGSSNotificationCenter.post(CGSSNotificationCenter.updateEnd, object: nil)
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = self.isUpdating
                }
            }
        }
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
        checkSession.invalidateAndCancel()
        configSession()
    }
    
    // 检查指定类型的数据是否存在更新
    func checkUpdate(_ typeMask: UInt, complete: @escaping ([CGSSUpdateItem], [String]) -> Void) {
        isUpdating = true
        // 初始化待更新数据数组
        var items = [CGSSUpdateItem]()
        // 初始化错误信息数组
        var errors = [String]()
        // 检查需要更新的数据类型
        var dataTypes = [CGSSUpdateDataType]()
        for i: UInt in 0...7 {
            let mask = typeMask >> i
            if mask % 2 == 1 {
                dataTypes.append(CGSSUpdateDataType(rawValue: 1 << i)!)
            }
        }
        var count = 0
        func completeInside(_ error: String?) {
            if let e = error {
                if !errors.contains(e) {
                    errors.append(e)
                }
            }
            count += 1
            if count == dataTypes.count {
                DispatchQueue.main.async(execute: {
                    complete(items, errors)
                })
                isUpdating = false
            }
        }
        
        for dataType in dataTypes {
            switch dataType {
            case .card:
                let url = DataURL.ChineseDatabase + "/api/v1/list/card_t?key=id,evolution_id"
                let task = checkSession.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        // print("检查卡片更新失败: \(e.localizedDescription)")
                        completeInside(e.localizedDescription)
                    } else if (response as! HTTPURLResponse).statusCode != 200 {
                        completeInside(NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                    } else {
                        let json = JSON.init(data: data!)
                        if let cards = json["result"].array {
                            for card in cards {
                                let dao = CGSSDAO.sharedDAO
                                if let oldCard = dao.findCardById(card["id"].intValue) {
                                    if oldCard.isOldVersion {
                                        let item = CGSSUpdateItem.init(dataType: .card, id: card["id"].stringValue)
                                        items.append(item)
                                    }
                                } else {
                                    let item = CGSSUpdateItem.init(dataType: .card, id: card["id"].stringValue)
                                    items.append(item)
                                    
                                }
                                
                                if let oldCard = dao.findCardById(card["evolution_id"].intValue) {
                                    if oldCard.isOldVersion {
                                        let item = CGSSUpdateItem.init(dataType: .card, id: card["evolution_id"].stringValue)
                                        items.append(item)
                                    }
                                } else {
                                    let item = CGSSUpdateItem.init(dataType: .card, id: card["evolution_id"].stringValue)
                                    items.append(item)
                                    
                                }
                                
                            }
                        } else {
                            completeInside(NSLocalizedString("获取到的卡数据异常", comment: "弹出框正文"))
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
                
            case .song:
                let url = DataURL.Deresute + "/data/music"
                let task = checkSession.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        // print("检查歌曲更新失败: \(e.localizedDescription)")
                        completeInside(e.localizedDescription)
                    } else if (response as! HTTPURLResponse).statusCode != 200 {
                        completeInside(NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                    } else {
                        let json = JSON.init(data: data!)
                        if let songs = json.array {
                            for song in songs {
                                let dao = CGSSDAO.sharedDAO
                                if let oldSong = dao.findSongById(song["id"].intValue) {
                                    if oldSong.isOldVersion {
                                        let newSong = CGSSSong.init(json: song)
                                        dao.songDict.setValue(newSong, forKey: song["id"].stringValue)
                                    }
                                } else {
                                    let newSong = CGSSSong.init(json: song)
                                    dao.songDict.setValue(newSong, forKey: song["id"].stringValue)
                                }
                            }
                        } else {
                            completeInside(NSLocalizedString("获取到的歌曲数据异常", comment: "弹出框正文"))
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
            case .live:
                let url = DataURL.Deresute + "/data/live"
                let task = checkSession.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        // print("检查live更新失败: \(e.localizedDescription)")
                        completeInside(e.localizedDescription)
                    } else if (response as! HTTPURLResponse).statusCode != 200 {
                        completeInside(NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                    } else {
                        let json = JSON.init(data: data!)
                        if let lives = json.array {
                            for live in lives {
                                let dao = CGSSDAO.sharedDAO
                                if let oldLive = dao.findLiveById(live["id"].intValue) {
                                    if oldLive.isOldVersion {
                                        let newLive = CGSSLive.init(json: live)
                                        dao.liveDict.setValue(newLive,
                                            forKey: (live["id"].stringValue))
                                    }
                                } else {
                                    let newLive = CGSSLive.init(json: live)
                                    dao.liveDict.setValue(newLive, forKey: live["id"].stringValue)
                                }
                                
                                let max = (live["masterPlus"].intValue == 0) ? 4 : 5
                                for i in 1...max {
                                    if let beatmap = dao.findBeatmapById(live["id"].intValue, diffId: i) {
                                        if beatmap.isOldVersion {
                                            let itemId = String(format: "%03d_%d", live["id"].intValue, i)
                                            let item = CGSSUpdateItem.init(dataType: .beatmap, id: itemId)
                                            items.append(item)
                                        }
                                    } else {
                                        let itemId = String(format: "%03d_%d", live["id"].intValue, i)
                                        let item = CGSSUpdateItem.init(dataType: .beatmap, id: itemId)
                                        items.append(item)
                                    }
                                }
                            }
                        } else {
                            completeInside(NSLocalizedString("获取到的live数据异常", comment: "弹出框正文"))
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
                
            case .cardIcon:
                completeInside(nil)
                break
            case .story:
                let url = DataURL.Deresute + "/data/story"
                let task = checkSession.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        // print("检查故事章节更新失败: \(e.localizedDescription)")
                        completeInside(e.localizedDescription)
                    } else if (response as! HTTPURLResponse).statusCode != 200 {
                        completeInside(NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                    } else {
                        let json = JSON.init(data: data!)
                        if let storyEpisodes = json.array {
                            for episode in storyEpisodes {
                                let dao = CGSSDAO.sharedDAO
                                if let oldStoryEpisode = dao.findStoryEpisodeById(episode["id"].intValue) {
                                    if oldStoryEpisode.isOldVersion {
                                        let newStoryEpisode = CGSSStoryEpisode.init(fromJson: episode)
                                        dao.storyEpisodeDict.setValue(newStoryEpisode, forKey: episode["id"].stringValue)
                                    }
                                } else {
                                    let newStoryEpisode = CGSSStoryEpisode.init(fromJson: episode)
                                    dao.storyEpisodeDict.setValue(newStoryEpisode, forKey: episode["id"].stringValue)
                                }
                            }
                        } else {
                            completeInside("获取到的故事章节数据异常")
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
            case .beatmap:
                completeInside(nil)
                break
            case .resource:
                let url = DataURL.ChineseDatabase + "/api/v1/info"
                let task = checkSession.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        // print("检查游戏资源更新失败: \(e.localizedDescription)")
                        completeInside(e.localizedDescription)
                    } else if (response as! HTTPURLResponse).statusCode != 200 {
                        completeInside(NSLocalizedString("数据服务器存在异常，请您稍后再尝试更新。", comment: "数据更新时的错误提示"))
                    } else {
                        let json = JSON.init(data: data!)
                        let info = CGSSGameInfo.init(fromJson: json)
                        if let truthVersion = Int(info.truthVersion), (truthVersion > UserDefaults.standard.integer(forKey: "truthVersion")) || !CGSSGameResource.sharedResource.checkMaster() {
                            let item = CGSSUpdateItem.init(dataType: .resource, id: info.truthVersion)
                            items.append(item)
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
            }
        }
    }
    
    func updateItems(_ items: [CGSSUpdateItem], progress: @escaping (Int, Int) -> Void, complete: @escaping (Int, Int) -> Void) {
        isUpdating = true
        var success = 0
        var process = 0
        var total = items.count
        
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
        
        func insideComplete(_ e: String?) {
            if e == nil {
                success += 1
            }
            process += 1
            DispatchQueue.main.async(execute: {
                progress(process, total)
            })
            if process == items.count {
                let dao = CGSSDAO.sharedDAO
                dao.saveAll({
                    // 保存成功后 将版本置为最新版
                    CGSSVersionManager.default.setVersionToNewest()
                })
                isUpdating = false
                DispatchQueue.main.async(execute: {
                    complete(success, total)
                })
            }
        }
        
        for item in sortedItems {
            switch item.dataType {
            case .card:
                let strURL = DataURL.ChineseDatabase + "/api/v1/card_t/\(item.id)"
                let url = URL(string: strURL as String)!
                let task = dataSession.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        // print("获取卡数据出错:\(error!.localizedDescription)\(url)")
                        insideComplete(error?.localizedDescription)
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
                            insideComplete(nil)
                        } else {
                            insideComplete(NSLocalizedString("获取到的卡数据异常", comment: "弹出框正文"))
                        }
                    }
                })
                task.resume()
            case .song:
                break
            case .live:
                break
            case .cardIcon:
                break
            case .story:
                break
            case .beatmap:
                let strURL = DataURL.Deresute + "/pattern/\(item.id)"
                let url = URL(string: strURL as String)!
                let task = dataSession.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        // print("获取谱面数据出错:\(error!.localizedDescription)\(url)")
                        insideComplete(error?.localizedDescription)
                    } else {
                        if let beatmap = CGSSBeatmap.init(json: JSON.init(data: data!)) {
                            let subs = item.id.components(separatedBy: "_")
                            let dao = CGSSDAO.sharedDAO
                            if let dict = dao.beatmapDict.object(forKey: subs[0]) as? NSMutableDictionary {
                                dict.setValue(beatmap, forKey: subs[1])
                            } else {
                                let dict = NSMutableDictionary()
                                dict.setValue(beatmap, forKey: subs[1])
                                dao.beatmapDict.setValue(dict, forKey: subs[0])
                            }
                            insideComplete(nil)
                        } else {
                            insideComplete(NSLocalizedString("获取到的谱面数据异常", comment: "弹出框正文"))
                        }
                    }
                })
                task.resume()
            case .resource:
                let url = String.init(format: DataURL.manifest, item.id)
                let task = dataSession.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
                    if error != nil {
                        insideComplete(error?.localizedDescription)
                    } else {
                        let manifestData = LZ4Decompressor.decompress(data!)
                        CGSSGameResource.sharedResource.saveManifest(manifestData)
                        if let hash = CGSSGameResource.sharedResource.getMasterHash() {
                            let masterUrl = String.init(format: DataURL.master, hash)
                            let subTask = self.dataSession.dataTask(with: URL.init(string: masterUrl)!, completionHandler: { (data, response, error) in
                                if error != nil {
                                    insideComplete(error?.localizedDescription)
                                } else {
                                    let masterData = LZ4Decompressor.decompress(data!)
                                    CGSSGameResource.sharedResource.saveMaster(masterData)
                                    UserDefaults.standard.set(Int(item.id)!, forKey: "truthVersion")
                                    insideComplete(nil)
                                }
                            })
                            subTask.resume()
                        } else {
                            insideComplete(NSLocalizedString("无法获取游戏原始数据", comment: "弹出框正文"))
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    fileprivate func getStringByPattern(_ str: String, pattern: String) -> [NSString] {
        let regex = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let res = regex!.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        var arr = Array<NSString>()
        for checkingRes in res {
            
            arr.append((str as NSString).substring(with: checkingRes.range) as NSString)
            
        }
        return arr
    }
    
}

extension CGSSUpdater: URLSessionDelegate, URLSessionDataDelegate {
//    public func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
//        CGSSNotificationCenter.post("UPDATE_FINISH", object: self)
//    }
    
}

//
//  CGSSUpdater.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

public class CGSSUpdater: NSObject {
    
    static let URLOfEnglishDatabase = "https://starlight.kirara.ca"
    static let URLOfChineseDatabase = "http://starlight.hyspace.io"
    static let URLOfImages = "https://hoshimoriuta.kirara.ca"
    static let URLOfWiki = "http://imascg-slstage-wiki.gamerch.com"
    static let URLOfIcons = "https://hoshimoriuta.kirara.ca/icons2"
    static let URLOfDeresuteApi = "https://apiv2.deresute.info"
    static let defaultUpdater = CGSSUpdater()
    
    var isUpdating = false {
        didSet {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = isUpdating
        }
    }
    var dataSession: NSURLSession!
    var checkSession: NSURLSession!
    
    private override init() {
        super.init()
        configSession()
    }
    
    func configSession() {
        // 初始化用于传输数据的dataSession
        // 使用不缓存的config
        let dataSessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        // 超时时间设置为0
        dataSessionConfig.timeoutIntervalForRequest = 0
        // sessionConfig.requestCachePolicy = .ReloadIgnoringLocalCacheData
        // 因为此处没有使用主线程来处理回调, 所以要处理ui时需要dispatch_async到主线程
        dataSession = NSURLSession.init(configuration: dataSessionConfig, delegate: self, delegateQueue: nil)
        
        // 初始化用于检查更新的checkSession
        let checkSessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        checkSessionConfig.timeoutIntervalForRequest = 30
        // sessionConfig.requestCachePolicy = .ReloadIgnoringLocalCacheData
        // 因为此处没有使用主线程来处理回调, 所以要处理ui时需要dispatch_async到主线程
        checkSession = NSURLSession.init(configuration: checkSessionConfig, delegate: self, delegateQueue: nil)
        
    }
    
    // 废弃当前全部任务 重新开启新的session
    func cancelCurrentSession() {
        dataSession.invalidateAndCancel()
        checkSession.invalidateAndCancel()
        configSession()
    }
    
    // 检查最新的数据版本号
    func checkNewestDataVersion() -> (String, String) {
        let major = NSBundle.mainBundle().infoDictionary?["Data Version"]?["Major"] as! String
        let minor = NSBundle.mainBundle().infoDictionary?["Data Version"]?["Minor"] as! String
        return (major, minor)
    }
    
    // 检查当前的数据版本号
    func checkCurrentDataVersion() -> (String, String) {
        let major = NSUserDefaults.standardUserDefaults().objectForKey("Major") as? String ?? "0"
        let minor = NSUserDefaults.standardUserDefaults().objectForKey("Minor") as? String ?? "0"
        return (major, minor)
    }
    
    // 设置当前的数据版本号
    func setCurrentDataVersion(major: String, minor: String) {
        NSUserDefaults.standardUserDefaults().setObject(major, forKey: "Major")
        NSUserDefaults.standardUserDefaults().setObject(minor, forKey: "Minor")
    }
    
    // 设置当前数据版本号为最新版本
    func setVersionToNewest() {
        NSUserDefaults.standardUserDefaults().setObject(checkNewestDataVersion().0, forKey: "Major")
        NSUserDefaults.standardUserDefaults().setObject(checkNewestDataVersion().1, forKey: "Minor")
    }
    
    // 获取当前数据版本字符串
    func getCurrentVersionString() -> String {
        return checkCurrentDataVersion().0 + "." + checkCurrentDataVersion().1
    }
    
    // 检查指定类型的数据是否存在更新
    func checkUpdate(typeMask: UInt, complete: ([CGSSUpdateItem], [String]) -> Void) {
        isUpdating = true
        // 初始化待更新数据数组
        var items = [CGSSUpdateItem]()
        // 初始化错误信息数组
        var errors = [String]()
        // 检查需要更新的数据类型
        var dataTypes = [CGSSUpdateDataType]()
        for i: UInt in 0...4 {
            let mask = typeMask >> i
            if mask % 2 == 1 {
                dataTypes.append(CGSSUpdateDataType(rawValue: 1 << i)!)
            }
        }
        var count = 0
        func completeInside(error: String?) {
            if let e = error {
                if !errors.contains(e) {
                    errors.append(e)
                }
            }
            count += 1
            if count == dataTypes.count {
                dispatch_async(dispatch_get_main_queue(), {
                    complete(items, errors)
                })
                isUpdating = false
            }
        }
        
        for dataType in dataTypes {
            switch dataType {
            case .Card:
                let url = CGSSUpdater.URLOfEnglishDatabase + "/api/v1/list/card_t?key=id,evolution_id"
                let task = checkSession.dataTaskWithURL(NSURL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        // print("检查卡片更新失败: \(e.localizedDescription)")
                        completeInside(e.localizedDescription)
                    } else {
                        let json = JSON.init(data: data!)
                        if let cards = json["result"].array {
                            for card in cards {
                                let dao = CGSSDAO.sharedDAO
                                if let oldCard = dao.findCardById(card["id"].intValue) {
                                    if oldCard.isOldVersion {
                                        let item = CGSSUpdateItem.init(dataType: .Card, id: card["id"].stringValue)
                                        items.append(item)
                                    }
                                } else {
                                    let item = CGSSUpdateItem.init(dataType: .Card, id: card["id"].stringValue)
                                    items.append(item)
                                    
                                }
                                
                                if let oldCard = dao.findCardById(card["evolution_id"].intValue) {
                                    if oldCard.isOldVersion {
                                        let item = CGSSUpdateItem.init(dataType: .Card, id: card["evolution_id"].stringValue)
                                        items.append(item)
                                    }
                                } else {
                                    let item = CGSSUpdateItem.init(dataType: .Card, id: card["evolution_id"].stringValue)
                                    items.append(item)
                                    
                                }
                                
                            }
                        } else {
                            completeInside("获取到的卡片数据异常")
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
                
            case .Song:
                let url = CGSSUpdater.URLOfDeresuteApi + "/data/music"
                let task = checkSession.dataTaskWithURL(NSURL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        // print("检查歌曲更新失败: \(e.localizedDescription)")
                        completeInside(e.localizedDescription)
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
                            completeInside("获取到的歌曲数据异常")
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
            case .Live:
                let url = CGSSUpdater.URLOfDeresuteApi + "/data/live"
                let task = checkSession.dataTaskWithURL(NSURL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        // print("检查live更新失败: \(e.localizedDescription)")
                        completeInside(e.localizedDescription)
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
                                            let item = CGSSUpdateItem.init(dataType: .Beatmap, id: itemId)
                                            items.append(item)
                                        }
                                    } else {
                                        let itemId = String(format: "%03d_%d", live["id"].intValue, i)
                                        let item = CGSSUpdateItem.init(dataType: .Beatmap, id: itemId)
                                        items.append(item)
                                    }
                                }
                            }
                        } else {
                            completeInside("获取到的live数据异常")
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
                
            case .CardIcon:
                completeInside(nil)
                break
            case .Story:
                let url = CGSSUpdater.URLOfDeresuteApi + "/data/story"
                let task = checkSession.dataTaskWithURL(NSURL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        // print("检查故事章节更新失败: \(e.localizedDescription)")
                        completeInside(e.localizedDescription)
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
            case .Beatmap:
                completeInside(nil)
                break
            }
        }
    }
    
    func updateItems(items: [CGSSUpdateItem], progress: (Int, Int) -> Void, complete: (Int, Int) -> Void) {
        isUpdating = true
        var success = 0
        var process = 0
        var total = items.count
        
        // 为了让较老的数据早更新 做一次排序
        let sortedItems = items.sort { (item1, item2) -> Bool in
            let index1 = Int(item1.id) ?? 9999999
            let index2 = Int(item2.id) ?? 9999999
            if index1 <= index2 {
                return true
            } else {
                return false
            }
        }
        
        func insideComplete(e: String?) {
            if e == nil {
                success += 1
            }
            process += 1
            dispatch_async(dispatch_get_main_queue(), {
                progress(process, total)
            })
            if process == items.count {
                let dao = CGSSDAO.sharedDAO
                dao.saveAll({
                    // 保存成功后 将版本置为最新版
                    self.setVersionToNewest()
                })
                isUpdating = false
                dispatch_async(dispatch_get_main_queue(), {
                    complete(success, total)
                })
            }
        }
        
        for item in sortedItems {
            switch item.dataType {
            case .Card:
                let strURL = CGSSUpdater.URLOfChineseDatabase + "/api/v1/card_t/\(item.id)"
                let url = NSURL(string: strURL as String)!
                let task = dataSession.dataTaskWithURL(url, completionHandler: { (data, response, error) in
                    if error != nil {
                        // print("获取卡数据出错:\(error!.localizedDescription)\(url)")
                        insideComplete(error?.localizedDescription)
                    } else {
                        let json = JSON.init(data: data!)["result"][0]
                        if json != JSON.null {
                            let card = CGSSCard.init(fromJson: json)
                            let dao = CGSSDAO.sharedDAO
                            if let oldCard = dao.cardDict.objectForKey(item.id) as? CGSSCard {
                                let updateTime = oldCard.updateTime
                                card.updateTime = updateTime
                            }
                            dao.cardDict.setObject(card, forKey: item.id)
                            insideComplete(nil)
                        } else {
                            insideComplete("获取到的卡数据异常")
                        }
                    }
                })
                task.resume()
            case .Song:
                break
            case .Live:
                break
            case .CardIcon:
                break
            case .Story:
                break
            case .Beatmap:
                let strURL = CGSSUpdater.URLOfDeresuteApi + "/pattern/\(item.id)"
                let url = NSURL(string: strURL as String)!
                let task = dataSession.dataTaskWithURL(url, completionHandler: { (data, response, error) in
                    if error != nil {
                        // print("获取谱面数据出错:\(error!.localizedDescription)\(url)")
                        insideComplete(error?.localizedDescription)
                    } else {
                        if let beatmap = CGSSBeatmap.init(json: JSON.init(data: data!)) {
                            let subs = item.id.componentsSeparatedByString("_")
                            let dao = CGSSDAO.sharedDAO
                            if let dict = dao.beatmapDict.objectForKey(subs[0]) as? NSMutableDictionary {
                                dict.setValue(beatmap, forKey: subs[1])
                            } else {
                                let dict = NSMutableDictionary()
                                dict.setValue(beatmap, forKey: subs[1])
                                dao.beatmapDict.setValue(dict, forKey: subs[0])
                            }
                            insideComplete(nil)
                        } else {
                            insideComplete("获取到的谱面数据异常")
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    private func getStringByPattern(str: String, pattern: String) -> [NSString] {
        let regex = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        let res = regex!.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        var arr = Array<NSString>()
        for checkingRes in res {
            
            arr.append((str as NSString).substringWithRange(checkingRes.range))
            
        }
        return arr
    }
    
}

extension CGSSUpdater: NSURLSessionDelegate, NSURLSessionDataDelegate {
//    public func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
//        CGSSNotificationCenter.post("UPDATE_FINISH", object: self)
//    }
    
}

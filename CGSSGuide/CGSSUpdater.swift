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
    
    
    var isUpdating = false
    var dataSession:NSURLSession!
    var checkSession:NSURLSession!
   
    
    private override init() {
        super.init()
        configSession()
    }
    
    func configSession() {
        //初始化用于传输数据的dataSession
        //使用不缓存的config
        let dataSessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        //超时时间设置为0
        dataSessionConfig.timeoutIntervalForRequest = 0
        //sessionConfig.requestCachePolicy = .ReloadIgnoringLocalCacheData
        //因为此处没有使用主线程来处理回调, 所以要处理ui时需要dispatch_async到主线程
        dataSession = NSURLSession.init(configuration: dataSessionConfig, delegate: self, delegateQueue: nil)
        
        //初始化用于检查更新的checkSession
        let checkSessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        checkSessionConfig.timeoutIntervalForRequest = 30
        //sessionConfig.requestCachePolicy = .ReloadIgnoringLocalCacheData
        //因为此处没有使用主线程来处理回调, 所以要处理ui时需要dispatch_async到主线程
        checkSession = NSURLSession.init(configuration: checkSessionConfig, delegate: self, delegateQueue: nil)
        
    }
    
    //废弃当前全部任务 重新开启新的session
    func cancelCurrentSession() {
        dataSession.invalidateAndCancel()
        checkSession.invalidateAndCancel()
        configSession()
    }

    //检查最新的数据版本号
    func checkNewestDataVersion() -> (String, String){
        let major = NSBundle.mainBundle().infoDictionary?["Data Version"]?["Major"] as! String
        let minor = NSBundle.mainBundle().infoDictionary?["Data Version"]?["Minor"] as! String
        return (major, minor)
    }
    
    //检查当前的数据版本号
    func checkCurrentDataVersion() -> (String, String){
        let major = NSUserDefaults.standardUserDefaults().objectForKey("Major") as? String ?? "0"
        let minor = NSUserDefaults.standardUserDefaults().objectForKey("Minor") as? String ?? "0"
        return (major, minor)
    }
    
    //设置当前的数据版本号
    func setCurrentDataVersion(major:String, minor:String) {
        NSUserDefaults.standardUserDefaults().setObject(major, forKey: "Major")
        NSUserDefaults.standardUserDefaults().setObject(minor, forKey: "Minor")
    }
    
    //设置当前数据版本号为最新版本
    func setVersionToNewest() {
        NSUserDefaults.standardUserDefaults().setObject(checkNewestDataVersion().0, forKey: "Major")
        NSUserDefaults.standardUserDefaults().setObject(checkNewestDataVersion().1, forKey: "Minor")
    }
    
    //获取当前数据版本字符串
    func getCurrentVersionString() -> String {
        return checkCurrentDataVersion().0 + "." + checkCurrentDataVersion().1
    }
    
   
    //检查指定类型的数据是否存在更新
    func checkUpdate(typeMask:UInt, complete:([CGSSUpdateItem], [String])->Void) {
        isUpdating = true
        //初始化待更新数据数组
        var items = [CGSSUpdateItem]()
        //初始化错误信息数组
        var errors = [String]()
        //检查需要更新的数据类型
        var dataTypes = [CGSSUpdateDataType]()
        for i:UInt in 0...4 {
            let mask = typeMask >> i
            if mask % 2 == 1 {
                dataTypes.append(CGSSUpdateDataType(rawValue: 1 << i)!)
            }
        }
        var count = 0
        func completeInside(error:String?) {
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
                let url = CGSSUpdater.URLOfChineseDatabase + "/api/v1/list/card_t?key=id,evolution_id"
                let task = checkSession.dataTaskWithURL(NSURL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        print("检查卡片更新失败: \(e.localizedDescription)")
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
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
                
            case .Song:
                let url = CGSSUpdater.URLOfDeresuteApi + "/data/music"
                let task = checkSession.dataTaskWithURL(NSURL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        print("检查歌曲更新失败: \(e.localizedDescription)")
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
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
            case .Live:
                let url = CGSSUpdater.URLOfDeresuteApi + "/data/live"
                let task = checkSession.dataTaskWithURL(NSURL.init(string: url)!, completionHandler: { (data, response, error) in
                    if let e = error {
                        print("检查live更新失败: \(e.localizedDescription)")
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
                                if let beatmap = dao.findBeatmapById(live["id"].intValue, diffId: 1) {
                                    if beatmap.isOldVersion {
                                        for i in 1...max {
                                            let itemId = String(format: "%03d_%d", live["id"].intValue, i)
                                            let item = CGSSUpdateItem.init(dataType: .Beatmap, id: itemId)
                                            items.append(item)
                                        }
                                    }
                                } else {
                                    for i in 1...max {
                                        let itemId = String(format: "%03d_%d", live["id"].intValue, i)
                                        let item = CGSSUpdateItem.init(dataType: .Beatmap, id: itemId)
                                        items.append(item)
                                    }
                                    
                                }

                            }
                        }
                        completeInside(nil)
                    }
                })
                task.resume()
                
            case .CardIcon:
                completeInside(nil)
                break
            case .Story:
                completeInside(nil)
                break
            case .Beatmap:
                completeInside(nil)
                break
            }
        }
    }
    
    func updateItems(items:[CGSSUpdateItem], progress: (Int, Int) -> Void,  complete:(Int, Int) -> Void) {
        isUpdating = true
        var success = 0
        var process = 0
        var total = items.count
        
        func insideComplete(e:NSError?) {
            if e == nil {
                success += 1
            }
            process += 1
            dispatch_async(dispatch_get_main_queue(), {
                progress(process, total)
            })
            if process == items.count {
                let dao = CGSSDAO.sharedDAO
                dao.saveAll(nil)
                isUpdating = false
                dispatch_async(dispatch_get_main_queue(), {
                    complete(success, total)
                })
            }
        }

        for item in items {
            switch item.dataType {
            case .Card:
                let strURL = CGSSUpdater.URLOfChineseDatabase + "/api/v1/card_t/\(item.id)"
                let url = NSURL(string: strURL as String)!
                let task = dataSession.dataTaskWithURL(url, completionHandler: { (data, response, error) in
                    if error != nil {
                        print("获取卡数据出错:\(error!.localizedDescription)\(url)")
                        insideComplete(error)
                    }else {
                        if let card = CGSSCard.init(jsonData:data!){
                            let dao = CGSSDAO.sharedDAO
                            dao.cardDict.setObject(card, forKey: item.id)
                        }
                    }
                    insideComplete(nil)
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
                        print("获取谱面数据出错:\(error!.localizedDescription)\(url)")
                        insideComplete(error)
                    }else {
                        let beatmap = CGSSBeatmap.init(json: JSON.init(data: data!))
                        let dao = CGSSDAO.sharedDAO
                        dao.beatmapDict.setObject(beatmap, forKey: item.id)
                    }
                    insideComplete(nil)
                })
                task.resume()
            }
        }
    }

    private func getStringByPattern(str:String, pattern:String) -> [NSString] {
        let regex = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive )
        let res = regex!.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        var arr = Array<NSString>()
        for checkingRes in res {
            
            arr.append((str as NSString).substringWithRange(checkingRes.range))
            
        }
        return arr
    }
    
//    func updateAll() {
//        updateCardIconData()
//        updateCardData()
//    }
//    //获取偶像的小头像图标
//    func updateCardIconData() {
//        
//        let strURL = "https://hoshimoriuta.kirara.ca/icons2/icons@2x.css"
//        let url = NSURL(string: strURL as String)!
//        let task = dataSession.dataTaskWithURL(url) { (data, response, error) in
//            if error != nil {
//                print("获取头像图标css文件失败:\(error?.localizedDescription)")
//            } else {
//                let dataStr = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
//                //let cardIconDict = NSMutableDictionary()
//                let dao = CGSSDAO.sharedDAO
//                
//                for id in self.cardsNeedUpdate {
//                    let pattern = id + "\\{([^\\{]*)\\}"
//                    let subStr = self.getStringByPattern(dataStr, pattern: pattern).first as? String ?? ""
//
//                    let file_name = self.getStringByPattern(subStr, pattern: "icons_[0-9]+@2x.jpg").first
//                    let urlx = self.getStringByPattern(subStr, pattern: "icons[^\"]+").first
//                    
//                    
//                    let arr = self.getStringByPattern(subStr, pattern: "[0-9]+px")
//                    var arr2 = [Int]()
//                    for str in arr {
//                        let integer = str.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "px"))
//                        
//                        arr2.append(Int(integer)!)
//                    }
//                    if arr2.count < 2 {
//                        continue
//                    }
//                    let cardIcon = CGSSCardIcon.init(card_id: Int(id), file_name: file_name as? String, url: urlx as? String, xoffset: arr2[0], yoffset: arr2[1])
//                    dao.cardIconDict.setObject(cardIcon, forKey: id)
//                    //一个图标文件包含很多小图标 要避免重复
//                    let urlNeedToUpdate = urlx as! String
//                    if !self.iconsNeedUpdate.contains(urlNeedToUpdate) {
//                        self.iconsNeedUpdate.append(urlNeedToUpdate)
//                    }
//                }
//                self.updateIconImageData()
//            }
//        }
//        
//        task.resume()
//        
//    }

//    
//    func updateIconImageData() {
////        dispatch_async(dispatch_get_main_queue(), { 
////            self.delegate?.currentContentType("更新图标数据")
////        })
//        for index in 0..<iconsNeedUpdate.count {
//            let urlStr = iconsNeedUpdate[index]
//            let strURL = CGSSUpdater.URLOfIcons + "/" + urlStr
//            
//            let url = NSURL(string: strURL as String)!
//            let task = dataSession.dataTaskWithURL(url, completionHandler: { (data, response, error) in
//                if error != nil {
//                    print("icon图片获取失败:\(error!.localizedDescription)\(url)")
//                }else {
//                    let file_name = self.getStringByPattern(urlStr, pattern: "icons_[0-9]+@2x.jpg").first
//                    //print(NSBundle.mainBundle().resourcePath)
//                    let toPath = CGSSDAO.path + "/Icons/" + (file_name as! String)
//                    data!.writeToFile(toPath, atomically: true)
////                    dispatch_async(dispatch_get_main_queue(), {
////                        self.delegate?.taskProgress(index+1, b: self.iconsNeedUpdate.count)
////                    })
//                }
//                //如果是最后一个图片 结束后发送完成通知
//                if index == self.iconsNeedUpdate.count - 1 {
//                    self.iconTaskFinished = true
//                    //dispatch_async(dispatch_get_main_queue(), {
//                    CGSSNotificationCenter.post("ICON_UPDATE_FINISH", object: self)
//                    //})
//
//                }
//            })
//            task.resume()
//        }
//
//    }
//    
    //获取偶像的卡片图
//    public func getCardImages (toPath:String) {
//        let dao = CGSSDAO.sharedDAO
//        let path = "/Users/zzk" + "/Documents/" + "cardImage/"
//        for item in (dao.cardDict?.allValues)! {
//            let card = item as! CGSSCard
//            
//            let url = NSURL(string: card.card_image_ref! as String)!
//            let request = NSURLRequest(URL: url)
//            if NSFileManager.defaultManager().fileExistsAtPath(path + String(card.id!) + ".png") {
//                continue
//            }
//            if let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil) {
//                //let toPath = NSHomeDirectory() + "/Documents/" + String(i) + ".jpg"
//                data.writeToFile(path + String(card.id!) + ".png", atomically: true)
//                print("写入卡片图id\(card.id!)")
//            }
//        }
//    }
    
    
    //获取偶像的大图
//    public func getFullImages (toPath:String) {
//        let dao = CGSSDAO.sharedDAO
//        let path = "/Users/zzk" + "/Documents/" + "fullImage/"
//        for item in (dao.cardDict?.allValues)! {
//            let card = item as! CGSSCard
//            if card.has_spread! {
//                let url = NSURL(string: card.spread_image_ref! as String)!
//                let request = NSURLRequest(URL: url)
//                if NSFileManager.defaultManager().fileExistsAtPath(path + String(card.id!) + ".png") {
//                    continue
//                }
//                
//                if let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil) {
//
//                    //let toPath = NSHomeDirectory() + "/Documents/" + String(i) + ".jpg"
//                    data.writeToFile(path + String(card.id!)+".png", atomically: true)
//                     print("写入大图id\(card.id!)")
//                }
//            }
//        }
//    }

    //public func getDataFromWebApi() {
  

//    public func checkUpdate() {
//        
//        clearNeedUpdate()
//        let url = CGSSUpdater.URLOfChineseDatabase + "/api/v1/list/card_t?key=id,evolution_id"
//        let task = dataSession.dataTaskWithURL(NSURL.init(string: url)!, completionHandler: { (data, response, error) in
//            if let e = error {
//                print("检查更新失败: \(e.localizedDescription)")
//            } else {
//                //self.parseData(data!)
//                //print(NSThread.currentThread() == NSThread.mainThread())
//                let dao = CGSSDAO.sharedDAO
//                let cardsInCache = dao.cardDict.allKeys as! [String]
//                for id in self.cardsNeedUpdate {
//                    if cardsInCache.contains(id) {
//                        let index = self.cardsNeedUpdate.indexOf(id)
//                        self.cardsNeedUpdate.removeAtIndex(index!)
//                    }
//                }
//                //CGSSNotificationCenter.post("CHECK_UPDATE_FINISH", object: self)
//                self.updateAll()
//            }
//        })
//        task.resume()
//    }
}

extension CGSSUpdater : NSURLSessionDelegate, NSURLSessionDataDelegate {
//    public func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
//        CGSSNotificationCenter.post("UPDATE_FINISH", object: self)
//    }
    
}

//
//  CGSSUpdater.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation


//protocol CGSSUpdaterDelegate {
//    func taskProgress(a:Int, b:Int)
//    func currentContentType(s:String)
//}

public class CGSSUpdater: NSObject {

    static let URLOfEnglishDatabase = "https://starlight.kirara.ca"
    static let URLOfChineseDatabase = "http://starlight.hyspace.io"
    static let URLOfImages = "https://hoshimoriuta.kirara.ca"
    static let URLOfWiki = "http://imascg-slstage-wiki.gamerch.com"
    static let URLOfIcons = "https://hoshimoriuta.kirara.ca/icons2"
    
    var cardsNeedUpdate = [String]()
    var iconsNeedUpdate = [String]()
    var cardsFinished = [String]()
    var iconsFinished = [String]()
    var session:NSURLSession!
    public var iconTaskFinished = false
    public var cardTaskFinished = false
    //var delegate:CGSSUpdaterDelegate?
    
    private func getStringByPattern(str:String, pattern:String) -> [NSString] {
        let regex = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive )
        let res = regex!.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        var arr = Array<NSString>()
        for checkingRes in res {
            
            arr.append((str as NSString).substringWithRange(checkingRes.range))
            
        }
        return arr
    }
    
    func updateAll() {
        updateCardIconData()
        updateCardData()
        
    }
    //获取偶像的小头像图标
    func updateCardIconData() {
        
        let strURL = "https://hoshimoriuta.kirara.ca/icons2/icons@2x.css"
        let url = NSURL(string: strURL as String)!
        let task = session.dataTaskWithURL(url) { (data, response, error) in
            if error != nil {
                print("获取头像图标css文件失败:\(error?.localizedDescription)")
            } else {
                let dataStr = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                //let cardIconDict = NSMutableDictionary()
                let dao = CGSSDAO.sharedDAO
                
                for id in self.cardsNeedUpdate {
                    let pattern = id + "\\{([^\\{]*)\\}"
                    let subStr = self.getStringByPattern(dataStr, pattern: pattern).first as? String ?? ""

                    let file_name = self.getStringByPattern(subStr, pattern: "icons_[0-9]+@2x.jpg").first
                    let urlx = self.getStringByPattern(subStr, pattern: "icons[^\"]+").first
                    
                    
                    let arr = self.getStringByPattern(subStr, pattern: "[0-9]+px")
                    var arr2 = [Int]()
                    for str in arr {
                        let integer = str.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "px"))
                        
                        arr2.append(Int(integer)!)
                    }
                    if arr2.count < 2 {
                        continue
                    }
                    let cardIcon = CGSSCardIcon.init(card_id: Int(id), file_name: file_name as? String, url: urlx as? String, xoffset: arr2[0], yoffset: arr2[1])
                    dao.cardIconDict.setObject(cardIcon, forKey: id)
                    //一个图标文件包含很多小图标 要避免重复
                    let urlNeedToUpdate = urlx as! String
                    if !self.iconsNeedUpdate.contains(urlNeedToUpdate) {
                        self.iconsNeedUpdate.append(urlNeedToUpdate)
                    }
                }
                self.updateIconImageData()
            }
        }
        
        task.resume()
        
    }

    
    func updateIconImageData() {
//        dispatch_async(dispatch_get_main_queue(), { 
//            self.delegate?.currentContentType("更新图标数据")
//        })
        for index in 0..<iconsNeedUpdate.count {
            let urlStr = iconsNeedUpdate[index]
            let strURL = CGSSUpdater.URLOfIcons + "/" + urlStr
            
            let url = NSURL(string: strURL as String)!
            let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("icon图片获取失败:\(error!.localizedDescription)\(url)")
                }else {
                    let file_name = self.getStringByPattern(urlStr, pattern: "icons_[0-9]+@2x.jpg").first
                    //print(NSBundle.mainBundle().resourcePath)
                    let toPath = CGSSDAO.path + "/Icons/" + (file_name as! String)
                    data!.writeToFile(toPath, atomically: true)
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self.delegate?.taskProgress(index+1, b: self.iconsNeedUpdate.count)
//                    })
                }
                //如果是最后一个图片 结束后发送完成通知
                if index == self.iconsNeedUpdate.count - 1 {
                    self.iconTaskFinished = true
                    //dispatch_async(dispatch_get_main_queue(), {
                    CGSSNotificationCenter.post("ICON_UPDATE_FINISH", object: self)
                    //})

                }
            })
            task.resume()
        }

    }
    
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
    func updateCardData() {
//        dispatch_async(dispatch_get_main_queue(), {
//            self.delegate?.currentContentType("更新卡数据")
//        })

        for index in 0..<cardsNeedUpdate.count {
            let cardId = cardsNeedUpdate[index]
            let strURL = CGSSUpdater.URLOfChineseDatabase + "/api/v1/card_t/\(cardId)"
            let url = NSURL(string: strURL as String)!
            let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("获取卡数据出错:\(error!.localizedDescription)\(url)")
                }else {
                    if let card = CGSSCard.init(jsonData:data!){
                        let dao = CGSSDAO.sharedDAO
//                        if dao.findSkillById(card.skill_id!) == nil {
//                            self.skillsNeedUpdate.append(String(card.skill_id!))
//                        }
//                        if dao.findLeaderSkillById(card.leader_skill_id!) == nil {
//                            self.leaderSkillsNeedUpdate.append(String(card.leader_skill_id!))
//                        }
//                        if dao.findSkillById(card.chara_id!) == nil {
//                            self.charsNeedUpdate.append(String(card.chara_id!))
//                        }
//                        dispatch_async(dispatch_get_main_queue(), {
//                            self.delegate?.taskProgress(index+1, b: self.cardsNeedUpdate.count)
//                        }) 
                        //card.update_date = NSDate()
                        dao.cardDict.setObject(card, forKey: cardId)
                    }
                }
                //如果是最后一个卡数据 结束后发送完成通知
                if index == self.cardsNeedUpdate.count - 1 {
                    self.cardTaskFinished = true
                    //dispatch_async(dispatch_get_main_queue(), {
                    CGSSNotificationCenter.post("CARD_UPDATE_FINISH", object: self)
                    //})
                }
            
            })
            task.resume()
        }
    }
    
    func clearNeedUpdate() {
        iconTaskFinished = false
        cardTaskFinished = false
        cardsNeedUpdate.removeAll()
        iconsNeedUpdate.removeAll()
    }


    public func checkUpdate() {
        
        clearNeedUpdate()
        prepareSession()
        let url = CGSSUpdater.URLOfChineseDatabase + "/api/v1/list/card_t?key=id,evolution_id"
        let task = session.dataTaskWithURL(NSURL.init(string: url)!, completionHandler: { (data, response, error) in
            if let e = error {
                print("检查更新失败: \(e.localizedDescription)")
            } else {
                self.parseData(data!)
                let dao = CGSSDAO.sharedDAO
                let cardsInCache = dao.cardDict.allKeys as! [String]
                for id in self.cardsNeedUpdate {
                    if cardsInCache.contains(id) {
                        let index = self.cardsNeedUpdate.indexOf(id)
                        self.cardsNeedUpdate.removeAtIndex(index!)
                    }
                }
                //CGSSNotificationCenter.post("CHECK_UPDATE_FINISH", object: self)
                self.updateAll()
            }
        })
        task.resume()
    }
    func parseData(data:NSData) {
        let root = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String:AnyObject]
        let result = root["result"] as! [[String:AnyObject]]
        for card in result {
            let id = card["id"] as! Int
            cardsNeedUpdate.append(String(id))
            if let evolutionId = card["evolution_id"] as? Int{
                cardsNeedUpdate.append(String(evolutionId))
            }
        }
    }
    func prepareSession() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        //更新时不使用本地缓存数据
        sessionConfig.requestCachePolicy = .ReloadIgnoringLocalCacheData
        session = NSURLSession.init(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }
}

extension CGSSUpdater : NSURLSessionDelegate, NSURLSessionDataDelegate {
//    public func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
//        CGSSNotificationCenter.post("UPDATE_FINISH", object: self)
//    }
    
}

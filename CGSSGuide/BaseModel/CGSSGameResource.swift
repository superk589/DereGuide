//
//  CGSSGameResource.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import FMDB

class Master: FMDatabase {
    
    func isFesGachaAvailable(cardId:Int) -> Bool {
        let selectSql = "select exists (select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription like '%フェス限定%' and recommend_order > 0 and reward_id = \(cardId))"
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            if set.next() {
                if set.int(forColumnIndex: 0) == 1 {
                    return true
                }
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return false
    }
    
    func isTimeLimitGachaAvailable(cardId:Int) -> Bool {
        let selectSql = "select exists (select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription like '%期間限定%' and recommend_order > 0 and reward_id = \(cardId))"
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            if set.next() {
                if set.int(forColumnIndex: 0) == 1 {
                    return true
                }
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return false
    }
    
    func isGachaAvailable(cardId:Int) -> Bool {
        let selectSql = "select exists (select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and reward_id = \(cardId))"
        
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            if set.next() {
                if set.int(forColumnIndex: 0) == 1 {
                    return true
                }
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return false
    }
    
    func isEventAvailable(cardId:Int) -> Bool {
        let selectSql = "select exists (select reward_id from event_available where reward_id = \(cardId))"
        
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            if set.next() {
                if set.int(forColumnIndex: 0) == 1 {
                    return true
                }
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return false
    }
    
    func getEventAvailableList() -> [Int] {
        let selectSql = "select reward_id from event_available"
        var result = [Int]()
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                let rewardId = set.int(forColumnIndex: 0)
                result.append(Int(rewardId))
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return result
    }
    func getGachaAvailableList() -> [Int] {
        let selectSql = "select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription not like '%限定%'"
        var result = [Int]()
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                let rewardId = set.int(forColumnIndex: 0)
                result.append(Int(rewardId))
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return result
    }
    func getTimeLimitAvailableList() -> [Int] {
        let selectSql = "select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription like '%期間限定%' and recommend_order > 0"
        var result = [Int]()
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                let rewardId = set.int(forColumnIndex: 0)
                result.append(Int(rewardId))
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return result
    }
    func getFesAvailableList() -> [Int] {
        let selectSql = "select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription like '%フェス限定%' and recommend_order > 0"
        var result = [Int]()
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                let rewardId = set.int(forColumnIndex: 0)
                result.append(Int(rewardId))
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return result
    }
    
    func getValidGacha() -> [CGSSGachaPool] {
        //    {
        //
        //    "dicription" : "新SSレア堀裕子登場 ! 10連ガシャはSレア以上のアイドル1人が確定で出現 ! ! ※アイドルの所属上限を超える場合、プレゼントに送られます。",
        //    "end_date" : "2016-09-14 14:59:59",
        //    "id" : "30067",
        //    "name" : "プラチナオーディションガシャ",
        //    "rare_ratio" : "8850",
        //    "sr_ratio" : "1000",
        //    "ssr_ratio" : "150",
        //    "start_date" : "2016-09-09 15:00:00",
        //    }
//        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = CGSSGlobal.timeZoneOfTyoko
        
        let selectSql = "select a.id, a.name, a.dicription, a.start_date, a.end_date, b.rare_ratio, b.sr_ratio, b.ssr_ratio from gacha_data a, gacha_rate b where a.id = b.id and a.id like '3%' order by end_date DESC"

        var pools = [CGSSGachaPool]()
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                let endDate = set.string(forColumn: "end_date")
//                if let date = dateFormatter.date(from: endDate!) {
////                    if now > date && pools.count > 9 {
////                        break
////                    }
//                }
                let id = Int(set.int(forColumn: "id"))
                let name = set.string(forColumn: "name")
                let dicription = set.string(forColumn: "dicription")
                let startDate = set.string(forColumn: "start_date")
                
                let rareRatio = Int(set.int(forColumn: "rare_ratio"))
                let srRatio = Int(set.int(forColumn: "sr_ratio"))
                let ssrRatio = Int(set.int(forColumn: "ssr_ratio"))
                
                let rewardSql = "select * from gacha_available where gacha_id = \(id)"
                var rewards = [(Int, Int)]()
                let subSet = try self.executeQuery(rewardSql, values: nil)
                while subSet.next() {
                    let rewardId = Int(subSet.int(forColumn: "reward_id"))
                    let recommend_order = Int(subSet.int(forColumn: "recommend_order"))
                    rewards.append((rewardId, recommend_order))
                }
                
                
                let gachaPool = CGSSGachaPool.init(id: id, name: name!, dicription: dicription!, start_date: startDate!, end_date: endDate!, rare_ratio: rareRatio, sr_ratio: srRatio, ssr_ratio: ssrRatio, rewards: rewards)
                pools.append(gachaPool)
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return pools
    }
    
    func selectTextBy(category:Int, index:Int) -> String {
        let selectSql = "select * from text_data where category = \(category) and \"index\" = \(index)"
        var result = ""
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            if set.next() {
                result = set.string(forColumn: "text")
            }
        } catch {
            print(self.lastErrorMessage())
        }
        
        return result
    }
    
    
    func getEvents() -> [CGSSEvent] {
        var events = [CGSSEvent]()
        let selectSql = "select * from event_data order by event_start asc"
        do {
            var grooveOrParadeCount = 0
            var count = 0
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                count += 1
                let sortId = count > 16 ? count + 2 : count + 1
                let id = Int(set.int(forColumn: "id"))
                let type = Int(set.int(forColumn: "type"))
                let name = set.string(forColumn: "name")
                let startDate = set.string(forColumn: "event_start")
                let endDate = set.string(forColumn: "event_end")
                let secondHalfStartDate = set.string(forColumn: "second_half_start")
                
                let rewardSql = "select * from event_available where event_id = \(id)"
                var rewards = [Reward]()
                let subSet = try self.executeQuery(rewardSql, values: nil)
                while subSet.next() {
                    let rewardId = Int(subSet.int(forColumn: "reward_id"))
                    let recommend_order = Int(subSet.int(forColumn: "recommend_order"))
                    let reward = Reward.init(cardId: rewardId, rewardRecommand: recommend_order)
                    rewards.append(reward)
                }
                
                var liveId: Int = 0
                if type == 5 || type == 3 {
                    grooveOrParadeCount += 1
                    let liveSql = "select * from live_data where sort = \(3000 + grooveOrParadeCount)"
                    let subSet2 = try self.executeQuery(liveSql, values: nil)
                    while subSet2.next() {
                        liveId = Int(subSet2.int(forColumn: "id"))
                        break
                    }
                } else {
                    let liveSql = "select * from live_data where sort = \(id)"
                    let subSet2 = try self.executeQuery(liveSql, values: nil)
                    while subSet2.next() {
                        liveId = Int(subSet2.int(forColumn: "id"))
                        break
                    }
                }
                let event = CGSSEvent.init(sortId: sortId, id: id, type: type, startDate: startDate!, endDate: endDate!, name: name!, secondHalfStartDate: secondHalfStartDate!, reward: rewards, liveId: liveId)
               
                events.append(event)
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return events.reversed()
        
    }
    
    func getMusicIdBy(eventId:Int) -> Int? {
        let selectSql = "select a.music_data_id, b.id from live_data a, event_data b where b.id = a.sort and b.id = \(eventId)"
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                let musicId = set.int(forColumn: "music_data_id")
                return Int(musicId)
            }
        } catch {
            print(self.lastErrorMessage())
        }
        return nil
    }
}

class Manifest: FMDatabase {
    
    func selectByName(_ string: String) -> [String] {
        let selectSql = "select * from manifests where name = \"\(string)\""
        var hashTable = [String]()
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                hashTable.append(set.string(forColumn: "hash"))
            }
        } catch {
            print(self.lastErrorMessage())
        }
        
        return hashTable
    }
}

class CGSSGameResource: NSObject {
    
    static let sharedResource = CGSSGameResource()
    
    static let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/GameResource"
    
    static let masterPath = path + "/master.db"
    
    static let manifestPath = path + "/manifest.db"
    
    lazy var master: Master = {
        let db = Master.init(path: CGSSGameResource.masterPath)
        return db!
    }()
    
    lazy var manifest: Manifest = {
        let db = Manifest.init(path: CGSSGameResource.manifestPath)
        return db!
    }()
    
    fileprivate override init() {
        super.init()
        self.prepareFileDirectory()
        self.prepareGachaList()
        CGSSNotificationCenter.add(self, selector: #selector(updateEnd), name: CGSSNotificationCenter.updateEnd, object: nil)
        // self.loadAllDataFromFile()
    }
    
    deinit {
        CGSSNotificationCenter.removeAll(self)
    }
    func prepareFileDirectory() {
        if !FileManager.default.fileExists(atPath: CGSSGameResource.path) {
            do {
                try FileManager.default.createDirectory(atPath: CGSSGameResource.path, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                // print(error)
            }
        }
    }
    
    func saveManifest(_ data: Data) {
        prepareFileDirectory()
        try? data.write(to: URL(fileURLWithPath: CGSSGameResource.manifestPath), options: [.atomic])
    }
    func saveMaster(_ data: Data) {
        prepareFileDirectory()
        try? data.write(to: URL(fileURLWithPath: CGSSGameResource.masterPath), options: [.atomic])
    }
    
    func checkMaster() -> Bool {
        return FileManager.default.fileExists(atPath: CGSSGameResource.masterPath)
    }
    
    func getMasterHash() -> String? {
        guard manifest.open() else {
            return nil
        }
        defer {
            manifest.close()
        }
        return manifest.selectByName("master.mdb").first
    }
    
    func getTextData(category:Int, index:Int) -> String {
        guard master.open() else {
            return ""
        }
        defer {
            master.close()
        }
        return master.selectTextBy(category: category, index: index)
    }
    
    func getGachaPool() -> [CGSSGachaPool] {
        guard master.open() else {
            return [CGSSGachaPool]()
        }
        defer {
            master.close()
        }
        return master.getValidGacha()
    }
    
    func getEvent() -> [CGSSEvent] {
        guard master.open() else {
            return [CGSSEvent]()
        }
        defer {
            master.close()
        }
        return master.getEvents()
        
    }
    
    
    
    func getCardAvailable(cardId:Int) -> (Bool, Bool, Bool, Bool) {
        guard master.open() else {
            return (false, false, false, false)
        }
        defer {
            master.close()
        }
        return (master.isEventAvailable(cardId: cardId), master.isGachaAvailable(cardId: cardId), master.isTimeLimitGachaAvailable(cardId: cardId), master.isFesGachaAvailable(cardId: cardId))
    }
    
    
    func updateEnd() {
        prepareGachaList()
        // updateCardData()
    }
    
    // MARK: 卡池数据部分
    var eventAvailabelList:[Int]!
    var gachaAvailabelList:[Int]!
    var timeLimitAvailableList:[Int]!
    var fesAvailabelList:[Int]!
    func prepareGachaList() {
        guard self.master.open() else {
            eventAvailabelList = [Int]()
            gachaAvailabelList = [Int]()
            timeLimitAvailableList = [Int]()
            fesAvailabelList = [Int]()
            return
        }
        defer {
            self.master.close()
        }

        eventAvailabelList = self.master.getEventAvailableList()
        gachaAvailabelList = self.master.getGachaAvailableList()
        timeLimitAvailableList = self.master.getTimeLimitAvailableList()
        fesAvailabelList = self.master.getFesAvailableList()
    }
//    func updateCardData() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            let dao = CGSSDAO.sharedDAO
//            for card in dao.cardDict.allValues as! [CGSSCard] {
//                if [.sr, .ssr].contains(card.rarityType) && card.availableTypes?.rawValue == 0 {
//                    if self.eventAvailabelList.contains(card.id) {
//                        card.availableTypes = .event
//                    } else if self.fesAvailabelList.contains(card.id) {
//                        card.availableTypes = .fes
//                    } else if self.timeLimitAvailableList.contains(card.id) {
//                        card.availableTypes = .limit
//                    } else if self.gachaAvailabelList.contains(card.id) {
//                        card.availableTypes = .normal
//                    }
//                }
//            }
//            dao.saveDataToFile(.card, complete: nil)
//        }
//    }
    
    
    func getMusicIdBy(eventId:Int) -> Int? {
        guard self.master.open() else {
            return nil
        }
        defer {
            self.master.close()
        }
        return master.getMusicIdBy(eventId: eventId)
    }
}

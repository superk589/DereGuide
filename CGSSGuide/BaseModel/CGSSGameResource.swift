//
//  CGSSGameResource.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import FMDB
typealias FMDBCallBackClosure<T> = (T) -> Void

class MusicScoreDB: FMDatabaseQueue {

    func getBeatmaps(callback: @escaping FMDBCallBackClosure<[CGSSBeatmap]>) {
        inDatabase { (fmdb) in
            var beatmaps = [CGSSBeatmap]()
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select * from blobs where name like '%_1.csv' or name like '%_2.csv' or name like '%_3.csv' or name like '%_4.csv' or name like '%_5.csv' order by name asc"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        while set.next() {
                            if let data = set.data(forColumn: "data") {
                                if let beatmap = CGSSBeatmap.init(data: data) {
                                    beatmaps.append(beatmap)
                                }
                            }
                        }
                    }
                    catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(beatmaps)
        }
    }
}

class Master: FMDatabaseQueue {
    
    func isFesGachaAvailable(cardId: Int, callback: @escaping FMDBCallBackClosure<Bool>) {
        inDatabase { (fmdb) in
            var result = false
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select exists (select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription like '%フェス限定%' and recommend_order > 0 and reward_id = \(cardId))"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        if set.next() {
                            if set.int(forColumnIndex: 0) == 1 {
                                result = true
                            }
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(result)
        }
    }
    
    func isTimeLimitGachaAvailable(cardId: Int, callback: @escaping FMDBCallBackClosure<Bool>) {
        inDatabase { (fmdb) in
            var result = false
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select exists (select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription like '%期間限定%' and recommend_order > 0 and reward_id = \(cardId))"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        if set.next() {
                            if set.int(forColumnIndex: 0) == 1 {
                                result = true
                            }
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(result)
        }
    }
    
    func isGachaAvailable(cardId: Int, callback: @escaping FMDBCallBackClosure<Bool>) {
        inDatabase { (fmdb) in
            var result = false
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    
                    let selectSql = "select exists (select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and reward_id = \(cardId))"
                    
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        if set.next() {
                            if set.int(forColumnIndex: 0) == 1 {
                                result = true
                            }
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(result)
        }
    }
    
    func isEventAvailable(cardId: Int, callback: @escaping FMDBCallBackClosure<Bool>) {
        inDatabase { (fmdb) in
            var result = false
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select exists (select reward_id from event_available where reward_id = \(cardId))"
                    
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        if set.next() {
                            if set.int(forColumnIndex: 0) == 1 {
                                result = true
                            }
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(result)
        }
    }
    
    func getEventAvailableList(callback: @escaping FMDBCallBackClosure<[Int]>) {
        inDatabase { (fmdb) in
            var list = [Int]()
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select reward_id from event_available"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        while set.next() {
                            let rewardId = set.int(forColumnIndex: 0)
                            list.append(Int(rewardId))
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                    
                    // snow wings 两张活动卡数据库中遗失 做特殊处理
                    list.append(200129)
                    list.append(300135)
                }
            }
            callback(list)
        }
    }
    func getGachaAvailableList(callback: @escaping FMDBCallBackClosure<[Int]>) {
        inDatabase { (fmdb) in
            var list = [Int]()
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription not like '%限定%'"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        while set.next() {
                            let rewardId = set.int(forColumnIndex: 0)
                            list.append(Int(rewardId))
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(list)
        }
    }
    func getTimeLimitAvailableList(callback: @escaping FMDBCallBackClosure<[Int]>) {
        inDatabase { (fmdb) in
            var list = [Int]()
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    
                    let selectSql = "select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription like '%期間限定%' and recommend_order > 0"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        while set.next() {
                            let rewardId = set.int(forColumnIndex: 0)
                            list.append(Int(rewardId))
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(list)
        }
    }
    func getFesAvailableList(callback: @escaping FMDBCallBackClosure<[Int]>) {
        inDatabase { (fmdb) in
            var list = [Int]()
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription like '%フェス限定%' and recommend_order > 0"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        while set.next() {
                            let rewardId = set.int(forColumnIndex: 0)
                            list.append(Int(rewardId))
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(list)
        }
    }
    
    func getValidGacha(callback: @escaping FMDBCallBackClosure<[CGSSGachaPool]>) {
        inDatabase { (fmdb) in
            var list = [CGSSGachaPool]()
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select a.id, a.name, a.dicription, a.start_date, a.end_date, b.rare_ratio, b.sr_ratio, b.ssr_ratio from gacha_data a, gacha_rate b where a.id = b.id and a.id like '3%' order by end_date DESC"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        while set.next() {
                            let endDate = set.string(forColumn: "end_date")
                            let id = Int(set.int(forColumn: "id"))
                            let name = set.string(forColumn: "name")
                            let dicription = set.string(forColumn: "dicription")
                            let startDate = set.string(forColumn: "start_date")
                            
                            let rareRatio = Int(set.int(forColumn: "rare_ratio"))
                            let srRatio = Int(set.int(forColumn: "sr_ratio"))
                            let ssrRatio = Int(set.int(forColumn: "ssr_ratio"))
                            
                            let rewardSql = "select * from gacha_available where gacha_id = \(id)"
                            var rewards = [(Int, Int)]()
                            let subSet = try db.executeQuery(rewardSql, values: nil)
                            while subSet.next() {
                                let rewardId = Int(subSet.int(forColumn: "reward_id"))
                                let recommend_order = Int(subSet.int(forColumn: "recommend_order"))
                                rewards.append((rewardId, recommend_order))
                            }
                            
                            let gachaPool = CGSSGachaPool.init(id: id, name: name!, dicription: dicription!, start_date: startDate!, end_date: endDate!, rare_ratio: rareRatio, sr_ratio: srRatio, ssr_ratio: ssrRatio, rewards: rewards)
                            list.append(gachaPool)
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(list)
        }
    }
    
    func selectTextBy(category: Int, index: Int, callback: @escaping FMDBCallBackClosure<String>) {
        inDatabase { (fmdb) in
            var result = ""
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select * from text_data where category = \(category) and \"index\" = \(index)"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        if set.next() {
                            result = set.string(forColumn: "text")
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(result)
        }
    }
    
    
    func getEvents(callback: @escaping FMDBCallBackClosure<[CGSSEvent]>) {
        inDatabase { (fmdb) in
            var list = [CGSSEvent]()
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select * from event_data order by event_start asc"
                    do {
                        var grooveOrParadeCount = 0
                        var count = 0
                        let set = try db.executeQuery(selectSql, values: nil)
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
                            let subSet = try db.executeQuery(rewardSql, values: nil)
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
                                let subSet2 = try db.executeQuery(liveSql, values: nil)
                                while subSet2.next() {
                                    liveId = Int(subSet2.int(forColumn: "id"))
                                    break
                                }
                            } else {
                                let liveSql = "select * from live_data where sort = \(id)"
                                let subSet2 = try db.executeQuery(liveSql, values: nil)
                                while subSet2.next() {
                                    liveId = Int(subSet2.int(forColumn: "id"))
                                    break
                                }
                            }
                            let event = CGSSEvent.init(sortId: sortId, id: id, type: type, startDate: startDate!, endDate: endDate!, name: name!, secondHalfStartDate: secondHalfStartDate!, reward: rewards, liveId: liveId)
                           
                            list.append(event)
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(list)
        }
    }
    
    func getLiveBy(id: Int, callback: @escaping FMDBCallBackClosure<CGSSLive?>) {
        inDatabase { (fmdb) in
            var result: CGSSLive?
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select * from live_data a, music_data b where a.music_data_id = b.id and a.id = '\(id)'"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        while set.next() {
                            
                            let id = Int(set.int(forColumn: "id"))
                            let musicId = Int(set.int(forColumn: "music_data_id"))
                            let musicTitle = set.string(forColumn: "name") ?? ""
                            let type = Int(set.int(forColumn: "type"))
                            let d1 = Int(set.int(forColumn: "difficulty_1"))
                            let d2 = Int(set.int(forColumn: "difficulty_2"))
                            let d3 = Int(set.int(forColumn: "difficulty_3"))
                            let d4 = Int(set.int(forColumn: "difficulty_4"))
                            let d5 = Int(set.int(forColumn: "difficulty_5"))
                            var liveDetailId = [d1, d2, d3, d4]
                            if d5 != 0 {
                                liveDetailId.append(d5)
                            }
                            var levels = [Int: Int]()
                            for detaiId in liveDetailId {
                                let subSql = "select * from live_detail where id = \(detaiId)"
                                let subSet = try db.executeQuery(subSql, values: nil)
                                while subSet.next() {
                                    levels[detaiId] = Int(set.int(forColumn: "level_vocal"))
                                }
                            }
                            let debut = levels[d1] ?? 0
                            let regular = levels[d2] ?? 0
                            let pro = levels[d3] ?? 0
                            let master = levels[d4] ?? 0
                            let masterPlus = levels[d5] ?? 0
                            
                            let eventType = Int(set.int(forColumn: "event_type"))
                            let bpm = Int(set.int(forColumn: "bpm"))
                            
                            let live = CGSSLive.init(id: id, musicId: musicId, musicTitle: musicTitle, type: type, liveDetailId: liveDetailId, eventType: eventType, debut: debut, regular: regular, pro: pro, master: master, masterPlus: masterPlus, bpm: bpm)
                            
                            result = live
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(result)
        }
    }
    
    func getLives(callback: @escaping FMDBCallBackClosure<[CGSSLive]>) {
        inDatabase { (fmdb) in
            var list = [CGSSLive]()
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select a.id, max(a.event_type) event_type, a.music_data_id, a.difficulty_1, a.difficulty_2, a.difficulty_3, a.difficulty_4, a.difficulty_5,a.type, b.bpm, b.name from live_data a, music_data b where a.music_data_id = b.id group by music_data_id"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        while set.next() {
                            
                            let id = Int(set.int(forColumn: "id"))
                            let musicId = Int(set.int(forColumn: "music_data_id"))
                            let musicTitle = set.string(forColumn: "name")?.replacingOccurrences(of: "\\n", with: "") ?? ""
                            let type = Int(set.int(forColumn: "type"))
                            let d1 = Int(set.int(forColumn: "difficulty_1"))
                            let d2 = Int(set.int(forColumn: "difficulty_2"))
                            let d3 = Int(set.int(forColumn: "difficulty_3"))
                            let d4 = Int(set.int(forColumn: "difficulty_4"))
                            let d5 = Int(set.int(forColumn: "difficulty_5"))
                            var liveDetailId = [d1, d2, d3, d4]
                            if d5 != 0 {
                                liveDetailId.append(d5)
                            }
                            var levels = [Int: Int]()
                            for detaiId in liveDetailId {
                                let subSql = "select * from live_detail where id = \(detaiId)"
                                let subSet = try db.executeQuery(subSql, values: nil)
                                while subSet.next() {
                                    levels[detaiId] = Int(subSet.int(forColumn: "level_vocal"))
                                }
                            }
                            let debut = levels[d1] ?? 0
                            let regular = levels[d2] ?? 0
                            let pro = levels[d3] ?? 0
                            let master = levels[d4] ?? 0
                            let masterPlus = levels[d5] ?? 0
                            
                            let eventType = Int(set.int(forColumn: "event_type"))
                            let bpm = Int(set.int(forColumn: "bpm"))
                            
                            // 去掉一些无效数据
                            if [1901].contains(musicId) { continue }
                            
                            let live = CGSSLive.init(id: id, musicId: musicId, musicTitle: musicTitle, type: type, liveDetailId: liveDetailId, eventType: eventType, debut: debut, regular: regular, pro: pro, master: master, masterPlus: masterPlus, bpm: bpm)
                            
                            list.append(live)
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(list)
        }
    }
    
    func getMusicIdBy(eventId: Int, callback: @escaping FMDBCallBackClosure<Int?>) {
        inDatabase { (fmdb) in
            var result: Int?
            if let db = fmdb {
                if db.open(withFlags: SQLITE_OPEN_READONLY) {
                    defer {
                        db.close()
                    }
                    let selectSql = "select a.music_data_id, b.id from live_data a, event_data b where b.id = a.sort and b.id = \(eventId)"
                    do {
                        let set = try db.executeQuery(selectSql, values: nil)
                        while set.next() {
                            let musicId = set.int(forColumn: "music_data_id")
                            result = Int(musicId)
                        }
                    } catch {
                        print(db.lastErrorMessage())
                    }
                }
            }
            callback(result)
        }
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
    
    func getMusicScores() -> [String: String] {
        let selectSql = "select * from manifests where name like \"musicscores_m%.bdb\""
        var hashTable = [String: String]()
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                if let name = set.string(forColumn: "name").match(pattern: "m([0-9]*)\\.").first {
                    let hash = set.string(forColumn: "hash")
                    hashTable[name] = hash
                }
            }
        }
        catch {
            print(self.lastErrorMessage())
        }
        return hashTable
    }
}

class CGSSGameResource: NSObject {
    
    static let shared = CGSSGameResource()
    
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
    
    func checkMasterExistence() -> Bool {
        let fm = FileManager.default
        return fm.fileExists(atPath: CGSSGameResource.masterPath) && (NSData.init(contentsOfFile: CGSSGameResource.masterPath)?.length ?? 0) > 0
    }
    
    func checkManifestExistence() -> Bool {
        let fm = FileManager.default
        return fm.fileExists(atPath: CGSSGameResource.manifestPath) && (NSData.init(contentsOfFile: CGSSGameResource.manifestPath)?.length ?? 0) > 0
    }
    
    func getMasterHash() -> String? {
        guard manifest.open(withFlags: SQLITE_OPEN_READONLY) else {
            return nil
        }
        defer {
            manifest.close()
        }
        return manifest.selectByName("master.mdb").first
    }
    
    func getScoreHash() -> [String: String] {
        guard manifest.open(withFlags: SQLITE_OPEN_READONLY) else {
            return [String: String]()
        }
        defer {
            manifest.close()
        }
        return manifest.getMusicScores()
    }
    
    func getBeatmaps(liveId: Int) -> [CGSSBeatmap]? {
        let path = String.init(format: DataPath.beatmap, liveId)
        let fm = FileManager.default
        var result: [CGSSBeatmap]?
        let semaphore = DispatchSemaphore.init(value: 0)
        if fm.fileExists(atPath: path), let fmdbQueue = MusicScoreDB.init(path: path) {
            fmdbQueue.getBeatmaps(callback: { (beatmaps) in
                result = beatmaps
                semaphore.signal()
            })
        } else {
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }

    
    func updateEnd() {
        prepareGachaList()
        // updateCardData()
    }
    
    // MARK: 卡池数据部分
    var eventAvailabelList = [Int]()
    var gachaAvailabelList = [Int]()
    var timeLimitAvailableList = [Int]()
    var fesAvailabelList = [Int]()
    func prepareGachaList() {
        master.getEventAvailableList { (result) in
            self.eventAvailabelList = result
        }
        master.getGachaAvailableList { (result) in
            self.gachaAvailabelList = result
        }
        master.getTimeLimitAvailableList { (result) in
            self.timeLimitAvailableList = result
        }
        master.getFesAvailableList { (result) in
            self.fesAvailabelList = result
        }
    }
}

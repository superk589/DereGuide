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
    
    func isTimeLimitGachaAvailable(cardId:Int) -> Bool {
        let selectSql = "select exists (select a.id, a.dicription, b.reward_id from gacha_data a, gacha_available b where a.id = b.gacha_id and a.dicription like '%限定%' and reward_id = \(cardId))"
        
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
        let selectSql = "select exists (select reward_id from gacha_data a, event_available b where reward_id = \(cardId))"
        
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
    
    func getValidGacha() -> [GachaPool] {
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
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = CGSSGlobal.timeZoneOfTyoko
        
        let selectSql = "select a.id, a.name, a.dicription, a.start_date, a.end_date, b.rare_ratio, b.sr_ratio, b.ssr_ratio from gacha_data a, gacha_rate b where a.id = b.id order by end_date DESC"

        var pools = [GachaPool]()
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                let endDate = set.string(forColumn: "end_date")
                if let date = dateFormatter.date(from: endDate!) {
                    if now > date && pools.count > 0 {
                        break
                    }
                }
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
                
                
                let gachaPool = GachaPool.init(id: id, name: name!, dicription: dicription!, start_date: startDate!, end_date: endDate!, rare_ratio: rareRatio, sr_ratio: srRatio, ssr_ratio: ssrRatio, rewards: rewards)
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
        // self.loadAllDataFromFile()
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
    
    func getGachaPool() -> [GachaPool]? {
        guard master.open() else {
            return nil
        }
        defer {
            master.close()
        }
        return master.getValidGacha()
    }
    
    func getCardAvailable(cardId:Int) -> (Bool, Bool, Bool) {
        guard master.open() else {
            return (false, false, false)
        }
        defer {
            master.close()
        }
        return (master.isEventAvailable(cardId: cardId), master.isGachaAvailable(cardId: cardId), master.isTimeLimitGachaAvailable(cardId: cardId))
    }
}

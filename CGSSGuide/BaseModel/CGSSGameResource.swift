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
//    func getRecentGacha() -> GachaPool? {
//        let selectSql = "select * from gacha_data a, gacha_rate b where a.id = b.id order by end_date DESC"
//        do {
//            let set = try self.executeQuery(selectSql, values: nil)
//            if set.next() {
//                let gachaPool = GachaPool.init(fromJson: <#T##JSON!#>)
//                hashTable.append(set.stringForColumn("hash"))
//            }
//        } catch {
//            print(self.lastErrorMessage())
//        }
//        return nil
//    }
}

class Manifest: FMDatabase {
    
    func selectByName(string: String) -> [String] {
        let selectSql = "select * from manifests where name = \"\(string)\""
        var hashTable = [String]()
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            while set.next() {
                hashTable.append(set.stringForColumn("hash"))
            }
        } catch {
            print(self.lastErrorMessage())
        }
        
        return hashTable
    }
}

class CGSSGameResource: NSObject {
    
    static let sharedResource = CGSSGameResource()
    
    static let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first! + "/GameResource"
    
    static let masterPath = path + "/master.db"
    
    static let manifestPath = path + "/manifest.db"
    
    lazy var master: Master = {
        let db = Master.init(path: CGSSGameResource.masterPath)
        return db
    }()
    
    lazy var manifest: Manifest = {
        let db = Manifest.init(path: CGSSGameResource.manifestPath)
        return db
    }()
    
    private override init() {
        super.init()
        self.prepareFileDirectory()
        // self.loadAllDataFromFile()
    }
    
    func prepareFileDirectory() {
        if !NSFileManager.defaultManager().fileExistsAtPath(CGSSGameResource.path) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(CGSSGameResource.path, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                // print(error)
            }
        }
    }
    
    func saveManifest(data: NSData) {
        data.writeToFile(CGSSGameResource.manifestPath, atomically: true)
    }
    func saveMaster(data: NSData) {
        data.writeToFile(CGSSGameResource.masterPath, atomically: true)
    }
    
    func checkMaster() -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(CGSSGameResource.masterPath)
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
}

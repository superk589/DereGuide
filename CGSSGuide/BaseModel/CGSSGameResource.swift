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
    
    func selectTextBy(category:Int, index:Int) -> String {
        let selectSql = "select * from text_data where category = '\(category)' and \"index\" = '\(index)'"
        var result = ""
        do {
            let set = try self.executeQuery(selectSql, values: nil)
            set.next()
            result = set.string(forColumn: "text")
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
}

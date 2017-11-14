//
//  CGSSDAO.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import FMDB

public enum CGSSDataKey: String {
    case skill = "skill"
    case card = "card"
    case char = "char"
    case leaderSkill = "leader_skill"
    static let allValues = [skill, card, char, leaderSkill]
}

struct DataPath {
    static let root: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/Data"
    static let beatmap: String = DataPath.root + "/Beatmap/%03d.bdb"
}

open class CGSSDAO: NSObject {
    
    open static let shared = CGSSDAO()
    
    // 主数据 采用懒加载
    open lazy var skillDict = CGSSDAO.loadDataFromFile(.skill)
    open lazy var cardDict = CGSSDAO.loadDataFromFile(.card)
    open lazy var leaderSkillDict = CGSSDAO.loadDataFromFile(.leaderSkill)
    open lazy var charDict = CGSSDAO.loadDataFromFile(.char)
    
    // beatmap采用分歌曲单独存储
    open var beatmapDict = NSMutableDictionary()
    
    // 以musicId为key, 有效的live为值的字典
//    open var validLiveDict: [String: CGSSLive] {
//        var lives = [String: CGSSLive]()
//        for live in liveDict.allValues as! [CGSSLive] {
//            if [1018].contains(live.musicId) { continue }
//            if [514].contains(live.id) { continue }
//            if lives.keys.contains(String(live.musicId)) {
//                if lives[String(live.musicId)]!.eventType < live.eventType {
//                    lives[String(live.musicId)] = live
//                }
//            } else {
//                lives[String(live.musicId)] = live
//            }
//        }
//        return lives
//    }
    
    static let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    
    fileprivate static func getDataPath(_ key: CGSSDataKey) -> String? {
        // return NSBundle.mainBundle().pathForResource(key.rawValue, ofType: "plist")
        // return NSHomeDirectory() + "/Documents/" + key.rawValue + ".plist"
        return CGSSDAO.path + "/Data/" + key.rawValue + ".plist"
    }
    
    func getDictForKey(_ key: CGSSDataKey) -> NSMutableDictionary {
        switch key {
        case .skill:
            return self.skillDict
        case .card:
            return self.cardDict
        case .char:
            return self.charDict
        case .leaderSkill:
            return self.leaderSkillDict
       }
    }
    
    func saveDataToFile(_ key: CGSSDataKey, complete: (() -> Void)?) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.prepareFileDirectory()
            
            let path = CGSSDAO.getDataPath(key)
            let theData = NSMutableData()
            let achiver = NSKeyedArchiver(forWritingWith: theData)
            achiver.encode(self.getDictForKey(key), forKey: key.rawValue)
            achiver.finishEncoding()
            theData.write(toFile: path!, atomically: true)
        
            DispatchQueue.main.async(execute: {
                complete?()
            })
        }
    }
    
    fileprivate static func loadDataFromFile(_ key: CGSSDataKey) -> NSMutableDictionary {
        if let path = getDataPath(key) {
            if let theData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let achiver = NSKeyedUnarchiver(forReadingWith: theData)
                return achiver.decodeObject(forKey: key.rawValue) as? NSMutableDictionary ?? NSMutableDictionary()
            }
        }
        return NSMutableDictionary()
    }
    
    // 根据掩码筛选
    func getCardListByMask(_ cardMask: UInt, attributeMask: UInt, rarityMask: UInt, skillMask: UInt, gachaMask: UInt, favoriteMask: UInt?) -> [CGSSCard] {
        let filter = CGSSCardFilter.init(cardMask: cardMask, attributeMask: attributeMask, rarityMask: rarityMask, skillMask: skillMask ,gachaMask: gachaMask, conditionMask: 0b11111111, procMask: 0b1111, favoriteMask: favoriteMask)
        return filter.filter(cardDict.allValues as! [CGSSCard])
    }
    
    func getCardListByMask(_ filter: CGSSCardFilter) -> [CGSSCard] {
        return filter.filter(self.cardDict.allValues as! [CGSSCard])
    }
    
    func getCharListByFilter(_ filter: CGSSCharFilter) -> [CGSSChar] {
        return filter.filter(self.charDict.allValues as! [CGSSChar])
    }
    
    // 根据名字搜索
    func getCardListByName(_ cardList: [CGSSCard], string: String) -> [CGSSCard] {
        return cardList.filter { (v: CGSSCard) -> Bool in
            let comps = string.components(separatedBy: " ")
            for comp in comps {
                if comp == "" { continue }
                let b1 = v.name?.lowercased().contains(comp.lowercased()) ?? false
                let b2 = v.chara?.conventional?.lowercased().contains(comp.lowercased()) ?? false
                let b3 = v.skill?.skillType.lowercased().contains(comp.lowercased()) ?? false
                let b4 = v.rarity?.rarityString.lowercased() == comp.lowercased()
                if b1 || b2 || b3 || b4 {
                    continue
                } else {
                    return false
                }
            }
            return true
        }
    }
    
    func getCharListByName(_ charList: [CGSSChar], string: String) -> [CGSSChar] {
        return charList.filter { (v: CGSSChar) -> Bool in
            let comps = string.components(separatedBy: " ")
            for comp in comps {
                if comp == "" { continue }
                let b1 = v.name?.lowercased().contains(comp.lowercased()) ?? false
                let b2 = v.conventional?.lowercased().contains(comp.lowercased()) ?? false
                let b3 = v.voice?.lowercased().contains(comp.lowercased()) ?? false
                let b4 = v.nameKana?.lowercased().contains(comp.lowercased()) ?? false
                if b1 || b2 || b3 || b4 {
                    continue
                } else {
                    return false
                }
            }
            return true
        }
    }
    
    // 根据名字搜索live
    func getLiveListByName(_ liveList: [CGSSLive], string: String) -> [CGSSLive] {
        return liveList.filter { (v: CGSSLive) -> Bool in
            let comps = string.components(separatedBy: " ")
            for comp in comps {
                if comp == "" { continue }
                let b1 = v.name.lowercased().contains(comp.lowercased())
                if b1 {
                    continue
                } else {
                    return false
                }
            }
            return true
        }
    }
    
    func getEventListByName(_ eventList: [CGSSEvent], string: String) -> [CGSSEvent] {
        return eventList.filter { (v: CGSSEvent) -> Bool in
            let comps = string.components(separatedBy: " ")
            for comp in comps {
                if comp == "" { continue }
                let b1 = v.name.lowercased().contains(comp.lowercased())
                if b1 {
                    continue
                } else {
                    return false
                }
            }
            return true
        }
    }
    
    // 排序指定的CGSSBaseModel的list
    func sortListInPlace<T: CGSSBaseModel>(_ list: inout [T], property: String, ascending: Bool) {
        let sorter = CGSSSorter.init(property: property, ascending: ascending)
        sorter.sortList(&list)
    }
    
    func sortListInPlace<T: CGSSBaseModel>(_ list: inout [T], sorter: CGSSSorter) {
        sorter.sortList(&list)
    }
    
    func getCardDataBy(filter: CGSSCardFilter, sorter: CGSSSorter) -> [CGSSCard] {
        var cardList = filter.filter(cardDict.allValues as! [CGSSCard])
        sorter.sortList(&cardList)
        return cardList
    }
    
    func removeAllData() {
        for dataKey in CGSSDataKey.allValues {
            self.getDictForKey(dataKey).removeAllObjects()
        }

        let path = CGSSDAO.path + "/Data/Beatmap/"
        if let files = FileManager.default.subpaths(atPath: path) {
            for file in files {
                try? FileManager.default.removeItem(atPath: path.appendingFormat("/\(file)"))
            }
        }
    }
    
    fileprivate override init() {
        super.init()
        self.prepareFileDirectory()
        
        NotificationCenter.default.addObserver(self, selector: #selector(processedEnd(note:)), name: .gameResoureceProcessedEnd, object: nil)
        // self.loadAllDataFromFile()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func processedEnd(note: Notification) {
        saveAll {
            CGSSVersionManager.default.setDataVersionToNewest()
            CGSSVersionManager.default.setApiVersionToNewest()
        }
    }
    
    func prepareFileDirectory() {
        if !FileManager.default.fileExists(atPath: CGSSDAO.path + "/Data") {
            do {
                try FileManager.default.createDirectory(atPath: CGSSDAO.path + "/Data", withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                // print(error)
            }
        }
        if !FileManager.default.fileExists(atPath: CGSSDAO.path + "/Data/Beatmap") {
            do {
                try FileManager.default.createDirectory(atPath: CGSSDAO.path + "/Data/Beatmap", withIntermediateDirectories: true, attributes: nil)
            } catch {
                // print(error)
            }
        }
        
    }
    
    // 异步存储全部数据
    func saveAll(_ complete: (() -> Void)?) {
        prepareFileDirectory()
        var count = 0
        func completeInside() {
            count += 1
            if count == CGSSDataKey.allValues.count {
                // 因为saveDataToFile的回调已经是主线程了 所以此处没必要再dispatch_async到主线程
                complete?()
                NotificationCenter.default.post(name: .saveEnd, object: self)
            }
        }
        DispatchQueue.global(qos: .userInitiated).async {
            for dataKey in CGSSDataKey.allValues {
                self.saveDataToFile(dataKey, complete: completeInside)
            }
        }
    }
    
    func saveBeatmapData(data: Data, liveId: Int) {
        let url = URL.init(fileURLWithPath: String.init(format: DataPath.beatmap, liveId))
        try? data.write(to: url, options: Data.WritingOptions.atomic)
    }
    
    func findDataBy(_ type: CGSSDataKey, id: Int) -> AnyObject? {
        return self.getDictForKey(type).object(forKey: String(id)) as AnyObject?
    }
    
    func findCharById(_ id: Int) -> CGSSChar? {
        return self.charDict.object(forKey: String(id)) as? CGSSChar
    }
    
    func findSkillById(_ id: Int) -> CGSSSkill? {
        return self.skillDict.object(forKey: String(id)) as? CGSSSkill
    }
    
    func findLeaderSkillById(_ id: Int) -> CGSSLeaderSkill? {
        return self.leaderSkillDict.object(forKey: String(id)) as? CGSSLeaderSkill
    }
    
    func findCardById(_ id: Int) -> CGSSCard? {
        return self.cardDict.object(forKey: String(id)) as? CGSSCard
    }
    
    func findCardsByCharId(_ id: Int) -> [CGSSCard] {
        var cards = [CGSSCard]()
        for card in self.cardDict.allValues as! [CGSSCard] {
            if card.charaId == id {
                cards.append(card)
            }
        }
        return cards
    }
    
    
    func getRankInAll(_ card: CGSSCard) -> [Int] {
        // let vocal = card.vocal
        var rank = [1, 1, 1, 1]
        for cardx in cardDict.allValues as! [CGSSCard] {
            if cardx.vocal > card.vocal {
                rank[0] += 1
            }
            if cardx.dance > card.dance {
                rank[1] += 1
            }
            if cardx.visual > card.visual {
                rank[2] += 1
            }
            if cardx.overall > card.overall {
                rank[3] += 1
            }
        }
        return rank
    }
    
    func getRankInType(_ card: CGSSCard) -> [Int] {
        var rank = [1, 1, 1, 1]
        let filter = CGSSCardFilter.init(cardMask: card.cardType.rawValue, attributeMask: CGSSAttributeTypes.all.rawValue, rarityMask: CGSSRarityTypes.all.rawValue, skillMask: CGSSSkillTypes.all.rawValue, gachaMask: CGSSAvailableTypes.all.rawValue, conditionMask: CGSSConditionTypes.all.rawValue, procMask: CGSSProcTypes.all.rawValue, favoriteMask: CGSSFavoriteTypes.all.rawValue)
        let filteredCardDict = getCardListByMask(filter)
        for cardx in filteredCardDict {
            if cardx.vocal > card.vocal {
                rank[0] += 1
            }
            if cardx.dance > card.dance {
                rank[1] += 1
            }
            if cardx.visual > card.visual {
                rank[2] += 1
            }
            if cardx.overall > card.overall {
                rank[3] += 1
            }
        }
        return rank
    }
}


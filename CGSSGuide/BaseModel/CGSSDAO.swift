//
//  CGSSDAO.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

public enum CGSSDataKey: String {
    case Skill = "skill"
    case Card = "card"
    case Char = "char"
    case LeaderSkill = "leader_skill"
    case CardIcon = "card_icon"
    case Live = "live"
    case Song = "song"
    case Beatmap = "beatmap"
    case StoryEpisode = "story_episode"
    case StoryContent = "story_content"
    static let allValues = [Skill, Card, Char, LeaderSkill, CardIcon, Live, Song, Beatmap, StoryEpisode, StoryContent]
}

public class CGSSDAO: NSObject {
    
    public static let sharedDAO = CGSSDAO()
    
    // 主数据 采用懒加载
    public lazy var skillDict = CGSSDAO.loadDataFromFile(.Skill)
    public lazy var cardDict = CGSSDAO.loadDataFromFile(.Card)
    public lazy var leaderSkillDict = CGSSDAO.loadDataFromFile(.LeaderSkill)
    public lazy var charDict = CGSSDAO.loadDataFromFile(.Char)
    public lazy var cardIconDict = CGSSDAO.loadDataFromFile(.CardIcon)
    public lazy var songDict = CGSSDAO.loadDataFromFile(.Song)
    public lazy var storyEpisodeDict = CGSSDAO.loadDataFromFile(.StoryEpisode)
    public lazy var storyContentDict = CGSSDAO.loadDataFromFile(.StoryContent)
    public lazy var liveDict = CGSSDAO.loadDataFromFile(.Live)
    // beatmap字典存在载入性能问题 延迟大约3秒
    public lazy var beatmapDict = CGSSDAO.loadDataFromFile(.Beatmap)
    
    public var validLiveDict: [String: CGSSLive] {
        var lives = [String: CGSSLive]()
        for live in liveDict.allValues as! [CGSSLive] {
            if [1018].contains(live.musicId!) { continue }
            if [514].contains(live.id!) { continue }
            if lives.keys.contains(String(live.musicId!)) {
                if lives[String(live.musicId!)]!.eventType < live.eventType! {
                    lives[String(live.musicId!)] = live
                }
            } else {
                lives[String(live.musicId!)] = live
            }
        }
        return lives
    }
    
    static let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
    
    private static func getDataPath(key: CGSSDataKey) -> String? {
        // return NSBundle.mainBundle().pathForResource(key.rawValue, ofType: "plist")
        // return NSHomeDirectory() + "/Documents/" + key.rawValue + ".plist"
        return CGSSDAO.path + "/Data/" + key.rawValue + ".plist"
    }
    func getDictForKey(key: CGSSDataKey) -> NSMutableDictionary {
        switch key {
        case .Skill:
            return self.skillDict
        case .Card:
            return self.cardDict
        case .Char:
            return self.charDict
        case .LeaderSkill:
            return self.leaderSkillDict
        case .Song:
            return self.songDict
        case .Live:
            return self.liveDict
        case .StoryEpisode:
            return self.storyEpisodeDict
        case .Beatmap:
            return self.beatmapDict
        case .CardIcon:
            return self.cardIconDict
        case .StoryContent:
            return self.storyContentDict
        }
    }
    
    func saveDataToFile(key: CGSSDataKey, complete: (() -> Void)?) {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.prepareFileDirectory()
            let path = CGSSDAO.getDataPath(key)
            let theData = NSMutableData()
            let achiver = NSKeyedArchiver(forWritingWithMutableData: theData)
            achiver.encodeObject(self.getDictForKey(key), forKey: key.rawValue)
            achiver.finishEncoding()
            theData.writeToFile(path!, atomically: true)
            dispatch_async(dispatch_get_main_queue(), {
                complete?()
            })
        }
    }
    private static func loadDataFromFile(key: CGSSDataKey) -> NSMutableDictionary {
        if let path = getDataPath(key) {
            if let theData = NSData(contentsOfFile: path) {
                let achiver = NSKeyedUnarchiver(forReadingWithData: theData)
                return achiver.decodeObjectForKey(key.rawValue) as? NSMutableDictionary ?? NSMutableDictionary()
            }
        }
        return NSMutableDictionary()
    }
    
    // 根据掩码筛选
    func getCardListByMask(cardMask: UInt, attributeMask: UInt, rarityMask: UInt, favoriteMask: UInt?) -> [CGSSCard] {
        let filter = CGSSCardFilter.init(cardMask: cardMask, attributeMask: attributeMask, rarityMask: rarityMask, favoriteMask: favoriteMask)
        return filter.filterCardList(cardDict.allValues as! [CGSSCard])
    }
    func getCardListByMask(filter: CGSSCardFilter) -> [CGSSCard] {
        return filter.filterCardList(self.cardDict.allValues as! [CGSSCard])
    }
    
    // 根据名字搜索
    func getCardListByName(cardList: [CGSSCard], string: String) -> [CGSSCard] {
        return cardList.filter({ (v: CGSSCard) -> Bool in
            let comps = string.componentsSeparatedByString(" ")
            for comp in comps {
                if comp == "" { continue }
                let b1 = v.name?.lowercaseString.containsString(comp.lowercaseString) ?? false
                let b2 = v.chara?.conventional?.lowercaseString.containsString(comp.lowercaseString) ?? false
                let b3 = v.skill?.skillType.lowercaseString.containsString(comp.lowercaseString) ?? false
                let b4 = (v.rarity?.rarityString.lowercaseString == (comp.lowercaseString)) ?? false
                if b1 || b2 || b3 || b4 {
                    continue
                } else {
                    return false
                }
            }
            return true
        })
    }
    
    // 原地排序指定的cardList
    func sortCardListByAttibuteName(inout cardList: [CGSSCard], att: String, ascending: Bool) {
        
        let sorter = CGSSSorter.init(att: att, ascending: ascending)
        sorter.sortList(&cardList)
    }
    
    func sortCardListByAttibuteName(inout cardList: [CGSSCard], sorter: CGSSSorter) {
        sorter.sortList(&cardList)
    }
    
    // 原地排血指定的songList
    public func sortSongListByAttibuteName(inout songList: [CGSSSong], sorter: CGSSSorter) {
        sorter.sortList(&songList)
    }
    
    public func sortListByAttibuteName<T: CGSSBaseModel>(inout list: [T], sorter: CGSSSorter) {
        sorter.sortList(&list)
    }
    // 根据名字搜索live
    public func getLiveListByName(liveList: [CGSSLive], string: String) -> [CGSSLive] {
        return liveList.filter({ (v: CGSSLive) -> Bool in
            let song = findSongById(v.musicId!)
            let comps = string.componentsSeparatedByString(" ")
            for comp in comps {
                if comp == "" { continue }
                let b1 = song?.title?.lowercaseString.containsString(comp.lowercaseString) ?? false
                if b1 {
                    continue
                } else {
                    return false
                }
            }
            return true
        })
    }
    
    func removeAllData() {
        for dataKey in CGSSDataKey.allValues {
            self.getDictForKey(dataKey).removeAllObjects()
        }
    }
    
    private override init() {
        super.init()
        self.prepareFileDirectory()
        // self.loadAllDataFromFile()
    }
    
    func prepareFileDirectory() {
        if !NSFileManager.defaultManager().fileExistsAtPath(CGSSDAO.path + "/Data") {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(CGSSDAO.path + "/Data", withIntermediateDirectories: true, attributes: nil)
            } catch {
                // print(error)
            }
        }
    }
    
    /*func prepareDefaultData() {
        let nfd = NSFileManager.defaultManager()
        for dataKey in CGSSDataKey.allValues {
            if !nfd.fileExistsAtPath(CGSSDAO.path + "/Data/\(dataKey.rawValue).plist") {
                do {
                    let srcPath = NSBundle.mainBundle().pathForResource(dataKey.rawValue, ofType: "plist")
                    try nfd.moveItemAtPath(srcPath!, toPath: CGSSDAO.path + "/Data/\(dataKey.rawValue).plist")
                } catch {
                    // print(error)
                }
            }
        }
    }*/
    
    // 异步存储全部数据
    func saveAll(complete: (() -> Void)?) {
        var count = 0
        func completeInside() {
            count += 1
            if count == CGSSDataKey.allValues.count {
                //因为saveDataToFile的回调已经是主线程了 所以此处没必要再dispatch_async到主线程
                complete?()
            }
        }
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            for dataKey in CGSSDataKey.allValues {
                self.saveDataToFile(dataKey, complete: completeInside)
            }
        }
    }
    
    func findDataBy(type: CGSSDataKey, id: Int) -> AnyObject? {
        return self.getDictForKey(type).objectForKey(String(id))
    }
    
    func findCharById(id: Int) -> CGSSChar? {
        return self.charDict.objectForKey(String(id)) as? CGSSChar
    }
    
    func findSkillById(id: Int) -> CGSSSkill? {
        return self.skillDict.objectForKey(String(id)) as? CGSSSkill
    }
    
    func findLeaderSkillById(id: Int) -> CGSSLeaderSkill? {
        return self.leaderSkillDict.objectForKey(String(id)) as? CGSSLeaderSkill
    }
    
    func findCardById(id: Int) -> CGSSCard? {
        return self.cardDict.objectForKey(String(id)) as? CGSSCard
    }
    
    public func findSongById(id: Int) -> CGSSSong? {
        return self.songDict.objectForKey(String(id)) as? CGSSSong
    }
    
    public func findLiveById(id: Int) -> CGSSLive? {
        return self.liveDict.objectForKey(String(id)) as? CGSSLive
    }
    
    public func findBeatmapById(liveId: Int, diffId: Int) -> CGSSBeatmap? {
        let itemId = String(format: "%03d_%d", liveId, diffId)
        return self.beatmapDict.objectForKey(itemId) as? CGSSBeatmap
    }
    
    func findStoryEpisodeById(id: Int) -> CGSSStoryEpisode? {
        return self.storyEpisodeDict.objectForKey(String(id)) as? CGSSStoryEpisode
    }
    
    func findStoryContentById(id: Int) -> CGSSStoryContent? {
        return self.storyContentDict.objectForKey(String(id)) as? CGSSStoryContent
    }
    
//    public func findLivebySongId(id:Int) -> CGSSLive? {
//        var result:CGSSLive?
//        //如果同时有event版本和常规版本的歌曲 优先选择event版本
//        for v in self.liveDict.allValues {
//            let live = v as? CGSSLive
//            if live?.musicId == id && ((live?.eventType ?? 0) >= (result?.eventType ?? 0)) {
//                result = live
//            }
//        }
//        return result
//    }
    
    func getRankInAll(card: CGSSCard) -> [Int] {
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
    
    func getRankInType(card: CGSSCard) -> [Int] {
        var rank = [1, 1, 1, 1]
        let filter = CGSSCardFilter.init(cardMask: card.cardFilterType.rawValue, attributeMask: 0b1111, rarityMask: 0b11111111, favoriteMask: nil)
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
    
//    func getIconFromCardId(id:Int) -> UIImage? {
//        let dao = CGSSDAO.sharedDAO
//        let cardIcon = dao.cardIconDict.objectForKey(String(id)) as? CGSSCardIcon
//        if let iconFile = cardIcon?.file_name {
//            let path = CGSSDAO.path + "/Icons/" + iconFile
//            let image = UIImage(contentsOfFile: path)
//            if let cgRef = image?.CGImage {
//                let iconRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(96 * CGFloat(cardIcon!.col!), 96 * CGFloat(cardIcon!.row!) as CGFloat, 96, 96))
//                let icon = UIImage.init(CGImage: iconRef!)
//                return icon
//            } else {
//                let updater = CGSSUpdater.defaultUpdater
//                updater.iconsNeedUpdate.append((cardIcon?.url)!)
//                updater.updateIconImageData()
//                return nil
//            }
//        } else {
//            return nil
//        }
//    }
    
}


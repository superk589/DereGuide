//
//  CGSSDAO.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

public enum CGSSDataKey:String {
    case Skill = "skill"
    case Card = "card"
    case Char = "char"
    case LeaderSkill = "leader_skill"
    case CardIcon = "card_icon"
}

public class CGSSDAO: NSObject {
    
    public static let sharedDAO = CGSSDAO()
    
    public var skillDict = NSMutableDictionary()
    public var cardDict = NSMutableDictionary()
    public var leaderSkillDict = NSMutableDictionary()
    public var charDict = NSMutableDictionary()
    public var cardIconDict = NSMutableDictionary()
    
    static let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
    
    func getDataPath(key:CGSSDataKey) -> String? {
        //return NSBundle.mainBundle().pathForResource(key.rawValue, ofType: "plist")
        //return NSHomeDirectory() + "/Documents/" + key.rawValue + ".plist"
        return CGSSDAO.path + "/Data/" + key.rawValue + ".plist"
    }
    func getDictForKey(key:CGSSDataKey) -> NSMutableDictionary? {
        switch key {
        case .Skill:
            return self.skillDict
        case .Card:
            return self.cardDict
        case .Char:
            return self.charDict
        case .LeaderSkill:
            return self.leaderSkillDict
        case .CardIcon:
            return self.cardIconDict
        }
    }
    
    func saveDataToFile(key:CGSSDataKey) {
        let path = getDataPath(key)
        let theData = NSMutableData()
        let achiver = NSKeyedArchiver(forWritingWithMutableData: theData)
        achiver.encodeObject(getDictForKey(key) , forKey: key.rawValue)
        achiver.finishEncoding()
        theData.writeToFile(path!, atomically: true)
    }
    func loadDataFromFile(key:CGSSDataKey) {
        if let path = getDataPath(key) {
            if let theData = NSData(contentsOfFile: path) {
                let achiver = NSKeyedUnarchiver(forReadingWithData: theData)
                switch key {
                case .Skill:
                    self.skillDict = achiver.decodeObjectForKey(key.rawValue) as? NSMutableDictionary ?? NSMutableDictionary()
                case .Card:
                    self.cardDict = achiver.decodeObjectForKey(key.rawValue) as? NSMutableDictionary ?? NSMutableDictionary()
                case .Char:
                    self.charDict = achiver.decodeObjectForKey(key.rawValue) as? NSMutableDictionary ?? NSMutableDictionary()
                case .LeaderSkill:
                    self.leaderSkillDict = achiver.decodeObjectForKey(key.rawValue) as? NSMutableDictionary ?? NSMutableDictionary()
                case .CardIcon:
                    self.cardIconDict = achiver.decodeObjectForKey(key.rawValue) as? NSMutableDictionary ?? NSMutableDictionary()
                    //
                }
            }
        }
    }
    
    //根据掩码筛选
    public func getCardListByMask(cardMask:UInt, attributeMask:UInt, rarityMask:UInt, favoriteMask:UInt?) -> [CGSSCard] {
        let filter = CGSSCardFilter.init(cardMask: cardMask, attributeMask: attributeMask, rarityMask: rarityMask, favoriteMask: favoriteMask)
        return filter.filterCardList(cardDict.allValues as! [CGSSCard])
    }
    public func getCardListByMask(filter:CGSSCardFilter) -> [CGSSCard] {
        return filter.filterCardList(self.cardDict.allValues as! [CGSSCard])
    }
    
    //根据名字搜索
    public func getCardListByName(cardList:[CGSSCard], string:String) -> [CGSSCard] {
        return cardList.filter({ (v:CGSSCard) -> Bool in
            let comps = string.componentsSeparatedByString(" ")
            for comp in comps {
                if comp == "" {continue}
                let b1 = v.name?.lowercaseString.containsString(comp.lowercaseString) ?? false
                let b2 = v.chara?.conventional?.lowercaseString.containsString(comp.lowercaseString) ?? false
                let b3 = v.skill?.skill_type?.lowercaseString.containsString(comp.lowercaseString) ?? false
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

    
    //原地排序指定的cardList
    public func sortCardListByAttibuteName(inout cardList:[CGSSCard], att:String, ascending:Bool ) {
        
        let sorter = CGSSCardSorter.init(att: att, ascending: ascending)
        sorter.sortCardList(&cardList)
    }
    public func sortCardListByAttibuteName(inout cardList:[CGSSCard], sorter:CGSSCardSorter) {
        sorter.sortCardList(&cardList)
    }
    
    
    func loadAllDataFromFile() {
        loadDataFromFile(.Skill)
        loadDataFromFile(.LeaderSkill)
        loadDataFromFile(.Char)
        loadDataFromFile(.Card)
        loadDataFromFile(.CardIcon)
    }
    
    private override init() {

        super.init()
        self.prepareFileDirectory()
        //self.prepareDefaultData()
        self.loadAllDataFromFile()
        
        CGSSNotificationCenter.add(self, selector: #selector(saveIconData), name: "ICON_UPDATE_FINISH", object: nil)
        CGSSNotificationCenter.add(self, selector: #selector(saveCardData), name: "CARD_UPDATE_FINISH", object: nil)
        //try? initAllData()
        //checkForUpdate()
        //        for card in self.cardList!.allValues {
        //            let c = card as! CGSSCard
        //            print(c.name)
        //            print(c.album_id)
        //        }
    }
    
    
    func prepareFileDirectory() {
        if !NSFileManager.defaultManager().fileExistsAtPath(CGSSDAO.path + "/Data") {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(CGSSDAO.path + "/Data", withIntermediateDirectories: true, attributes: nil)
            }catch {
                print(error)
            }
        }
        if !NSFileManager.defaultManager().fileExistsAtPath(CGSSDAO.path + "/Icons") {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(CGSSDAO.path + "/Icons", withIntermediateDirectories: true, attributes: nil)
            }catch {
                print(error)
            }
        }
    }
    
    func prepareDefaultData() {
        let data = ["card_icon", "card", "char", "leader_skill", "skill"]
        let nfd = NSFileManager.defaultManager()
        for i in 0..<data.count {
            if !nfd.fileExistsAtPath(CGSSDAO.path + "/Data/\(data[i]).plist") {
                do {
                    let srcPath = NSBundle.mainBundle().pathForResource(data[i], ofType: "plist")
                    try nfd.moveItemAtPath(srcPath!, toPath: CGSSDAO.path + "/Data/\(data[i]).plist")
                }catch {
                    print(error)
                }
            }
        }
        
        for i in 0...7 {
            if !nfd.fileExistsAtPath(CGSSDAO.path + "/Icons/icons_\(i)@2x.jpg") {
                do {
                    let srcPath = NSBundle.mainBundle().pathForResource("icons_\(i)@2x", ofType: "jpg")
                    try nfd.moveItemAtPath(srcPath!, toPath: CGSSDAO.path + "/Icons/icons_\(i)@2x.jpg")
                }catch {
                    print(error)
                }
            }

        }

    }
    
    func saveIconData() {
        saveDataToFile(.CardIcon)
        CGSSNotificationCenter.post("UPDATE_DATA_SAVED", object: self)
    }
    
    func saveCardData() {
        //此处写数据应该更换线程
        saveDataToFile(.Card)
        saveDataToFile(.Skill)
        saveDataToFile(.LeaderSkill)
        saveDataToFile(.Char)
        CGSSNotificationCenter.post("UPDATE_DATA_SAVED", object: self)
    }
    
 
    
    public func findCharById(id:Int) -> CGSSChar? {
        let dic = self.charDict
        return dic.objectForKey(String(id)) as? CGSSChar
    }
    
    public func findSkillById(id:Int) -> CGSSSkill? {
        let dic = self.skillDict
        return dic.objectForKey(String(id)) as? CGSSSkill
    }
    
    public func findLeaderSkillById(id:Int) -> CGSSLeaderSkill? {
        let dic = self.leaderSkillDict
        return dic.objectForKey(String(id)) as? CGSSLeaderSkill
    }
    
    public func findCardById(id:Int) -> CGSSCard? {
        let dic = self.cardDict
        return dic.objectForKey(String(id)) as? CGSSCard
    }
    
    public func getRankInAll(card:CGSSCard) -> [Int] {
        //let vocal = card.vocal
        var rank = [1, 1, 1 ,1]
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
    
    public func getRankInType(card:CGSSCard) -> [Int] {
        var rank = [1, 1, 1 ,1]
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
    
    
    func getIconFromCardId(id:Int) -> UIImage? {
        let dao = CGSSDAO.sharedDAO
        let cardIcon = dao.cardIconDict.objectForKey(String(id)) as? CGSSCardIcon
        if let iconFile = cardIcon?.file_name {
            let path = CGSSDAO.path + "/Icons/" + iconFile
            let image = UIImage(contentsOfFile: path)
            if let cgRef = image?.CGImage {
                let iconRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(96 * CGFloat(cardIcon!.col!), 96 * CGFloat(cardIcon!.row!) as CGFloat, 96, 96))
                let icon = UIImage.init(CGImage: iconRef!)
                return icon
            } else {
                let updater = CGSSUpdater()
                updater.iconsNeedUpdate.append((cardIcon?.url)!)
                updater.prepareSession()
                updater.updateIconImageData()
                return nil
            }
        } else {
            return nil
        }
    }

}










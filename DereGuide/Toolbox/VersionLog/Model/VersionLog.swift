//
//  VersionLog.swift
//  PrincessGuide
//
//  Created by zzk on 2018/8/18.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

struct VersionLog: Codable {
    
    struct DataElement: Codable {
        
        struct Diff: Codable {
            let created: Int
            let changed: Int
            let deleted: Int
        }
        
        let diff: Diff
        let ver: String
        let time: Int
        let timeStr: String
        let hash: String
        
        let gekijouAnime: [VLGekijouAnime]?
        let card: [VLCard]?
        let event: [VLEvent]?
        let gacha: [VLGacha]?
        let gekijou: [VLGekijou]?
        let music: [VLMusic]?
        
        var list: [VLElement] {
            let elements: [[VLElement]?] = [
                gekijouAnime,
                card,
                event,
                gacha,
                gekijou,
                music
            ]
            return elements.compactMap { $0 }.flatMap { $0 }
        }
    }
    
    let page: Int
    let pages: Int
    let data: [DataElement]
}

struct Schedule: CustomStringConvertible {
    let start: String
    let end: String
    var startDate: Date {
        return start.toDate()
    }
    var endDate: Date {
        return end.toDate()
    }
    var description: String {
        let startDateString = startDate.toString(format: "(zzz)yyyy-MM-dd HH:mm:ss", timeZone: .current)
        let endDateString = endDate.toString(format: "yyyy-MM-dd HH:mm:ss", timeZone: .current)
        return "\(startDateString) ~ \(endDateString)"
    }
}

protocol VLElement {
    var content: String { get }
    var schedule: Schedule? { get }
}

struct VLGekijouAnime: Codable, VLElement {
    
    var content: String {
        let format = NSLocalizedString("新小剧场动画：%@ %@", comment: "")
        return String(format: format, title, chara)
    }
    
    var schedule: Schedule? {
        return nil
    }
    
    let id: Int
    let title: String
    let charaId: String
    let chara: String
}


struct VLEvent: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("新活动：%@", comment: "")
        return String(format: format, name)
    }
    
    var schedule: Schedule? {
        return Schedule(start: start, end: end)
    }
    
    
    let id: String
    let name: String
    let start: String
    let end: String
}

struct VLCard: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("新卡片：%@%@，技能：%@%@%@", comment: "")
        return String(format: format, CGSSRarityTypes(rarity: rarity - 1).description, name, condition.description, CGSSProcTypes(typeID: probabilityType).descriptionShort, CGSSSkillTypes(typeID: skillType).description)
    }
    var schedule: Schedule? {
        return nil
    }
    let id: String
    let name: String
    let rarity: Int
    let skillType: Int
    let condition: Int
    let probabilityType: Int
    let availableTimeType: Int
}

struct VLGacha: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("新卡池：%@", comment: "")
        return String(format: format, detail.replacingOccurrences(of: "\\n", with: " "))
    }
    var schedule: Schedule? {
        return Schedule(start: start, end: end)
    }
    
    let name: String
    let detail: String
    let end: String
    let id: String
    let start: String
}

struct VLGekijou: Codable, VLElement {
    var content: String {
        let format = NSLocalizedString("新小剧场：%@ %@", comment: "")
        return String(format: format, title, chara)
    }
    var schedule: Schedule? {
        return nil
    }
    let id: Int
    let title: String
    let charaId: String
    let chara: String
}

struct VLMusic: Codable, VLElement {
    let id: String
    let name: String
    
    var content: String {
        let format = NSLocalizedString("新歌曲：%@", comment: "")
        return String(format: format, name)
    }
    
    var schedule: Schedule? {
        return nil
    }
}

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
        
        var list: [VLElement] {
            let elements: [[VLElement]?] = [
                gekijouAnime
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
        let format = NSLocalizedString("新小剧场动画: %@ %@", comment: "")
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

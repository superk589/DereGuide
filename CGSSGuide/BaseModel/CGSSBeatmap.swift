//
//  CGSSBeatmap.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}

class CGSSBeatmapNote: NSObject, NSCoding {
    var id: Int!
    var sec: Float!
    var type: Int!
    var startPos: Int!
    var finishPos: Int!
    var status: Int!
    var sync: Int!
    var groupId: Int!
    
    // 0 no press, 1 start, 2 end
    var longPressType = 0
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.sec = aDecoder.decodeObject(forKey: "sec") as? Float
        self.type = aDecoder.decodeObject(forKey: "type") as? Int
        self.startPos = aDecoder.decodeObject(forKey: "startPos") as? Int
        self.finishPos = aDecoder.decodeObject(forKey: "finishPos") as? Int
        self.status = aDecoder.decodeObject(forKey: "status") as? Int
        self.sync = aDecoder.decodeObject(forKey: "sync") as? Int
        self.groupId = aDecoder.decodeObject(forKey: "groupId") as? Int
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.sec, forKey: "sec")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.startPos, forKey: "startPos")
        aCoder.encode(self.finishPos, forKey: "finishPos")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.sync, forKey: "sync")
        aCoder.encode(self.groupId, forKey: "groupId")
    }
}

class CGSSBeatmap: CGSSBaseModel {
    
    var notes: [CGSSBeatmapNote]
    
    var isValid: Bool {
        return notes.count > 0
    }
    var numberOfNotes: Int {
        if let note = notes.first {
            return note.status ?? 0
        }
        return 0
    }
    
    var firstNote: CGSSBeatmapNote? {
        if notes.count == 0 {
            return nil
        }
        for i in 0...notes.count - 1 {
            if notes[i].finishPos != 0 {
                return notes[i]
            }
        }
        return nil
    }
    
    var lastNote: CGSSBeatmapNote? {
        if notes.count == 0 {
            return nil
        }
        for i in 0...notes.count - 1 {
            if notes[notes.count - i - 1].finishPos != 0 {
                return notes[notes.count - i - 1]
            }
        }
        return nil
    }
    // 存在问题 官方加入了81 和 82两种type的标志性note 故此处不再采用起止位置的方式获得常规note
//    var startNoteIndex: Int {
//        for i in 0...notes.count - 1 {
//            if notes[i].finishPos != 0 {
//                return i
//            }
//        }
//        return notes.count - 1
//    }
//
//    var lastNoteIndex: Int {
//        for i in 0...notes.count - 1 {
//            if notes[notes.count - i - 1].finishPos != 0 {
//                return notes.count - i - 1
//            }
//        }
//        return 0
//    }
    
    lazy var validNotes: [CGSSBeatmapNote] = {
        var arr = [CGSSBeatmapNote]()
        for i in 0...self.notes.count - 1 {
            if self.notes[i].finishPos != 0 {
                arr.append(self.notes[i])
            }
        }
        return arr
    }()
    
    
    var maxLongPressInterval:Float = 0
    func contextFreeAllNotes() {
        var positionPressed = [Float].init(repeating: 0, count: 5)
        for note in self.notes {
            if note.finishPos! == 0 {
                continue
            }
            if note.type == 2 {
                if positionPressed[note.finishPos! - 1] == 0 {
                    note.longPressType = 1
                    positionPressed[note.finishPos! - 1] = note.sec ?? 0
                } else {
                    note.longPressType = 2
                    let interval = (note.sec ?? 0) - positionPressed[note.finishPos! - 1]
                    if interval > maxLongPressInterval {
                        maxLongPressInterval = interval
                    }
                    positionPressed[note.finishPos! - 1] = 0
                }
            } else if positionPressed[note.finishPos! - 1] > 0 {
                positionPressed[note.finishPos! - 1] = 0
                note.longPressType = 2
            }
        }
    }
    
    var preSeconds: Float! {
        return firstNote?.sec ?? 0
    }
    var postSeconds: Float {
        return lastNote?.sec ?? 0
    }
    var totalSeconds: Float {
        return notes.last?.sec ?? 0
    }
    
    var validSeconds: Float {
        return postSeconds - preSeconds
    }
    
    
//    func comboForSec(sec:Float) -> Int {
//        func findnear(sec:Float, start:Int, end:Int) -> Int {
//            if start == end {
//                return start - 2
//            }
//            let middle = (start + end) / 2
//            if abs(sec - notes[middle].sec!) <= 0.01 {
//                return middle - 1
//            } else if sec < notes[middle].sec {
//                return findnear(sec, start: start, end: middle)
//            } else {
//                return findnear(sec, start: middle + 1, end: end)
//            }
//        }
//        return findnear(sec + preSeconds!, start: 2, end: notes.count - 1)
//    }
    
    func getCriticalPointNoteIndexes() -> [Int] {
        var arr = [Int]()
        for i in CGSSGlobal.criticalPercent {
            arr.append(Int(floor(Float(numberOfNotes * i) / 100)))
        }
        return arr
    }
    
    // 折半查找指定秒数对应的combo数
    func comboForSec(_ sec: Float) -> Int {
        // 为了避免近似带来的误差 导致对压小节线的note计算不准确 此处加上0.0001
        let newSec = sec + preSeconds! + 0.0001
        var end = numberOfNotes - 1
        var start = 0
        while start <= end {
            let middle = (start + end) / 2
            if newSec < validNotes[middle].sec {
                end = middle - 1
            } else {
                start = middle + 1
            }
        }
        return start
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.notes = aDecoder.decodeObject(forKey: "notes") as? [CGSSBeatmapNote] ?? [CGSSBeatmapNote]()
        super.init(coder: aDecoder)
        
    }
    override open func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.notes, forKey: "notes")
    }
    init?(json: JSON) {
        self.notes = [CGSSBeatmapNote]()
        let array = json.arrayValue
        // 如果当返回的note为0时 暂时不返回nil 而是一个空的beatmap 防止重复更新一些非常规歌曲的谱面
//        if array.count == 0 {
//            return nil
//        }
        for sub in array {
            let note = CGSSBeatmapNote()
            note.id = sub["id"].intValue
            note.sec = sub["sec"].floatValue
            note.type = sub["type"].intValue
            note.startPos = sub["startPos"].intValue
            note.finishPos = sub["finishPos"].intValue
            note.status = sub["status"].intValue
            note.sync = sub["sync"].intValue
            note.groupId = sub["groupId"].intValue
            self.notes.append(note)
        }
        super.init()
    }
    
}

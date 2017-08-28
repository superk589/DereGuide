//
//  CGSSBeatmap.swift
//  DereGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

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
    // used in shifting bpm
    var offset: Float = 0
    
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
    
    var shiftingPoints: [BpmShiftingPoint]?

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
 
    lazy var validNotes: [CGSSBeatmapNote] = {
        var arr = [CGSSBeatmapNote]()
        for i in 0..<self.notes.count {
            if self.notes[i].finishPos != 0 {
                arr.append(self.notes[i])
            }
        }
        return arr
    }()
    
    
    var maxLongPressInterval: Float = 0
    func contextFreeAllNotes() {
        var positionPressed = [Float].init(repeating: 0, count: 5)
        var slides = [Int: Float]()
        for note in self.notes {
            if note.finishPos == 0 {
                continue
            }
            if note.type == 2 && positionPressed[note.finishPos! - 1] == 0 {
                // 长按起始点
                note.longPressType = 1
                positionPressed[note.finishPos! - 1] = note.sec + note.offset
            } else if positionPressed[note.finishPos! - 1] > 0 {
                // 长按结束点
                note.longPressType = 2
                let interval = (note.sec + note.offset) - positionPressed[note.finishPos! - 1]
                if interval > maxLongPressInterval {
                    maxLongPressInterval = interval
                }
                positionPressed[note.finishPos! - 1] = 0
            }
            
            if note.groupId != 0 {
                if slides[note.groupId] == nil {
                    // 滑条起始点
                    slides[note.groupId] = note.sec + note.offset
                } else {
                    // 滑条中间点或结束点
                    let interval = (note.sec + note.offset) - slides[note.groupId]!
                    // 对于个别歌曲(如:维纳斯, absolute nine) 组id存在复用问题 对interval进行额外判断 大于4s的flick间隔判断为不合法
                    if interval > maxLongPressInterval && !(note.type != 3 && interval > 4) {
                        maxLongPressInterval = interval
                    }
                    slides[note.groupId] = note.sec + note.offset
                }
            }
        }
    }
    
    func addShiftingOffset(info: CGSSBeatmapShiftingInfo, rawBpm: Int) {
        var offset: Float = 0
        if let bpm = info.shiftingPoints.first?.bpm {
            let bps = Float(bpm) / 60
            let spb = 1 / bps
            let remainder = secondOfFirstNote.truncatingRemainder(dividingBy: 4 * spb)
            if !(remainder < 0.001 || 4 * spb - remainder < 0.001) {
                offset = remainder * Float(bpm) / Float(rawBpm)
            }
        }
        
        shiftingPoints = [BpmShiftingPoint]()
        for range in info.shiftingRanges {
            for note in validNotes {
                if note.sec < range.start { continue }
                if note.sec >= range.end { break }
                note.offset = offset + (note.sec - range.start) * ((Float(range.bpm) / Float(rawBpm)) - 1)
            }
            var point = range.beginPoint
            point.timestamp += offset
            shiftingPoints?.append(point)
            offset += range.length * ((Float(range.bpm) / Float(rawBpm)) - 1)
        }
    }
    
    // 如果起始点不是整个小节的开端 添加偏移量(针对机器人29)
    func addStartOffset(rawBpm: Int) {
        let bps = Float(rawBpm) / 60
        let spb = 1 / bps
        let remainder = secondOfFirstNote.truncatingRemainder(dividingBy: 4 * spb)
        if remainder < 0.001 || 4 * spb - remainder < 0.001 { return }
        for note in validNotes {
            note.offset = remainder
        }
    }
    
    var secondOfFirstNote: Float {
        return firstNote?.sec ?? 0
    }
    
    var secondOfLastNote: Float {
        return lastNote?.sec ?? 0
    }
    
    var totalSeconds: Float {
        return notes.last?.sec ?? 0
    }
    
    var validSeconds: Float {
        return secondOfLastNote - secondOfFirstNote
    }
    
    // 折半查找指定秒数对应的combo数
    func comboForSec(_ sec: Float) -> Int {
        // 为了避免近似带来的误差 导致对压小节线的note计算不准确 此处加上0.0001
        let newSec = sec + secondOfFirstNote + 0.0001
        var end = numberOfNotes - 1
        var start = 0
        while start <= end {
            let middle = start + (end - start) / 2
            let middleNote = validNotes[middle]
            let middleSec = middleNote.sec + middleNote.offset
            if newSec < middleSec {
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
    
    init?(data: Data) {
        if let csv = String.init(data: data, encoding: .utf8) {
            let lines = csv.components(separatedBy: "\n")
            self.notes = [CGSSBeatmapNote]()
            for i in 0..<lines.count {
                let line = lines[i]
                if i == 0 {
                    continue
                } else {
                    let comps = line.components(separatedBy: ",")
                    if comps.count < 8 {
                        break
                    }
                    let note = CGSSBeatmapNote()
                    note.id = Int(comps[0]) ?? 0
                    note.sec = Float(comps[1]) ?? 0
                    note.type = Int(comps[2]) ?? 0
                    note.startPos = Int(comps[3]) ?? 0
                    note.finishPos = Int(comps[4]) ?? 0
                    note.status = Int(comps[5]) ?? 0
                    note.sync = Int(comps[6]) ?? 0
                    note.groupId = Int(comps[7]) ?? 0
                    self.notes.append(note)
                }
            }
            super.init()
        } else {
            return nil
        }
    }
    
    override init() {
        self.notes = [CGSSBeatmapNote]()
        super.init()
    }
    
    /* debug methods */
    #if DEBUG
    
    func exportIntervalToBpm() {
        let predict: Float = 1
        var arr = [Float]()
        for i in 0..<validNotes.count {
            if i == 0 { continue }
            let note = validNotes[i]
            let lastNote = validNotes[i - 1]
            arr.append(60 / (note.sec - lastNote.sec) * predict)
        }
        (arr as NSArray).write(toFile: NSHomeDirectory() + "/beat_interval.plist", atomically: true)
    }
    
    func exportNote() {
        var arr = [Float]()
        for i in 0..<validNotes.count {
            let note = validNotes[i]
            arr.append(note.sec)
        }
        (arr as NSArray).write(toFile: NSHomeDirectory() + "/notes.plist", atomically: true)
    }
    
    func exportNoteWithOffset() {
        var arr = [Float]()
        for i in 0..<validNotes.count {
            let note = validNotes[i]
            arr.append(note.sec + note.offset)
        }
        (arr as NSArray).write(toFile: NSHomeDirectory() + "/notes_with_offset.plist", atomically: true)
    }
    
    #endif
    
}

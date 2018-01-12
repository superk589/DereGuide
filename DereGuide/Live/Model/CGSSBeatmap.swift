//
//  CGSSBeatmap.swift
//  DereGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

class CGSSBeatmap {
    
    var notes: [CGSSBeatmapNote]
    
    var difficulty: CGSSLiveDifficulty
    
    var shiftingPoints: [BpmShiftingPoint]?
    
    var originalShiftingPoints: [BpmShiftingPoint]?
    
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
    
    // begin time of beatmap player
    lazy var beginTime = TimeInterval(self.timeOfFirstNote)
    
    func contextFree() {
        var positionPressed = [Int?](repeating: nil, count: 5)
        var slides = [Int: Int]()
        for (index, note) in self.validNotes.enumerated() {
            note.comboIndex = index + 1
            if note.type == 2 && positionPressed[note.finishPos - 1] == nil {
                note.longPressType = 1
                positionPressed[note.finishPos - 1] = index
            } else if positionPressed[note.finishPos - 1] != nil {
                let previousIndex = positionPressed[note.finishPos - 1]!
                let previous = validNotes[previousIndex]
                note.longPressType = 2
                previous.append(note)
                
                let startIndex = previousIndex + 1
                validNotes[startIndex..<index].forEach { $0.along = previous }
                positionPressed[note.finishPos - 1] = nil
            }
            
            if note.groupId != 0 {
                if slides[note.groupId] == nil {
                    // 滑条起始点
                    slides[note.groupId] = index
                } else {
                    let previousIndex = slides[note.groupId]!
                    let previous = validNotes[previousIndex]
                    // 对于个别歌曲(如:维纳斯, absolute nine) 组id存在复用问题 对interval进行额外判断 大于4s的flick间隔判断为不合法
                    if previous.intervalTo(note) < 4 || note.type == 3 {
                        previous.append(note)
                        
                        let startIndex = previousIndex + 1
                        validNotes[startIndex..<index].forEach { $0.along = previous }
                    }
                    slides[note.groupId] = index
                }
            }
            
        }
    }
    
    func addShiftingOffset(info: CGSSBeatmapShiftingInfo, rawBpm: Int) {
        
        // calculate start offset using the first bpm in shifting info
        var offset: Float = 0
        if let bpm = info.shiftingPoints.first?.bpm {
            let bps = Float(bpm) / 60
            let spb = 1 / bps
            let remainder = timeOfFirstNote.truncatingRemainder(dividingBy: 4 * spb)
            if !(remainder < 0.001 || 4 * spb - remainder < 0.001) {
                offset = remainder * Float(bpm) / Float(rawBpm)
                beginTime = TimeInterval(timeOfFirstNote - remainder)
            }
        } else {
            addStartOffset(rawBpm: rawBpm)
        }
        
        // add shift offset for each note using shift info
        shiftingPoints = [BpmShiftingPoint]()
        originalShiftingPoints = info.shiftingPoints
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
        
        // add offset from shifting info
        for note in validNotes {
            note.offset += info.offset
        }
    }
    
    // add start offset for non-shift-bpm live
    func addStartOffset(rawBpm: Int) {
        let bps = Float(rawBpm) / 60
        let spb = 1 / bps
        let remainder = timeOfFirstNote.truncatingRemainder(dividingBy: 4 * spb)
        if remainder < 0.001 || 4 * spb - remainder < 0.001 { return }
        for note in validNotes {
            note.offset = remainder
        }
        beginTime = TimeInterval(timeOfFirstNote - remainder)
    }
    
    var timeOfFirstNote: Float {
        return firstNote?.sec ?? 0
    }
    
    var timeOfLastNote: Float {
        return lastNote?.sec ?? 0
    }
    
    var totalSeconds: Float {
        return notes.last?.sec ?? 0
    }
    
    var validSeconds: Float {
        return timeOfLastNote - timeOfFirstNote
    }
    
    // 折半查找指定秒数对应的combo数
    func comboForSec(_ sec: Float) -> Int {
        // 为了避免近似带来的误差 导致对压小节线的note计算不准确 此处加上0.0001
        let newSec = sec + 0.0001 + timeOfFirstNote
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
    
    init?(data: Data, rawDifficulty: Int) {
       
        if let difficulty = CGSSLiveDifficulty(rawValue: rawDifficulty) {
            self.difficulty = difficulty
        } else {
            return nil
        }
        
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
        } else {
            return nil
        }
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

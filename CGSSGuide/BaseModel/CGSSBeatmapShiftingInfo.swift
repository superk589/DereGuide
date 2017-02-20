//
//  CGSSBeatmapShiftingInfo.swift
//  CGSSGuide
//
//  Created by zzk on 2017/2/20.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

struct BpmShiftingPoint {
    var bpm: Int
    var timestamp: Double
}

struct BpmShiftingRange {
    var start: Double
    var length: Double {
        return end - start
    }
    var end: Double
    var bpm: Int
}

extension CGSSBeatmapNote {
    func inRange(range: BpmShiftingRange) -> Bool {
        if sec >= range.start && sec < range.end {
            return true
        } else {
            return false
        }
    }
}

struct CGSSBeatmapShiftingInfo {
    var shiftingPoints = [BpmShiftingPoint]()
    var shiftingRanges = [BpmShiftingRange]()
    init(info: NSDictionary) {
        let timestampStrings = info.value(forKey: "timestamps") as! [String]
        let start = info.value(forKey: "start") as! Double
        for subString in timestampStrings {
            let value = subString.components(separatedBy: ",")
            let shiftingPoint = BpmShiftingPoint.init(bpm: Int(value[1])!, timestamp: Double(value[0])! + start)
            if let lastPoint = shiftingPoints.last {
                let shiftingRange = BpmShiftingRange.init(start: lastPoint.timestamp, end: shiftingPoint.timestamp, bpm: lastPoint.bpm)
                shiftingRanges.append(shiftingRange)
            }
            shiftingPoints.append(shiftingPoint)
        }
        if let lastPoint = shiftingPoints.last {
            let shiftingRange = BpmShiftingRange.init(start: lastPoint.timestamp, end: Double.infinity, bpm: lastPoint.bpm)
            shiftingRanges.append(shiftingRange)
        }
    }
}

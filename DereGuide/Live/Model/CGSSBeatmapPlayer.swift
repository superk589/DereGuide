//
//  CGSSBeatmapPlayer.swift
//  DereGuide
//
//  Created by zzk on 11/11/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CGSSBeatmapPlayer {

    var beatmap: CGSSBeatmap
    
    var rawBPM: Int
    
    init(beatmap: CGSSBeatmap, rawBPM: Int) {
        self.beatmap = beatmap
        self.rawBPM = rawBPM
    }
    
    private var beginTime: Date?
    
    var beginOffset: TimeInterval?
    
    func play(offset: TimeInterval) {
        beginTime = Date()
        beginOffset = offset
    }
    
    
    /// play with the given shiftedOffset
    ///
    /// - Parameter shiftedOffset: Beatmap drawer use the offset system, each note will have a offset when it has shifting bpm or not start its beat at the first note, so the shiftedOffset is the offset after shifting to beatmap drawer, the start line is always begining at the beatmap's first note's raw offset
    func play(shiftedOffset: TimeInterval) {
        play(offset: convertToOriginalOffset(shiftedOffset))
    }
    
    private func convertToOriginalOffset(_ shiftedOffset: TimeInterval) -> TimeInterval {
        if let points = beatmap.shiftingPoints {
            let prefix = points.prefix { shiftedOffset > TimeInterval($0.timestamp) }
            if prefix.count == 0 {
                let point = points.first!
                return beatmap.beginTime + (shiftedOffset - TimeInterval(beatmap.timeOfFirstNote)) * TimeInterval(rawBPM) / TimeInterval(point.bpm)
            } else {
                var originOffset: TimeInterval = 0
                for i in 0..<prefix.count {
                    let point = points[i]
                    if i == 0 {
                        originOffset += (TimeInterval(point.timestamp) - TimeInterval(beatmap.timeOfFirstNote)) * TimeInterval(rawBPM) / TimeInterval(point.bpm)
                    } else {
                        let previousPoint = points[i - 1]
                        originOffset += TimeInterval(point.timestamp - previousPoint.timestamp) * TimeInterval(rawBPM) / TimeInterval(previousPoint.bpm)
                    }
                }
                originOffset += (shiftedOffset - TimeInterval(prefix.last!.timestamp)) * TimeInterval(rawBPM) / TimeInterval(prefix.last!.bpm)
                return originOffset + beatmap.beginTime
            }
        } else {
            return beatmap.beginTime + shiftedOffset - TimeInterval(beatmap.timeOfFirstNote)
        }
    }
    
    private func convertToShiftedOffset(_ originalOffset: TimeInterval) -> TimeInterval {
        if let points = beatmap.originalShiftingPoints {
            let prefix = points.prefix { originalOffset > TimeInterval($0.timestamp) }
            if prefix.count == 0 {
                let point = points.first!
                return (originalOffset - beatmap.beginTime) / TimeInterval(rawBPM) * TimeInterval(point.bpm) + TimeInterval(beatmap.timeOfFirstNote)
            } else {
                var shiftedOffset: TimeInterval = 0
                for i in 0..<prefix.count {
                    let point = points[i]
                    if i == 0 {
                        shiftedOffset += (TimeInterval(point.timestamp) - TimeInterval(beatmap.beginTime)) / TimeInterval(rawBPM) * TimeInterval(point.bpm)
                    } else {
                        let previousPoint = points[i - 1]
                        shiftedOffset += TimeInterval(point.timestamp - previousPoint.timestamp) / TimeInterval(rawBPM) * TimeInterval(previousPoint.bpm)
                    }
                }
                shiftedOffset += (originalOffset - TimeInterval(prefix.last!.timestamp)) / TimeInterval(rawBPM) * TimeInterval(prefix.last!.bpm)
                return shiftedOffset + TimeInterval(beatmap.timeOfFirstNote)
            }
        } else {
            return originalOffset - beatmap.beginTime + TimeInterval(beatmap.timeOfFirstNote)
        }
    }
    
    func pause() {
        beginTime = nil
        beginOffset = nil
    }
    
    func currentOffset() -> TimeInterval {
        guard let beginTime = beginTime, let beginOffset = beginOffset else {
            return 0
        }
        let now = Date()
        let elapsed = now.timeIntervalSince(beginTime)
        return elapsed + beginOffset
    }
    
    func currentShiftedOffset() -> TimeInterval {
        return convertToShiftedOffset(currentOffset())
    }
    
    func currentBPM() -> Int {
        return beatmap.originalShiftingPoints?.prefix { TimeInterval($0.timestamp) < currentOffset() }.last?.bpm ?? beatmap.originalShiftingPoints?.first?.bpm ?? rawBPM
    }
    
}

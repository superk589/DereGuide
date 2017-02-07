//
//  CGSSShiftingBPMLive.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/2.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSShiftingBPMLive: CGSSLive {
    
//    static func checkIsShifting(_ live:CGSSLive) -> Bool {
//        let dao = CGSSDAO.sharedDAO
//        if let beatmap = dao.findBeatmapById(live.id, diffId: live.maxDiff) {
//            var noteIntervals = [Double]()
//            for note in beatmap.validNotes {
//                var interval = Double(note.sec!.truncatingRemainder(dividingBy: live.beatSec))
//                if interval < Double(live.beatSec) / 2 {
//                    interval = Double(live.beatSec) - interval
//                }
//                noteIntervals.append(interval)
//            }
//            let checkIntervals:[Double] = [1/16, 1/6, 1/12, 5/24, 7/24, 3/8, 11/24]
//            for interval in noteIntervals {
//                var checkResult = true
//                for base in checkIntervals {
//                // swift3中已经取消了%对非整形的操作, 改为使用truncatingRemainder
//                    let baseInterval = base * Double(live.beatSec)
//                    if min(interval.truncatingRemainder(dividingBy: baseInterval), baseInterval - interval.truncatingRemainder(dividingBy: baseInterval)) < baseInterval / 10 {
//                        checkResult = false
//                    }
//                }
//                if !checkResult { continue }
//                else { return true }
//            }
//            
//        }
//        return false
//    }
}

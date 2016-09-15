//
//  CGSSShiftingBPMLive.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/2.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSShiftingBPMLive: CGSSLive {

    
    static func checkIsShifting(_ live:CGSSLive) -> Bool {
        let dao = CGSSDAO.sharedDAO
        let maxDiff = (live.masterPlus == 0) ? 4 : 5
        if let beatmap = dao.findBeatmapById(live.id!, diffId: maxDiff) {
            var noteIntervals = [Float]()
            let firstNoteIndex = beatmap.notes.index(of: beatmap.firstNote!) ?? 0
            let lastNoteIndex = beatmap.notes.index(of: beatmap.lastNote!) ?? 0
            for index in firstNoteIndex..<lastNoteIndex {
                noteIntervals.append(beatmap.notes[index+1].sec! - beatmap.notes[index].sec!)
            }
            
            
            
            
            
            
            
        }
        return false
    }

}

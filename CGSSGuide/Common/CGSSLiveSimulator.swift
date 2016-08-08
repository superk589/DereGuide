//
//  CGSSLiveSimulator.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/8.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

enum ScoreUpType:String {
    case Combo = "Combo加分"
    case Overload = "过载"
    case Perfect = "PERFECT分数加成"
}

struct ScoreUpSchedule {
    var begin:Float
    var end:Float
    var upValue:Int
}

class CGSSLiveSimulator: NSObject {
    var team:CGSSTeam!
    var live:CGSSLive!
    var diff:Int!
    var liveType:CGSSLiveType!
    
    var presentTotal:Int {
        return team.getPresentValueByType(liveType, songType: live.songType).total
    }
    
    init(team:CGSSTeam, live:CGSSLive, liveType:CGSSLiveType, diff:Int) {
        self.team = team
        self.live = live
        self.diff = diff
        self.liveType = liveType
    }
    
    func simulateOnce(procMax:Bool, callBack:((Double)->Void)?) {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            
            let beatmap = self.live.getBeatmapByDiff(self.diff)!
            //此时不对小数部分进行取舍
            let scorePerNote = Float(self.presentTotal) * CGSSTool.diffScale[self.diff]! / Float(beatmap.numberOfNotes)
            let notes = beatmap.validNotes
            let criticalPoints = beatmap.getCriticalPointNoteIndexes()
            var criticalIndex = 0 
            var sum = 0.0
            for i in 0..<notes.count {
                let note = notes[i]
                if criticalIndex < criticalPoints.count - 1 {
                    if i >= criticalPoints[criticalIndex + 1] {
                        criticalIndex += 1
                    }
                }
                let comboScale = CGSSTool.comboScale[criticalIndex]
                if find  note.sec
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                callBack?(sum)
            })
        }
        
    }
    
    private func getSkillUpValueForNote(note:CGSSBeatmap.Note) -> Float {
        
    }
    
    private func getSimulateSchedules(procMax:Bool) -> [ScoreUpType:[ScoreUpSchedule]] {
        var scheduleDic = [ScoreUpType:[ScoreUpSchedule]]()
        scheduleDic[.Perfect] = [ScoreUpSchedule]()
        scheduleDic[.Combo] = [ScoreUpSchedule]()
        for rankedSkill in team.skills {
            if var type = ScoreUpType.init(rawValue: rankedSkill.skill.skill_type!) {
                if type == .Overload {
                    type = .Perfect
                }
                let tuples = rankedSkill.getRangesOfProc(live.getBeatmapByDiff(diff)!.totalSeconds, procMax: procMax)
                for tuple in tuples {
                    let schedule = ScoreUpSchedule.init(begin: tuple.0, end: tuple.1, upValue: rankedSkill.skill.value!)
                    scheduleDic[type]?.append(schedule)
                }
            }
        }
        return scheduleDic
    }

}

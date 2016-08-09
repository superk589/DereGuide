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
    
    
    
    func simulateOnce(procMax:Bool, callBack:((Int)->Void)?) {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            
            let beatmap = self.live.getBeatmapByDiff(self.diff)!
            //此时不对小数部分进行取舍 保留浮点部分
            let scorePerNote = Float(self.presentTotal) * CGSSTool.diffFactor[self.diff]! / Float(beatmap.numberOfNotes)
            //let notes = beatmap.validNotes
            let criticalPoints = beatmap.getCriticalPointNoteIndexes()
            let schedule = self.getSimulateSchedules(procMax)
            var criticalIndex = 0 
            var sum:Float = 0
            for i in beatmap.startNoteIndex...beatmap.lastNoteIndex {
                let note = beatmap.notes[i]
                if criticalIndex < criticalPoints.count - 1 {
                    if i - beatmap.startNoteIndex >= criticalPoints[criticalIndex + 1] {
                        criticalIndex += 1
                    }
                }
                let comboFactor = CGSSTool.comboFactor[criticalIndex]
                let skillFactor = self.getSkillFactorFor(note, schedules: schedule)
                //默认全P 不需要判定的因子 此处需要四舍五入
                sum += round (scorePerNote * comboFactor * skillFactor)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                callBack?(Int(sum))
            })
        }
        
    }
    
    func simulate(times:Int, callBack:((scores:[Int], avg:Int)->Void)?) {
        var arr = [Int]()
        var sum = 0
        func completeInside(score:Int) {
            arr.append(score)
            sum += score
            if arr.count == times {
                callBack?(scores: arr, avg: sum / times)
            }
        }
        for _ in 0..<times {
            simulateOnce(false) { (score) in
                completeInside(score)
            }
        }
    }
    func getSkillFactorFor(note:CGSSBeatmap.Note, schedules:[ScoreUpType: [ScoreUpSchedule]]) -> Float {
        var skillFactor:Float = 1
        for sub in schedules.values {
            var maxFactor:Float = 1
            for schedule in sub {
                if note.sec >= schedule.begin && note.sec <= schedule.end {
                    if Float(schedule.upValue) / 100 > maxFactor {
                        maxFactor = Float(schedule.upValue)
                    }
                }
            }
            skillFactor *= maxFactor
        }
        return skillFactor
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

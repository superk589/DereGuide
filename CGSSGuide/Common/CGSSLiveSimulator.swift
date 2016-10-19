//
//  CGSSLiveSimulator.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/8.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
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
//
//fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l >= r
//  default:
//    return !(lhs < rhs)
//  }
//}
//
//fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l <= r
//  default:
//    return !(rhs < lhs)
//  }
//}


enum ScoreUpType: String {
    case Combo = "COMBO加成"
    case Overload = "过载"
    case Perfect = "PERFECT分数加成"
    case Bonus = "分数加成"
}

struct ScoreUpSchedule {
    var begin: Float
    var end: Float
    var upValue: Int
}

class CGSSLiveSimulator: NSObject {
    var team: CGSSTeam!
    var live: CGSSLive!
    var diff: Int!
    var liveType: CGSSLiveType!
    var grooveType: CGSSGrooveType?
    var presentTotal: Int {
        if grooveType != nil {
            return team.getPresentValueByType(liveType, songType: CGSSCardTypes.init(grooveType: grooveType!)).total + team.backSupportValue
        } else {
            return team.getPresentValueByType(liveType, songType: live.songType).total + team.backSupportValue
        }
    }
    
    init(team: CGSSTeam, live: CGSSLive, liveType: CGSSLiveType, grooveType: CGSSGrooveType?, diff: Int) {
        self.team = team
        self.live = live
        self.diff = diff
        self.liveType = liveType
        self.grooveType = grooveType
    }
    
    func simulateOnce(_ procMax: Bool, manualValue:Int?, callBack: ((Int) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            let beatmap = self.live.getBeatmapByDiff(self.diff)!
            let diffStars = self.live.getStarsForDiff(self.diff)
            // 此时不对小数部分进行取舍 保留浮点部分
            let scorePerNote = Float((manualValue == nil) ? self.presentTotal : manualValue!) * CGSSGlobal.diffFactor[diffStars]! / Float(beatmap.numberOfNotes)
            let criticalPoints = beatmap.getCriticalPointNoteIndexes()
            let schedule = self.getSimulateSchedules(procMax)
            var criticalIndex = 0
            var sum: Float = 0
            
            // var log = [[Float]]()
            let validNotes = beatmap.validNotes
            for i in 1...validNotes.count {
                let note = validNotes[i - 1]
                if criticalIndex < criticalPoints.count - 1 {
                    if i >= criticalPoints[criticalIndex + 1] {
                        criticalIndex += 1
                    }
                }
                let comboFactor = CGSSGlobal.comboFactor[criticalIndex]
                let skillFactor = self.getSkillFactorFor(note, schedules: schedule)
                // 默认全P 不需要判定的因子 此处需要四舍五入
                sum += round (scorePerNote * comboFactor * skillFactor)
                // log.append([Float(i), sum, scorePerNote, comboFactor, skillFactor])
            }
            /*if procMax == true {
             (log as NSArray).writeToFile("/Users/zzk/Desktop/aaa.plist", atomically: true)
             }*/
            DispatchQueue.main.async(execute: {
                callBack?(Int(sum))
            })
        }
    }
    
    func simulate(_ times: Int, manualValue:Int?, callBack: ((_ scores: [Int], _ avg: Int) -> Void)?) {
        var arr = [Int]()
        var sum = 0
        func completeInside(_ score: Int) {
            arr.append(score)
            sum += score
            if arr.count == times {
                callBack?(arr, sum / times)
            }
        }
        for _ in 0..<times {
            simulateOnce(false, manualValue: manualValue) { (score) in
                completeInside(score)
            }
        }
    }
    func getSkillFactorFor(_ note: CGSSBeatmapNote, schedules: [ScoreUpType: [ScoreUpSchedule]]) -> Float {
        var skillFactor: Float = 1
        for sub in schedules.values {
            var maxFactor: Float = 1
            for schedule in sub {
                if note.sec >= schedule.begin && note.sec <= schedule.end {
                    if Float(schedule.upValue) / 100 > maxFactor {
                        maxFactor = Float(schedule.upValue) / 100
                    }
                }
            }
            skillFactor *= maxFactor
        }
        return skillFactor
    }
    
    fileprivate func getSimulateSchedules(_ procMax: Bool) -> [ScoreUpType: [ScoreUpSchedule]] {
        var scheduleDic = [ScoreUpType: [ScoreUpSchedule]]()
        scheduleDic[.Bonus] = [ScoreUpSchedule]()
        scheduleDic[.Combo] = [ScoreUpSchedule]()
        // for rankedSkill in team.skills {
        for i in 0...4 {
            let member = team[i]
            if let skill = member?.cardRef?.skill {
                let rankedSkill = CGSSRankedSkill.init(skill: skill, level: (member?.skillLevel)!)
                if var type = ScoreUpType.init(rawValue: rankedSkill.skill.skillType) {
                    if type == .Overload || type == .Perfect {
                        type = .Bonus
                    }
                    // 计算同属性歌曲 技能发动率的提升数值(groove活动中是同类型的groove类别)
                    var upValue = 0
                    if grooveType != nil {
                        if member!.cardRef!.cardType == CGSSCardTypes.init(grooveType: grooveType!) {
                            upValue = 30
                        }
                    } else {
                        if member!.cardRef!.cardType == live.songType || live.songType == .office {
                            upValue = 30
                        }
                    }
                    let tuples = rankedSkill.getRangesOfProc(live.getBeatmapByDiff(diff)!.postSeconds, procMax: procMax, upValue: upValue)
                    for tuple in tuples {
                        let schedule = ScoreUpSchedule.init(begin: tuple.0, end: tuple.1, upValue: rankedSkill.skill.value!)
                        scheduleDic[type]?.append(schedule)
                    }
                }
            }
        }
        return scheduleDic
    }
    
}

//
//  CGSSLiveCoordinator.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/8.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation


fileprivate let difficultyFactor: [Int: Double] = [
    5: 1.0,
    6: 1.025,
    7: 1.05,
    8: 1.075,
    9: 1.1,
    10: 1.2,
    11: 1.225,
    12: 1.25,
    13: 1.275,
    14: 1.3,
    15: 1.4,
    16: 1.425,
    17: 1.45,
    18: 1.475,
    19: 1.5,
    20: 1.6,
    21: 1.65,
    22: 1.7,
    23: 1.75,
    24: 1.8,
    25: 1.85,
    26: 1.9,
    27: 1.95,
    28: 2,
    29: 2.1,
    30: 2.2,
]

fileprivate let skillBoostValue = [1: 1200]

fileprivate let comboFactor: [Double] = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.7, 2.0]

fileprivate let criticalPercent: [Int] = [0, 5, 10, 25, 50, 70, 80, 90]


class LSCoordinator {
    var team: CGSSTeam
    var scene: CGSSLiveScene
    var simulatorType: CGSSLiveSimulatorType
    var grooveType: CGSSGrooveType?
    var fixedAppeal: Int?
    var appeal: Int {
        if grooveType != nil {
            return team.getAppealBy(simulatorType: simulatorType, liveType: CGSSLiveTypes.init(grooveType: grooveType!)).total + team.supportAppeal
        } else {
            return team.getAppealBy(simulatorType: simulatorType, liveType: scene.live.filterType).total + team.supportAppeal
        }
    }
    
    var life: Int {
        if grooveType != nil {
            return team.getAppealBy(simulatorType: simulatorType, liveType: CGSSLiveTypes.init(grooveType: grooveType!)).life
        } else {
            return team.getAppealBy(simulatorType: simulatorType, liveType: scene.live.filterType).life
        }
    }
    
    var beatmap: CGSSBeatmap {
        return self.scene.beatmap!
    }
    
    init(team: CGSSTeam, scene: CGSSLiveScene, simulatorType: CGSSLiveSimulatorType, grooveType: CGSSGrooveType?, fixedAppeal: Int?) {
        self.team = team
        self.scene = scene
        self.simulatorType = simulatorType
        self.grooveType = grooveType
        self.fixedAppeal = fixedAppeal
    }
    
    func getBaseScorePerNote() -> Double {
        let diffStars = scene.live.getStarsForDiff(scene.difficulty)
        if let fixedAppeal = fixedAppeal {
            return Double(fixedAppeal / beatmap.numberOfNotes) * (difficultyFactor[diffStars] ?? 1)
        } else {
            return Double(self.appeal) / Double(beatmap.numberOfNotes) * (difficultyFactor[diffStars] ?? 1)
        }
    }
    
    func getCriticalPointNoteIndexes(total: Int) -> [Int] {
        var arr = [Int]()
        for i in criticalPercent {
            arr.append(Int(floor(Float(total * i) / 100)))
        }
        return arr
    }
    
    func getComboFactor(of combo: Int, criticalPoints: [Int]) -> Double {
        var result: Double = 1
        for i in 0..<criticalPoints.count {
            if combo >= criticalPoints[i] {
                result = comboFactor[i]
            } else {
                break
            }
        }
        return result
    }
    
    private func generateLSNotes() -> [LSNote] {
        var lsNotes = [LSNote]()
        
        let baseScore = self.getBaseScorePerNote()
        
        let notes = beatmap.validNotes
        
        let criticalPoints = getCriticalPointNoteIndexes(total: beatmap.numberOfNotes)
        for i in 0..<notes.count {
            
            let comboFactor = getComboFactor(of: i + 1, criticalPoints: criticalPoints)
    
            let lsNote = LSNote(comboFactor: comboFactor, baseScore: baseScore, sec: notes[i].sec)
            
            lsNotes.append(lsNote)
        }
        return lsNotes
    }
    
    fileprivate func generateBonusesAndSupports() -> (bonuses: [LSSkill], supports: [LSSkill]) {
        var bonuses = [LSSkill]()
        var supports = [LSSkill]()
        let leaderSkillUpContent = team.getLeaderSkillUpContentBy(simulatorType: simulatorType)
        
        for i in 0...4 {
            if let member = team[i], let skill = team[i]?.cardRef?.skill {
                let rankedSkill = CGSSRankedSkill.init(skill: skill, level: (member.skillLevel)!)
                if let type = LSSkillType.init(type: skill.skillFilterType),
                    let cardType = member.cardRef?.cardType {
                    // 计算同属性歌曲 技能发动率的提升数值(groove活动中是同类型的groove类别)
                    var rateBonus = 0
                    if grooveType != nil {
                        if member.cardRef!.cardType == CGSSCardTypes.init(grooveType: grooveType!) {
                            rateBonus += 30
                        }
                    } else {
                        if member.cardRef!.cardType == scene.live.filterType || scene.live.filterType == .allType {
                            rateBonus += 30
                        }
                    }
                    // 计算触发几率提升类队长技
                    if let leaderSkillBonus = leaderSkillUpContent[cardType]?[.proc] {
                        rateBonus += leaderSkillBonus
                    }
                    
                    // 生成所有可触发范围
                    let ranges = rankedSkill.getUpRanges(lastNoteSec: beatmap.secondOfLastNote)
                    for range in ranges {
                        switch type {
                        case .skillBoost:
                            let bonus = LSSkill.init(range: range, value: skillBoostValue[skill.value] ?? 1000, value2: skill.value2, type: .skillBoost, rate: rankedSkill.procChance, rateBonus: rateBonus, triggerLife: skill.skillTriggerValue)
                            bonuses.append(bonus)
                            supports.append(bonus)
                        case .deep:
                            if team.isAllOfType(cardType, isInGrooveOrParade: (simulatorType != .normal)) {
                                fallthrough
                            } else {
                                break
                            }
                        default:
                            let bonus = LSSkill.init(range: range, value: skill.value, value2: skill.value2, type: type, rate: rankedSkill.procChance, rateBonus: rateBonus, triggerLife: skill.skillTriggerValue)
                            if bonus.type.isScoreBonus {
                                bonuses.append(bonus)
                            }
                            if bonus.type.isSupport {
                                supports.append(bonus)
                            }
                        }
                    }
                }
            }
        }
        return (bonuses, supports)
    }
    
    func generateLiveSimulator() -> CGSSLiveSimulator {
        let (bonuses, supports) = generateBonusesAndSupports()
        let notes = generateLSNotes()
        let simulator = CGSSLiveSimulator(notes: notes, bonuses: bonuses, supports: supports, totalLife: life)
        return simulator
    }
    
    func generateLiveFormulator() -> CGSSLiveFormulator {
        let (bonuses, _) = self.generateBonusesAndSupports()
        let notes = generateLSNotes()
        let formulator = CGSSLiveFormulator(notes: notes, bonuses: bonuses)
        return formulator
    }
}

fileprivate extension CGSSTeam {
    func isAllOfType(_ type: CGSSCardTypes, isInGrooveOrParade: Bool) -> Bool {
        let c = isInGrooveOrParade ? 5 : 6
        var result = true
        for i in 0..<c {
            let member = self[i]
            guard let cardType = member?.cardRef?.cardType, cardType == type else {
                result = false
                break
            }
        }
        return result
    }
}

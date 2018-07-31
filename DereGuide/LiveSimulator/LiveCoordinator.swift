//
//  LiveCoordinator.swift
//  DereGuide
//
//  Created by zzk on 16/8/8.
//  Copyright © 2016 zzk. All rights reserved.
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

fileprivate let lifeToComboBonus: [Int: Int] = [
    0: 108,
    10: 108,
    20: 108,
    30: 108,
    40: 108,
    50: 109,
    60: 109,
    70: 109,
    80: 109,
    90: 109,
    100: 110,
    110: 110,
    120: 110,
    130: 110,
    140: 110,
    150: 111,
    160: 111,
    170: 111,
    180: 111,
    190: 112,
    200: 112,
    210: 112,
    220: 112,
    230: 112,
    240: 113,
    250: 113,
    260: 113,
    270: 113,
    280: 113,
    290: 114,
    300: 114,
    310: 114,
    320: 114,
    330: 114,
    340: 115,
    350: 115,
    360: 115,
    370: 115,
    380: 116,
    390: 116,
    400: 116,
    410: 116,
    420: 116,
    430: 117,
    440: 117,
    450: 117,
    460: 117,
    470: 117,
    480: 118,
    490: 118,
    500: 118,
    510: 118,
    520: 118,
    530: 119,
    540: 119,
    550: 119,
    560: 119,
    570: 120,
    580: 120,
    590: 120,
    600: 120,
    610: 120,
    620: 121,
    630: 121,
    640: 121,
    650: 121,
    660: 121,
    670: 122,
    680: 122,
    690: 122,
    700: 122,
    710: 122,
    720: 123,
    730: 123,
    740: 123,
    750: 123,
    760: 124,
    770: 124,
    780: 124,
    790: 124,
    800: 124,
    810: 125,
    820: 125,
    830: 125,
    840: 125,
    850: 125,
    860: 126,
    870: 126,
    880: 126,
    890: 126,
    900: 126,
    910: 127,
    920: 127,
    930: 127,
    940: 127,
    950: 128,
    960: 128,
    970: 128,
    980: 128,
    990: 128,
    1000: 129,
    1010: 129,
    1020: 129,
    1030: 129,
    1040: 129,
    1050: 130,
    1060: 130,
    1070: 130,
    1080: 130,
    1090: 130,
    1100: 131,
    1110: 131,
    1120: 131,
    1130: 131,
    1140: 132,
    1150: 132,
    1160: 132,
    1170: 132,
    1180: 132,
    1190: 133,
    1200: 133,
    1210: 133,
    1220: 133,
    1230: 133,
    1240: 134,
    1250: 134,
    1260: 134,
    1270: 134,
    1280: 134,
    1290: 135,
    1300: 135,
    1310: 135,
    1320: 135,
    1330: 136,
    1340: 136,
    1350: 136,
    1360: 136,
    1370: 136,
    1380: 137,
    1390: 137,
    1400: 137,
    1410: 137,
    1420: 137,
    1430: 138,
    1440: 138,
    1450: 138,
    1460: 138,
    1470: 138,
    1480: 139,
    1490: 139,
    1500: 139,
    1510: 139,
    1520: 140,
    1530: 140,
    1540: 140,
    1550: 140,
    1560: 140,
    1570: 141,
    1580: 141,
    1590: 141,
    1600: 141
]

class LiveCoordinator {
    
    class func comboBonusValueOfLife(_ life: Int) -> Int {
        let key = life / 10 * 10
        return lifeToComboBonus[key] ?? 108
    }
    
    var unit: Unit
    var scene: CGSSLiveScene
    var simulatorType: CGSSLiveSimulatorType
    var grooveType: CGSSGrooveType?
    var fixedAppeal: Int?
    var appeal: Int {
        if grooveType != nil {
            return unit.getAppealBy(simulatorType: simulatorType, liveType: CGSSLiveTypes.init(grooveType: grooveType!)).total + Int(unit.supportAppeal)
        } else {
            return unit.getAppealBy(simulatorType: simulatorType, liveType: scene.live.filterType).total + Int(unit.supportAppeal)
        }
    }
    
    var life: Int {
        if grooveType != nil {
            return unit.getAppealBy(simulatorType: simulatorType, liveType: CGSSLiveTypes.init(grooveType: grooveType!)).life
        } else {
            return unit.getAppealBy(simulatorType: simulatorType, liveType: scene.live.filterType).life
        }
    }
    
    var beatmap: CGSSBeatmap {
        return self.scene.beatmap!
    }
    
    init(unit: Unit, scene: CGSSLiveScene, simulatorType: CGSSLiveSimulatorType, grooveType: CGSSGrooveType?) {
        self.unit = unit
        self.scene = scene
        self.simulatorType = simulatorType
        self.grooveType = grooveType
        self.fixedAppeal = unit.usesCustomAppeal ? Int(unit.customAppeal) : nil
    }
    
    var baseScorePerNote: Double {
        return Double(fixedAppeal ?? appeal) / Double(beatmap.numberOfNotes) * (difficultyFactor[scene.stars] ?? 1)
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
        
        let baseScore = baseScorePerNote
        
        beatmap.contextFree()
        
        let notes = beatmap.validNotes
        
        let criticalPoints = getCriticalPointNoteIndexes(total: beatmap.numberOfNotes)
        for i in 0..<notes.count {
            
            let comboFactor = getComboFactor(of: i + 1, criticalPoints: criticalPoints)
    
            let lsNote = LSNote(comboFactor: comboFactor, baseScore: baseScore, sec: notes[i].sec, rangeType: notes[i].rangeType, beatmapNote: notes[i])
            
            lsNotes.append(lsNote)
        }
        return lsNotes
    }
    
    fileprivate func generateBonuses() -> [LSSkill] {
        var bonuses = [LSSkill]()
        let leaderSkillUpContent = unit.getLeaderSkillUpContentBy(simulatorType: simulatorType)
        
        for i in 0...4 {
            let member = unit[i]
            let level = Int(member.skillLevel)
            guard let card = member.card else {
                continue
            }
            if let skill = card.skill {
                let rankedSkill = CGSSRankedSkill(level: level, skill: skill)
                if let type = LSSkillType(type: skill.skillFilterType) {
                    let cardType = card.cardType
                    // 计算同属性歌曲 技能发动率的提升数值(groove活动中是同类型的groove类别)
                    var rateBonus = 0
                    if grooveType != nil {
                        if member.card!.cardType == CGSSCardTypes(grooveType: grooveType!) {
                            rateBonus += 30
                        }
                    } else {
                        if member.card!.cardType == scene.live.filterType || scene.live.filterType == .allType {
                            rateBonus += 30
                        }
                    }
                    // 计算触发几率提升类队长技
                    if let leaderSkillBonus = leaderSkillUpContent[cardType]?[.proc] {
                        rateBonus += leaderSkillBonus
                    }
                    
                    // 计算触发几率潜能
                    let sp = member.potential.skill
                    let ratePotentialBonus = skillPotentialOfLevel[card.rarityType.baseRarity]?[sp] ?? 0
                    
                    // 生成所有可触发范围
                    let ranges = rankedSkill.getUpRanges(lastNoteSec: beatmap.timeOfLastNote)
                    for range in ranges {
                        switch type {
                        case .skillBoost:
                            let bonus = LSSkill(range: range, value: skillBoostValue[skill.value] ?? 1000, value2: skill.value2, value3: skill.value3, type: .skillBoost, rate: rankedSkill.chance, rateBonus: rateBonus, ratePotentialBonus: ratePotentialBonus, triggerLife: skill.skillTriggerValue, position: i, triggerEvaluations1: skill.triggerEvaluations1, triggerEvaluations2: skill.triggerEvaluations2, triggerEvaluations3: skill.triggerEvalutions3)
                            bonuses.append(bonus)
                        case .synergy:
                            if unit.isThreeColor(isInGrooveOrParade: (simulatorType != .normal)) {
                                let bonus = LSSkill(range: range, value: skill.value, value2: skill.value2, value3: skill.value3, type: type, rate: rankedSkill.chance, rateBonus: rateBonus, ratePotentialBonus: ratePotentialBonus, triggerLife: skill.skillTriggerValue, position: i, triggerEvaluations1: skill.triggerEvaluations1, triggerEvaluations2: skill.triggerEvaluations2, triggerEvaluations3: skill.triggerEvalutions3)
                                bonuses.append(bonus)
                            }
                        case .deep:
                            if unit.isAllOfType(cardType, isInGrooveOrParade: (simulatorType != .normal)) {
                                let bonus = LSSkill(range: range, value: skill.value, value2: skill.value2, value3: skill.value3, type: type, rate: rankedSkill.chance, rateBonus: rateBonus, ratePotentialBonus: ratePotentialBonus, triggerLife: skill.skillTriggerValue, position: i, triggerEvaluations1: skill.triggerEvaluations1, triggerEvaluations2: skill.triggerEvaluations2, triggerEvaluations3: skill.triggerEvalutions3)
                                bonuses.append(bonus)
                            }
                        default:
                            let bonus = LSSkill(range: range, value: skill.value, value2: skill.value2, value3: skill.value3, type: type, rate: rankedSkill.chance, rateBonus: rateBonus, ratePotentialBonus: ratePotentialBonus, triggerLife: skill.skillTriggerValue, position: i, triggerEvaluations1: skill.triggerEvaluations1, triggerEvaluations2: skill.triggerEvaluations2, triggerEvaluations3: skill.triggerEvalutions3)
                            bonuses.append(bonus)
                        }
                    }
                }
            }
        }
        return bonuses
    }
    
    func generateLiveSimulator() -> LiveSimulator {
        let bonuses = generateBonuses()
        let notes = generateLSNotes()
        let simulator = LiveSimulator(notes: notes, bonuses: bonuses, totalLife: life, difficulty: scene.difficulty)
        return simulator
    }
    
    func generateLiveFormulator() -> LiveFormulator {
        let bonuses = generateBonuses()
        let notes = generateLSNotes()
        let formulator = LiveFormulator(notes: notes, bonuses: bonuses)
        return formulator
    }
}

extension Unit {
    func isAllOfType(_ type: CGSSCardTypes, isInGrooveOrParade: Bool) -> Bool {
        let c = isInGrooveOrParade ? 5 : 6
        var result = true
        for i in 0..<c {
            let member = self[i]
            guard let cardType = member.card?.cardType, cardType == type else {
                result = false
                break
            }
        }
        return result
    }
    
    func isThreeColor(isInGrooveOrParade: Bool) -> Bool {
        return hasType(.cute, count: 1, isInGrooveOrParade: isInGrooveOrParade) && hasType(.cool, count: 1, isInGrooveOrParade: isInGrooveOrParade) && hasType(.passion, count: 1, isInGrooveOrParade: isInGrooveOrParade)
    }
}

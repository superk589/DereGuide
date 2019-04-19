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
    31: 2.3
]

fileprivate let skillBoostValue = [1: 1200]

fileprivate let comboFactor: [Double] = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.7, 2.0]

fileprivate let criticalPercent: [Int] = [0, 5, 10, 25, 50, 70, 80, 90]

fileprivate let lifeToComboBonus: [CGSSRarityTypes: [Int: Int]] = [
    .ssr: [0:109,10:109,20:109,30:109,40:109,50:110,60:110,70:110,80:110,90:110,100:110,110:111,120:111,130:111,140:111,150:111,160:112,170:112,180:112,190:112,200:113,210:113,220:113,230:113,240:113,250:114,260:114,270:114,280:114,290:114,300:115,310:115,320:115,330:116,340:116,350:116,360:116,370:116,380:117,390:117,400:117,410:118,420:118,430:118,440:119,450:119,460:119,470:119,480:120,490:120,500:121,510:121,520:121,530:121,540:122,550:122,560:122,570:122,580:123,590:123,600:123,610:124,620:124,630:124,640:124,650:124,660:124,670:124,680:124,690:124,700:124,710:124,720:124,730:124,740:124,750:124,760:124,770:124,780:124,790:124,800:124,810:125,820:125,830:125,840:125,850:125,860:126,870:126,880:126,890:126,900:126,910:127,920:127,930:127,940:127,950:128,960:128,970:128,980:128,990:128,1000:129,1010:129,1020:129,1030:129,1040:129,1050:130,1060:130,1070:130,1080:130,1090:130,1100:131,1110:131,1120:131,1130:131,1140:132,1150:132,1160:132,1170:132,1180:132,1190:133,1200:133,1210:133,1220:133,1230:133,1240:134,1250:134,1260:134,1270:134,1280:134,1290:135,1300:135,1310:135,1320:135,1330:136,1340:136,1350:136,1360:136,1370:136,1380:137,1390:137,1400:137,1410:137,1420:137,1430:138,1440:138,1450:138,1460:138,1470:138,1480:139,1490:139,1500:139,1510:139,1520:140,1530:140,1540:140,1550:140,1560:140,1570:141,1580:141,1590:141,1600:141],
    .sr:
        [0:107,10:107,20:107,30:107,40:107,50:107,60:108,70:108,80:108,90:108,100:108,110:109,120:109,130:109,140:109,150:109,160:110,170:110,180:110,190:110,200:110,210:111,220:111,230:111,240:111,250:111,260:112,270:112,280:112,290:112,300:112,310:112,320:113,330:114,340:114,350:113,360:113,370:114,380:115,390:114,400:114,410:115,420:116,430:116,440:116,450:116,460:116,470:117,480:118,490:117,500:118,510:118,520:119,530:119,540:119,550:119,560:119,570:120,580:120,590:120,600:120,610:121,620:121,630:121,640:121,650:121,660:121,670:121,680:121,690:121,700:121,710:121,720:121,730:121,740:121,750:121,760:121,770:120,780:121,790:121,800:121,810:121,820:121,830:122,840:122,850:122,860:122,870:122,880:122,890:123,900:123,910:123,920:123,930:123,940:124,950:124,960:124,970:124,980:124,990:125,1000:125,1010:125,1020:125,1030:125,1040:126,1050:126,1060:126,1070:126,1080:126,1090:127,1100:127,1110:127,1120:127,1130:127,1140:128,1150:128,1160:128,1170:128,1180:128,1190:128,1200:129,1210:129,1220:129,1230:129,1240:129,1250:130,1260:130,1270:130,1280:130,1290:130,1300:131,1310:131,1320:131,1330:131,1340:131,1350:132,1360:132,1370:132,1380:132,1390:132,1400:133,1410:133,1420:133,1430:133,1440:133,1450:133,1460:134,1470:134,1480:134,1490:134,1500:134,1510:135,1520:135,1530:135,1540:135,1550:135,1560:136,1570:136,1580:136,1590:136,1600:136]

]

fileprivate let maxLifeToComboBonusKey = 1600

class LiveCoordinator {
    
    class func comboBonusValueOfLife(_ life: Int, baseRarity: CGSSRarityTypes) -> Int {
        let key = life / 10 * 10
        let bonues = lifeToComboBonus[baseRarity]?[key] ?? lifeToComboBonus[baseRarity]?[maxLifeToComboBonusKey] ?? 100
        return bonues
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
        var result = 1.0
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
    
            let lsNote = LSNote(comboFactor: comboFactor, baseScore: baseScore, sec: notes[i].sec, rangeType: notes[i].rangeType, noteType: notes[i].noteType, beatmapNote: notes[i])
            
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
                            let bonus = LSSkill(range: range, value: skillBoostValue[skill.value] ?? 1000, value2: skill.value2, value3: skill.value3, type: .skillBoost, rate: rankedSkill.chance, rateBonus: rateBonus, ratePotentialBonus: ratePotentialBonus, triggerLife: skill.skillTriggerValue, position: i, triggerEvaluations1: skill.triggerEvaluations1, triggerEvaluations2: skill.triggerEvaluations2, triggerEvaluations3: skill.triggerEvalutions3, baseRarity: card.rarityType.baseRarity)
                            bonuses.append(bonus)
                        case .synergy:
                            if unit.isThreeColor(isInGrooveOrParade: (simulatorType != .normal)) {
                                let bonus = LSSkill(range: range, value: skill.value, value2: skill.value2, value3: skill.value3, type: type, rate: rankedSkill.chance, rateBonus: rateBonus, ratePotentialBonus: ratePotentialBonus, triggerLife: skill.skillTriggerValue, position: i, triggerEvaluations1: skill.triggerEvaluations1, triggerEvaluations2: skill.triggerEvaluations2, triggerEvaluations3: skill.triggerEvalutions3, baseRarity: card.rarityType.baseRarity)
                                bonuses.append(bonus)
                            }
                        case .deep:
                            if unit.isAllOfType(cardType, isInGrooveOrParade: (simulatorType != .normal)) {
                                let bonus = LSSkill(range: range, value: skill.value, value2: skill.value2, value3: skill.value3, type: type, rate: rankedSkill.chance, rateBonus: rateBonus, ratePotentialBonus: ratePotentialBonus, triggerLife: skill.skillTriggerValue, position: i, triggerEvaluations1: skill.triggerEvaluations1, triggerEvaluations2: skill.triggerEvaluations2, triggerEvaluations3: skill.triggerEvalutions3, baseRarity: card.rarityType.baseRarity)
                                bonuses.append(bonus)
                            }
                        default:
                            let bonus = LSSkill(range: range, value: skill.value, value2: skill.value2, value3: skill.value3, type: type, rate: rankedSkill.chance, rateBonus: rateBonus, ratePotentialBonus: ratePotentialBonus, triggerLife: skill.skillTriggerValue, position: i, triggerEvaluations1: skill.triggerEvaluations1, triggerEvaluations2: skill.triggerEvaluations2, triggerEvaluations3: skill.triggerEvalutions3, baseRarity: card.rarityType.baseRarity)
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

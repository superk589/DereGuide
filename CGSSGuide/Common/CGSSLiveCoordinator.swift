//
//  CGSSLiveCoordinator.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/8.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

struct Variable {
    var rate: Float {
        return rawRate / 100
    }
    
    // rate plus 100
    var rawRate: Float
    var upValue: Int
}


struct Distribution {
    var defaultValue: Int
    
    var variables: [Variable]
    
    var average: Float {
        var result: Float = Float(defaultValue)
        for variable in variables {
            result += variable.rate * Float(variable.upValue - defaultValue)
        }
        return result
    }
    
    var variance: Float {
        var result: Float = Float(defaultValue)
        let avg = average
        for variable in variables {
            result += variable.rate * (Float(variable.upValue) - avg) * (Float(variable.upValue) - avg)
        }
        return result
    }
    
    var max: Float {
        if let v = variables.first {
            return Float(v.upValue)
        } else {
            return Float(defaultValue)
        }
    }

    init(type: ScoreUpTypes, contents: [ScoreUpContent], defaultValue: Int = 100) {
        self.defaultValue = defaultValue
        var subContents = contents.filter { (c) -> Bool in
            return c.upType == type
        }
        
        subContents.sort { (c1, c2) -> Bool in
            c1.upValue > c2.upValue
        }
        self.variables = [Variable]()
        var leftRate: Float = 100
        for i in 0..<subContents.count {
            let c = subContents[i]
            let v = Variable.init(rawRate: leftRate * c.rawRate * Float(100 + c.rateBonus) / 10000, upValue: c.upValue)
            variables.append(v)
            leftRate -= v.rawRate
        }
    }
    
    func addSkillBoostDistribution(_ skillBoost: Distribution) {
        
    }
    
}


struct ScoreDistribution {
    var comboBonus: Distribution
    var perfectBonus: Distribution
    var skillBoostBonus: Distribution
    var comboFactor: Float
    var baseScore: Float
    
    var average: Int {
        return Int(round(baseScore * comboFactor * comboBonus.average * perfectBonus.average / 10000))
    }

    var max: Int {
        return Int(round(baseScore * comboFactor * comboBonus.max * perfectBonus.max / 10000))
    }
}


fileprivate let difficultyFactor: [Int: Float] = [
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

fileprivate let comboFactor: [Float] = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.7, 2.0]

fileprivate let criticalPercent: [Int] = [0, 5, 10, 25, 50, 70, 80, 90]

struct ScoreUpTypes: OptionSet, Hashable {
    let rawValue:UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let comboBonus = ScoreUpTypes.init(rawValue: 1 << 0)
    static let perfectBonus = ScoreUpTypes.init(rawValue: 1 << 1)
    static let skillBoost = ScoreUpTypes.init(rawValue: 1 << 2)
    static let deep: ScoreUpTypes = [.comboBonus, .perfectBonus]
    
    init?(type: CGSSSkillTypes) {
        switch type {
        case CGSSSkillTypes.comboBonus, CGSSSkillTypes.allRound:
            self = .comboBonus
        case CGSSSkillTypes.perfectBonus, CGSSSkillTypes.overload:
            self = .perfectBonus
        case CGSSSkillTypes.deepCool, CGSSSkillTypes.deepCute, CGSSSkillTypes.deepPassion:
            self = [.perfectBonus, .comboBonus]
        case CGSSSkillTypes.boost:
            self = .skillBoost
        default:
            return nil
        }
    }
    
    var hashValue: Int {
        return Int(self.rawValue)
    }
}

struct ScoreUpContent {
    
    var range: ScoreUpRange
    
    // In percent, 117 means 17%up
    var upValue: Int
    
    var upType: ScoreUpTypes
    
    // rate plus 100
    var rawRate: Float
    
    // In percent, 30 means 0.3
    var rateBonus: Int
    
    var rate: Float {
        return rawRate * Float(100 + rateBonus) / 10000
    }
}

struct ScoreUpRange {
    var begin: Float
    var length: Float
    var end: Float {
        return begin + length
    }
}

struct CGSSLiveCoordinatorOptions: OptionSet {
    let rawValue:UInt
    init(rawValue: UInt) { self.rawValue = rawValue }
    static let perfectTolerence = CGSSLiveCoordinatorOptions.init(rawValue: 1 << 0)
}

class CGSSLiveCoordinator {
    var team: CGSSTeam
    var live: CGSSLive
    var diff: Int
    var liveType: CGSSLiveType
    var grooveType: CGSSGrooveType?
    var fixedAppeal: Int?
    var appeal: Int {
        if grooveType != nil {
            return team.getAppealByType(liveType, songType: CGSSCardTypes.init(grooveType: grooveType!)).total + team.supportAppeal
        } else {
            return team.getAppealByType(liveType, songType: live.songType).total + team.supportAppeal
        }
    }
    
    lazy var beatmap: CGSSBeatmap = {
        return self.live.getBeatmapByDiff(self.diff)!
    }()
    
    init(team: CGSSTeam, live: CGSSLive, liveType: CGSSLiveType, grooveType: CGSSGrooveType?, diff: Int, fixedAppeal: Int?) {
        self.team = team
        self.live = live
        self.diff = diff
        self.liveType = liveType
        self.grooveType = grooveType
        self.fixedAppeal = fixedAppeal
    }
    
    
    func getBaseScorePerNote() -> Float {
        let diffStars = self.live.getStarsForDiff(diff)
        if let fixedAppeal = fixedAppeal {
            return Float(fixedAppeal / beatmap.numberOfNotes) * (difficultyFactor[diffStars] ?? 1)
        } else {
            return Float(self.appeal) / Float(beatmap.numberOfNotes) * (difficultyFactor[diffStars] ?? 1)
        }
    }
    
    func getCriticalPointNoteIndexes(total: Int) -> [Int] {
        var arr = [Int]()
        for i in criticalPercent {
            arr.append(Int(floor(Float(total * i) / 100)))
        }
        return arr
    }
    
    func getComboFactor(of combo: Int, criticalPoints: [Int]) -> Float {
        var result: Float = 1
        for i in 0..<criticalPoints.count {
            if combo >= criticalPoints[i] {
                result = comboFactor[i]
            } else {
                break
            }
        }
        return result
    }
    
    fileprivate func generateScoreDistributions(notes: [CGSSBeatmapNote], contents: [ScoreUpContent], options: CGSSLiveCoordinatorOptions) -> [ScoreDistribution] {
        var scoreDistributions = [ScoreDistribution]()
        let baseScore = self.getBaseScorePerNote()
        let criticalPoints = getCriticalPointNoteIndexes(total: notes.count)
        for i in 0..<notes.count {
            let note = notes[i]
            let comboFactor = getComboFactor(of: i + 1, criticalPoints: criticalPoints)
            
            var validContents = [ScoreUpContent]()
            for content in contents {
                if options.contains(.perfectTolerence) {
                    if note.sec >= content.range.begin - 0.06 && note.sec <= content.range.end + 0.06 {
                        validContents.append(content)
                    }
                } else {
                    if note.sec >= content.range.begin && note.sec <= content.range.end {
                        validContents.append(content)
                    }
                }
            }
           
            let comboBonus = Distribution.init(type: .comboBonus, contents: validContents)
            let perfectBonus = Distribution.init(type: .perfectBonus, contents: validContents)
            let skillBoostBonus = Distribution.init(type: .skillBoost, contents: validContents)
            
            let scoreDistribution = ScoreDistribution.init(comboBonus: comboBonus, perfectBonus: perfectBonus, skillBoostBonus: skillBoostBonus, comboFactor: comboFactor, baseScore: baseScore)
            scoreDistributions.append(scoreDistribution)
        }
        return scoreDistributions
    }
    
    fileprivate func generateScoreUpContents() -> [ScoreUpContent] {
        var result = [ScoreUpContent]()
        for i in 0...4 {
            if let member = team[i], let skill = team[i]?.cardRef?.skill {
                let rankedSkill = CGSSRankedSkill.init(skill: skill, level: (member.skillLevel)!)
                if let type = ScoreUpTypes.init(type: skill.skillFilterType) {
                    // 计算同属性歌曲 技能发动率的提升数值(groove活动中是同类型的groove类别)
                    var rateBonus = 0
                    if grooveType != nil {
                        if member.cardRef!.cardType == CGSSCardTypes.init(grooveType: grooveType!) {
                            rateBonus = 30
                        }
                    } else {
                        if member.cardRef!.cardType == live.songType || live.songType == .office {
                            rateBonus = 30
                        }
                    }
                    let ranges = rankedSkill.getUpRanges(lastNoteSec: beatmap.secondOfLastNote)
                    for range in ranges {
                        if type == .deep {
                            let content1 = ScoreUpContent.init(range: range, upValue: skill.value, upType: .perfectBonus, rawRate: rankedSkill.procChance, rateBonus: rateBonus)
                            let content2 = ScoreUpContent.init(range: range, upValue: skill.value2, upType: .comboBonus, rawRate: rankedSkill.procChance, rateBonus: rateBonus)
                            result.append(content1)
                            result.append(content2)
                        } else {
                            let content = ScoreUpContent.init(range: range, upValue: skill.value, upType: type, rawRate: rankedSkill.procChance, rateBonus: rateBonus)
                            result.append(content)
                        }
                    }
                }
            }
        }
        return result
    }
    
    func generateLiveSimulator(options: CGSSLiveCoordinatorOptions) -> CGSSLiveSimulator {
        let contents = self.generateScoreUpContents()
        let scoreDistributions = self.generateScoreDistributions(notes: self.beatmap.validNotes, contents: contents, options: options)
        return CGSSLiveSimulator.init(distributions: scoreDistributions, contents: contents, notes: self.beatmap.validNotes)
    }
}

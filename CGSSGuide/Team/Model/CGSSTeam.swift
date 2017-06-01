//
//  CGSSTeam.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

enum LeaderSkillUpType {
    case vocal
    case dance
    case visual
    case life
    case proc
    
    init?(simulatorType: CGSSLiveSimulatorType) {
        switch simulatorType {
        case .dance:
            self = .dance
        case .visual:
            self = .visual
        case .vocal:
            self = .vocal
        default:
            return nil
        }
    }
}

struct LeaderSkillUpContent {
    var upType: LeaderSkillUpType
    var upTarget: CGSSCardTypes
    var upValue: Int
}

class CGSSTeam: NSObject, NSCoding {
    var leader: CGSSTeamMember!
    var subs: [CGSSTeamMember]!
    var friendLeader: CGSSTeamMember!
    var customAppeal: Int
    var supportAppeal: Int
    var usingCustomAppeal: Bool
    
    init(leader: CGSSTeamMember, subs: [CGSSTeamMember], friendLeader: CGSSTeamMember?, supportAppeal: Int = CGSSGlobal.defaultSupportAppeal, customAppeal: Int = 0, usingCustomAppeal: Bool = false) {
        self.leader = leader
        self.subs = subs
        self.supportAppeal = supportAppeal
        self.friendLeader = friendLeader ?? leader
        self.usingCustomAppeal = usingCustomAppeal
        self.customAppeal = customAppeal
    }
    
    var testLive: CGSSLive? {
        var result: CGSSLive?
        let semaphore = DispatchSemaphore.init(value: 0)
        if let id = testLiveId {
            CGSSGameResource.shared.master.getLives(liveId: id, callback: { (lives) in
                result = lives.first
                semaphore.signal()
            })
        } else {
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
    var testLiveId: Int?
    var testDifficulty: CGSSLiveDifficulty?
    var skills: [CGSSRankedSkill] {
        var arr = [CGSSRankedSkill]()
        for i in 0...4 {
            if let skill = self[i]?.cardRef?.skill, let level = self[i]?.skillLevel {
                let rankedSkill = CGSSRankedSkill(level: level, skill: skill)
                arr.append(rankedSkill)
            }
        }
        return arr
    }
    subscript (index: Int) -> CGSSTeamMember? {
        if index == 0 {
            return leader
        } else if index < 5 {
            return subs[index - 1]
        } else {
            return friendLeader
        }
    }
    
    func hasUnknownSkills() -> Bool {
        for i in 0...5 {
            if let type = self[i]?.cardRef?.skillType, type == .unknown {
                return true
            }
        }
        return false
    }

    
    // 队伍原始值
    var rawAppeal: CGSSAppeal {
        var appeal = rawAppealInGroove
        if let member = self[5], let card = member.cardRef {
            appeal += card.appeal.addBy(potential: member.potential, rarity: card.rarityType)
        }
        return appeal
    }
    var rawAppealInGroove: CGSSAppeal {
        var appeal = CGSSAppeal.zero
        for i in 0...4 {
            if let member = self[i], let card = member.cardRef {
                appeal += card.appeal.addBy(potential: member.potential, rarity: card.rarityType)
            }
        }
        return appeal
    }
    
    private func getAppeal(_ type: CGSSCardTypes) -> CGSSAppeal {
        var appeal = CGSSAppeal.zero
        let contents = getUpContent()
        for i in 0...5 {
            appeal += self[i]!.cardRef!.getAppealBy(liveType: type, contents: contents, potential: self[i]?.potential ?? CGSSPotential.zero)
        }
        return appeal
    }
    
    private func getAppealInGroove(_ type: CGSSCardTypes, burstType: LeaderSkillUpType) -> CGSSAppeal {
        var appeal = CGSSAppeal.zero
        let contents = getUpContentInGroove(by: burstType)
        for i in 0...4 {
            appeal += self[i]!.cardRef!.getAppealBy(liveType: type, contents: contents, potential: self[i]?.potential ?? CGSSPotential.zero)
        }
        return appeal
    }
    
    private func getAppealInParade(_ type: CGSSLiveTypes) -> CGSSAppeal {
        var appeal = CGSSAppeal.zero
        let contents = getUpContentInParade()
        for i in 0...4 {
            appeal += self[i]!.cardRef!.getAppealBy(liveType: type, contents: contents, potential: self[i]?.potential ?? CGSSPotential.zero)
        }
        return appeal
    }
    
    func getAppealBy(simulatorType: CGSSLiveSimulatorType, liveType: CGSSLiveTypes) -> CGSSAppeal {
        switch simulatorType {
        case .normal:
            return getAppeal(liveType)
        case .visual, .dance, .vocal:
            return getAppealInGroove(liveType, burstType: LeaderSkillUpType.init(simulatorType: simulatorType)!)
        case .parade:
            return getAppealInParade(liveType)
        }
    }
    
    func getLeaderSkillUpContentBy(simulatorType: CGSSLiveSimulatorType) -> [CGSSCardTypes: [LeaderSkillUpType: Int]] {
        switch simulatorType {
        case .normal:
            return getUpContent()
        case .parade:
            return getUpContentInParade()
        case .vocal, .dance, .visual:
            return getUpContentInGroove(by: LeaderSkillUpType.init(simulatorType: simulatorType)!)
        }
    }
    
    // 判断需要的指定颜色的队员是否满足条件
    private func hasType(_ type: CGSSCardTypes, count: Int, isInGrooveOrParade: Bool) -> Bool {
        if count == 0 {
            return true
        }
        
        var c = 0
        for i in 0...(isInGrooveOrParade ? 4 : 5) {
            if self[i]?.cardRef?.cardType == type {
                c += 1
            }
        }
        
        // 对于deep系列的技能 当在groove或parade中 要求队员数量降低为5
        if count == 6 && isInGrooveOrParade {
            return c >= 5
        } else {
            return c >= count
        }
    }
    
    private func getContentFor(_ leaderSkill: CGSSLeaderSkill, isInGrooveOrParade: Bool) -> [LeaderSkillUpContent] {
        var contents = [LeaderSkillUpContent]()
        if hasType(.cute, count: leaderSkill.needCute, isInGrooveOrParade: isInGrooveOrParade) && hasType(.cool, count: leaderSkill.needCool, isInGrooveOrParade: isInGrooveOrParade) && hasType(.passion, count: leaderSkill.needPassion, isInGrooveOrParade: isInGrooveOrParade) {
            switch leaderSkill.targetAttribute! {
            case "cute":
                for upType in getUpType(leaderSkill) {
                    let content = LeaderSkillUpContent.init(upType: upType, upTarget: .cute, upValue: leaderSkill.upValue!)
                    contents.append(content)
                }
            case "cool":
                for upType in getUpType(leaderSkill) {
                    let content = LeaderSkillUpContent.init(upType: upType, upTarget: .cool, upValue: leaderSkill.upValue!)
                    contents.append(content)
                }
            case "passion":
                for upType in getUpType(leaderSkill) {
                    let content = LeaderSkillUpContent.init(upType: upType, upTarget: .passion, upValue: leaderSkill.upValue!)
                    contents.append(content)
                }
            case "all":
                for upType in getUpType(leaderSkill) {
                    let content1 = LeaderSkillUpContent.init(upType: upType, upTarget: .cute, upValue: leaderSkill.upValue!)
                    contents.append(content1)
                    let content2 = LeaderSkillUpContent.init(upType: upType, upTarget: .cool, upValue: leaderSkill.upValue!)
                    contents.append(content2)
                    let content3 = LeaderSkillUpContent.init(upType: upType, upTarget: .passion, upValue: leaderSkill.upValue!)
                    contents.append(content3)
                }
            default:
                break
            }
            
        }
        return contents
    }
    
    // 获取队长技能对队伍的加成效果
    private func getUpContent() -> [CGSSCardTypes: [LeaderSkillUpType: Int]] {
        var contents = [LeaderSkillUpContent]()
        // 自己的队长技能
        if let leaderSkill = leader.cardRef?.leaderSkill {
            contents.append(contentsOf: getContentFor(leaderSkill, isInGrooveOrParade: false))
        }
        // 队友的队长技能
        if let leaderSkill = friendLeader.cardRef?.leaderSkill {
            contents.append(contentsOf: getContentFor(leaderSkill, isInGrooveOrParade: false))
        }
        
        // 合并同类型
        var newContents = [CGSSCardTypes: [LeaderSkillUpType: Int]]()
        for content in contents {
            if newContents.keys.contains(content.upTarget) {
                if newContents[content.upTarget]!.keys.contains(content.upType) {
                    newContents[content.upTarget]![content.upType]! += content.upValue
                } else {
                    newContents[content.upTarget]![content.upType] = content.upValue
                }
            } else {
                newContents[content.upTarget] = [LeaderSkillUpType: Int]()
                newContents[content.upTarget]![content.upType] = content.upValue
            }
            
        }
        return newContents
    }
    
    private func getUpContentInGroove(by burstType: LeaderSkillUpType) -> [CGSSCardTypes: [LeaderSkillUpType: Int]] {
        var contents = [LeaderSkillUpContent]()
        // 自己的队长技能
        if let leaderSkill = leader.cardRef?.leaderSkill {
            contents.append(contentsOf: getContentFor(leaderSkill, isInGrooveOrParade: true))
        }
        // 设定Groove中的up值
        contents.append(LeaderSkillUpContent.init(upType: burstType, upTarget: .cool, upValue: 150))
        contents.append(LeaderSkillUpContent.init(upType: burstType, upTarget: .cute, upValue: 150))
        contents.append(LeaderSkillUpContent.init(upType: burstType, upTarget: .passion, upValue: 150))
        
        // 合并同类型
        var newContents = [CGSSCardTypes: [LeaderSkillUpType: Int]]()
        for content in contents {
            if newContents.keys.contains(content.upTarget) {
                if newContents[content.upTarget]!.keys.contains(content.upType) {
                    newContents[content.upTarget]![content.upType]! += content.upValue
                } else {
                    newContents[content.upTarget]![content.upType] = content.upValue
                }
            } else {
                newContents[content.upTarget] = [LeaderSkillUpType: Int]()
                newContents[content.upTarget]![content.upType] = content.upValue
            }
            
        }
        return newContents
    }
    
    private func getUpContentInParade() -> [CGSSCardTypes: [LeaderSkillUpType: Int]] {
        var contents = [LeaderSkillUpContent]()
        // 自己的队长技能
        if let leaderSkill = leader.cardRef?.leaderSkill {
            contents.append(contentsOf: getContentFor(leaderSkill, isInGrooveOrParade: true))
        }
        var newContents = [CGSSCardTypes: [LeaderSkillUpType: Int]]()
        for content in contents {
            if
                newContents.keys.contains(content.upTarget) {
                newContents[content.upTarget]![content.upType] = content.upValue
            } else {
                newContents[content.upTarget] = [LeaderSkillUpType: Int]()
                newContents[content.upTarget]![content.upType] = content.upValue
            }
        }
        return newContents
    }
    
    func getUpType(_ leaderSkill: CGSSLeaderSkill) -> [LeaderSkillUpType] {
        switch leaderSkill.targetParam! {
        case "vocal":
            return [LeaderSkillUpType.vocal]
        case "dance":
            return [LeaderSkillUpType.dance]
        case "visual":
            return [LeaderSkillUpType.visual]
        case "all":
            return [LeaderSkillUpType.vocal, LeaderSkillUpType.dance, LeaderSkillUpType.visual]
        case "life":
            return [LeaderSkillUpType.life]
        case "skill_probability":
            return [LeaderSkillUpType.proc]
        default:
            return [LeaderSkillUpType]()
        }
    }
    
    func validateCardRef() -> Bool {
        if leader.cardRef == nil {
            return false
        }
        if friendLeader.cardRef == nil {
            return false
        }
        for sub in subs {
            if sub.cardRef == nil {
                return false
            }
        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.leader = aDecoder.decodeObject(forKey: "leader") as? CGSSTeamMember
        self.subs = aDecoder.decodeObject(forKey: "subs") as? [CGSSTeamMember]
        self.supportAppeal = aDecoder.decodeInteger(forKey: "supportAppeal")
        self.friendLeader = aDecoder.decodeObject(forKey: "friendLeader") as? CGSSTeamMember
        self.testDifficulty = CGSSLiveDifficulty(rawValue: aDecoder.decodeObject(forKey: "testDifficulty") as? Int ?? 1)
        self.testLiveId = aDecoder.decodeObject(forKey: "testLiveId") as? Int
        self.customAppeal = aDecoder.decodeInteger(forKey: "customAppeal")
        self.usingCustomAppeal = aDecoder.decodeBool(forKey: "usingCustomAppeal")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(leader, forKey: "leader")
        aCoder.encode(subs, forKey: "subs")
        aCoder.encode(supportAppeal, forKey: "supportAppeal")
        aCoder.encode(friendLeader, forKey: "friendLeader")
        aCoder.encode(testLiveId, forKey: "testLiveId")
        aCoder.encode(testDifficulty?.rawValue, forKey: "testDifficulty")
        aCoder.encode(customAppeal, forKey: "customAppeal")
        aCoder.encode(usingCustomAppeal, forKey: "usingCustomAppeal")
    }
    
}

extension CGSSCard {
    // 扩展一个获取卡片在队伍中的表现值的方法
    func getAppealBy(liveType: CGSSCardTypes, roomUpValue: Int = UserDefaults.standard.roomUpValue, contents: [CGSSCardTypes: [LeaderSkillUpType: Int]], potential: CGSSPotential) -> CGSSAppeal {
        var appeal = self.appeal.addBy(potential: potential, rarity: self.rarityType)
        var factor = 100 + roomUpValue
        if liveType == cardType || liveType == .allType {
            factor += 30
        }
        appeal.vocal = Int(ceil(Float(appeal.vocal * (factor + (contents[cardType]?[.vocal] ?? 0))) / 100))
        appeal.dance = Int(ceil(Float(appeal.dance * (factor + (contents[cardType]?[.dance] ?? 0))) / 100))
        appeal.visual = Int(ceil(Float(appeal.visual * (factor + (contents[cardType]?[.visual] ?? 0))) / 100))
        appeal.life = Int(ceil(Float(appeal.life * (100 + (contents[cardType]?[.life] ?? 0))) / 100))
        return appeal
    }
}

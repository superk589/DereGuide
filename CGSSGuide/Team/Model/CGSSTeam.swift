//
//  CGSSTeam.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

enum LeaderSkillUpType {
    case Vocal
    case Dance
    case Visual
    case Life
    case Proc
}

struct LeaderSkillUpContent {
    var upType: LeaderSkillUpType
    var upTarget: CGSSCardFilterType
    var upValue: Int
}

class CGSSTeam: NSObject, NSCoding {
    var leader: CGSSTeamMember!
    var subs: [CGSSTeamMember]!
    var friendLeader: CGSSTeamMember!
    // 队伍总表现值
    var backSupportValue: Int!
    var testLive: CGSSLive? {
        if let id = testLiveId {
            return CGSSDAO.sharedDAO.findLiveById(id)
        }
        return nil
    }
    var testLiveId: Int?
    var testDiff: Int?
    var skills: [CGSSRankedSkill] {
        var arr = [CGSSRankedSkill]()
        for i in 0...4 {
            if let skill = self[i]?.cardRef?.skill {
                let rankedSkill = CGSSRankedSkill.init(skill: skill, level: (self[i]?.skillLevel)!)
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
    
    // 队伍原始值
    var rawPresentValue: CGSSAttributeValue {
        let attValue = CGSSAttributeValue.init(visual: rawVisual, vocal: rawVocal, dance: rawDance, life: rawHP)
        return attValue
    }
    var rawPresentValueInGroove: CGSSAttributeValue {
        let attValue = CGSSAttributeValue.init(visual: rawVisualInGroove, vocal: rawVocalInGroove, dance: rawDanceInGroove, life: rawHPInGroove)
        return attValue
    }
    var rawVocal: Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.vocal) ?? 0
        }
        return sum
    }
    var rawVocalInGroove: Int {
        var sum = 0
        for i in 0...4 {
            sum += (self[i]?.cardRef?.vocal) ?? 0
        }
        return sum
    }
    var rawDance: Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.dance) ?? 0
        }
        return sum
    }
    var rawDanceInGroove: Int {
        var sum = 0
        for i in 0...4 {
            sum += (self[i]?.cardRef?.dance) ?? 0
        }
        return sum
    }
    var rawVisual: Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.visual) ?? 0
        }
        return sum
    }
    var rawVisualInGroove: Int {
        var sum = 0
        for i in 0...4 {
            sum += (self[i]?.cardRef?.visual) ?? 0
        }
        return sum
    }
    var rawHP: Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.life) ?? 0
        }
        return sum
    }
    var rawHPInGroove: Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.life) ?? 0
        }
        return sum
    }
    
    func getPresentValue(type: CGSSCardFilterType) -> CGSSAttributeValue {
        var attValue = CGSSAttributeValue.init(visual: 0, vocal: 0, dance: 0, life: 0)
        for i in 0...5 {
            attValue += self[i]!.cardRef!.getPresentValue(type, roomUpScalar: 10, contents: getUpContent())
        }
        return attValue
    }
    
    func getPresentValueInGroove(type: CGSSCardFilterType, burstType: LeaderSkillUpType) -> CGSSAttributeValue {
        var attValue = CGSSAttributeValue.init(visual: 0, vocal: 0, dance: 0, life: 0)
        for i in 0...4 {
            attValue += self[i]!.cardRef!.getPresentValue(type, roomUpScalar: 10, contents: getUpContentInGroove(burstType))
        }
        return attValue
    }
    
    func getPresentValueByType(liveType: CGSSLiveType, songType: CGSSCardFilterType) -> CGSSAttributeValue {
        switch liveType {
        case .Normal:
            return getPresentValue(songType)
        case .VisualBurstGroove:
            return getPresentValueInGroove(songType, burstType: .Visual)
        case .DanceBurstGroove:
            return getPresentValueInGroove(songType, burstType: .Dance)
        case .VocalBurstGroove:
            return getPresentValueInGroove(songType, burstType: .Vocal)
        }
    }
    
    // 判断需要的指定颜色的队员是否满足条件
    func hasType(type: CGSSCardFilterType, count: Int?) -> Bool {
        if count == 0 {
            return true
        }
        var c = 0
        for i in 0...5 {
            if self[i]?.cardRef?.cardFilterType == type {
                c += 1
            }
        }
        if c >= count ?? 0 {
            return true
        } else {
            return false
        }
    }
    
    func getContentFor(leaderSkill: CGSSLeaderSkill) -> [LeaderSkillUpContent] {
        var contents = [LeaderSkillUpContent]()
        if hasType(.Cute, count: leaderSkill.needCute) && hasType(.Cool, count: leaderSkill.needCool) && hasType(.Passion, count: leaderSkill.needPassion) {
            switch leaderSkill.targetAttribute! {
            case "cute":
                for upType in getUpType(leaderSkill) {
                    let content = LeaderSkillUpContent.init(upType: upType, upTarget: .Cute, upValue: leaderSkill.upValue!)
                    contents.append(content)
                }
            case "cool":
                for upType in getUpType(leaderSkill) {
                    let content = LeaderSkillUpContent.init(upType: upType, upTarget: .Cool, upValue: leaderSkill.upValue!)
                    contents.append(content)
                }
            case "passion":
                for upType in getUpType(leaderSkill) {
                    let content = LeaderSkillUpContent.init(upType: upType, upTarget: .Passion, upValue: leaderSkill.upValue!)
                    contents.append(content)
                }
            case "all":
                for upType in getUpType(leaderSkill) {
                    let content1 = LeaderSkillUpContent.init(upType: upType, upTarget: .Cute, upValue: leaderSkill.upValue!)
                    contents.append(content1)
                    let content2 = LeaderSkillUpContent.init(upType: upType, upTarget: .Cool, upValue: leaderSkill.upValue!)
                    contents.append(content2)
                    let content3 = LeaderSkillUpContent.init(upType: upType, upTarget: .Passion, upValue: leaderSkill.upValue!)
                    contents.append(content3)
                }
            default:
                break
            }
            
        }
        return contents
    }
    
    // 获取队长技能对队伍的加成效果
    func getUpContent() -> [CGSSCardFilterType: [LeaderSkillUpType: Int]] {
        var contents = [LeaderSkillUpContent]()
        // 自己的队长技能
        if let leaderSkill = leader.cardRef?.leaderSkill {
            contents.appendContentsOf(getContentFor(leaderSkill))
        }
        // 队友的队长技能
        if let leaderSkill = friendLeader.cardRef?.leaderSkill {
            contents.appendContentsOf(getContentFor(leaderSkill))
        }
        
        // 合并同类型
        var newContents = [CGSSCardFilterType: [LeaderSkillUpType: Int]]()
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
    
    func getUpContentInGroove(burstType: LeaderSkillUpType) -> [CGSSCardFilterType: [LeaderSkillUpType: Int]] {
        var contents = [LeaderSkillUpContent]()
        // 自己的队长技能
        if let leaderSkill = leader.cardRef?.leaderSkill {
            contents.appendContentsOf(getContentFor(leaderSkill))
        }
        // 设定Groove中的up值
        contents.append(LeaderSkillUpContent.init(upType: burstType, upTarget: .Cool, upValue: 150))
        contents.append(LeaderSkillUpContent.init(upType: burstType, upTarget: .Cute, upValue: 150))
        contents.append(LeaderSkillUpContent.init(upType: burstType, upTarget: .Passion, upValue: 150))
        
        // 合并同类型
        var newContents = [CGSSCardFilterType: [LeaderSkillUpType: Int]]()
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
    
    func getUpType(leaderSkill: CGSSLeaderSkill) -> [LeaderSkillUpType] {
        switch leaderSkill.targetParam! {
        case "vocal":
            return [LeaderSkillUpType.Vocal]
        case "dance":
            return [LeaderSkillUpType.Dance]
        case "visual":
            return [LeaderSkillUpType.Visual]
        case "all":
            return [LeaderSkillUpType.Vocal, LeaderSkillUpType.Dance, LeaderSkillUpType.Visual]
        case "life":
            return [LeaderSkillUpType.Life]
        case "skill_probability":
            return [LeaderSkillUpType.Proc]
        default:
            return [LeaderSkillUpType]()
        }
    }
    
    init(leader: CGSSTeamMember, subs: [CGSSTeamMember], backSupportValue: Int, friendLeader: CGSSTeamMember?) {
        self.leader = leader
        self.subs = subs
        self.backSupportValue = backSupportValue
        self.friendLeader = friendLeader ?? leader
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.leader = aDecoder.decodeObjectForKey("leader") as? CGSSTeamMember
        self.subs = aDecoder.decodeObjectForKey("subs") as? [CGSSTeamMember]
        self.backSupportValue = aDecoder.decodeObjectForKey("backSupportValue") as? Int ?? 100000
        self.friendLeader = aDecoder.decodeObjectForKey("friendLeader") as? CGSSTeamMember
        self.testDiff = aDecoder.decodeObjectForKey("testDiff") as? Int
        self.testLiveId = aDecoder.decodeObjectForKey("testLiveId") as? Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(leader, forKey: "leader")
        aCoder.encodeObject(subs, forKey: "subs")
        aCoder.encodeObject(backSupportValue, forKey: "backSupportValue")
        aCoder.encodeObject(friendLeader, forKey: "friendLeader")
        aCoder.encodeObject(testLiveId, forKey: "testLiveId")
        aCoder.encodeObject(testDiff, forKey: "testDiff")
    }
    
}

extension CGSSCard {
    // 扩展一个获取卡片在队伍中的表现值的方法
    func getPresentValue(songType: CGSSCardFilterType, roomUpScalar: Int?, contents: [CGSSCardFilterType: [LeaderSkillUpType: Int]]) -> CGSSAttributeValue {
        var attValue = CGSSAttributeValue.init(visual: visual, vocal: vocal, dance: dance, life: life)
        var scalar = 100 + (roomUpScalar ?? 10)
        if songType == cardFilterType || songType == .Office {
            scalar += 30
        }
        
        attValue.vocal = Int(ceil(Float(attValue.vocal * (scalar + (contents[cardFilterType]?[.Vocal] ?? 0))) / 100))
        attValue.dance = Int(ceil(Float(attValue.dance * (scalar + (contents[cardFilterType]?[.Dance] ?? 0))) / 100))
        attValue.visual = Int(ceil(Float(attValue.visual * (scalar + (contents[cardFilterType]?[.Visual] ?? 0))) / 100))
        attValue.life = Int(ceil(Float(attValue.visual * (100 + (contents[cardFilterType]?[.Life] ?? 0))) / 100))
        return attValue
    }
}

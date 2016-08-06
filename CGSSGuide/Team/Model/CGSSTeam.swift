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
    var upType:LeaderSkillUpType
    var upTarget:CGSSCardFilterType
    var upValue:Int
}

class CGSSTeam: NSObject, NSCoding {
    var leader: CGSSTeamMember!
    var subs: [CGSSTeamMember]!
    var friendLeader: CGSSTeamMember!
    //队伍总表现值
    var teamPresentValue:Int? {
        return 0
    }
    var teamVocal:Int? {
        return 0
    }
    var teamDance:Int? {
        return 0
    }
    var teamVisual:Int? {
        return 0
    }
    var teamBackSupportValue:Int?
    var testLive: CGSSLive? {
        if let id = testLiveId {
            return CGSSDAO.sharedDAO.findLiveById(id)
        }
        return nil
    }
    var testLiveId: Int?
    var testDiff: Int?
    
    subscript (index:Int) -> CGSSTeamMember? {
        if index == 0 {
            return leader
        } else if index < 5 {
            return subs[index - 1]
        } else {
            return friendLeader
        }
    }
    
    //队伍原始值
    var rawPresentValue:CGSSAttributeValue {
        let attValue = CGSSAttributeValue.init(visual: rawVisual, vocal: rawVocal, dance: rawDance, life: rawHP)
        return attValue
    }
    var rawPresentValueInGroove:CGSSAttributeValue {
        let attValue = CGSSAttributeValue.init(visual: rawVisualInGroove, vocal: rawVocalInGroove, dance: rawDanceInGroove, life: rawHPInGroove)
        return attValue
    }
    var rawVocal:Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.vocal) ?? 0
        }
        return sum
    }
    var rawVocalInGroove:Int {
        var sum = 0
        for i in 0...4 {
            sum += (self[i]?.cardRef?.vocal) ?? 0
        }
        return sum
    }
    var rawDance:Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.dance) ?? 0
        }
        return sum
    }
    var rawDanceInGroove:Int {
        var sum = 0
        for i in 0...4 {
            sum += (self[i]?.cardRef?.dance) ?? 0
        }
        return sum
    }
    var rawVisual:Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.visual) ?? 0
        }
        return sum
    }
    var rawVisualInGroove:Int {
        var sum = 0
        for i in 0...4 {
            sum += (self[i]?.cardRef?.visual) ?? 0
        }
        return sum
    }
    var rawHP:Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.life) ?? 0
        }
        return sum
    }
    var rawHPInGroove:Int {
        var sum = 0
        for i in 0...5 {
            sum += (self[i]?.cardRef?.life) ?? 0
        }
        return sum
    }
    
    var leaderSkillUpValue:CGSSAttributeValue {
        var attValue = CGSSAttributeValue.init(visual: 0, vocal: 0, dance: 0, life: 0)
        var contents = [LeaderSkillUpContent]()
        if let leaderSkill = leader.cardRef?.leader_skill {
            contents.appendContentsOf(getContentFor(leaderSkill))
        }
        if let leaderSkill = friendLeader.cardRef?.leader_skill {
            contents.appendContentsOf(getContentFor(leaderSkill))
        }
        for content in contents {
            for i in 0...5 {
                if self[i]?.cardRef?.cardFilterType == content.upTarget {
                    switch content.upType {
                    case .Vocal:
                        attValue.vocal += content.upValue * (self[i]?.cardRef?.vocal)!
                    case .Dance:
                        attValue.dance += content.upValue * (self[i]?.cardRef?.dance)!
                    case .Visual:
                        attValue.visual += content.upValue * (self[i]?.cardRef?.visual)!
                    case .Life:
                        attValue.life += content.upValue * (self[i]?.cardRef?.life)!
                    default:
                        break
                    }
                }
            }
        }
        return attValue
    }
    
    var leaderSkillUpValueInGroove:CGSSAttributeValue {
        var attValue = CGSSAttributeValue.init(visual: 0, vocal: 0, dance: 0, life: 0)
        var contents = [LeaderSkillUpContent]()
        if let leaderSkill = leader.cardRef?.leader_skill {
            contents.appendContentsOf(getContentFor(leaderSkill))
        }
        for content in contents {
            for i in 0...4 {
                if self[i]?.cardRef?.cardFilterType == content.upTarget {
                    switch content.upType {
                    case .Vocal:
                        attValue.vocal += content.upValue * (self[i]?.cardRef?.vocal)!
                    case .Dance:
                        attValue.dance += content.upValue * (self[i]?.cardRef?.dance)!
                    case .Visual:
                        attValue.visual += content.upValue * (self[i]?.cardRef?.visual)!
                    case .Life:
                        attValue.life += content.upValue * (self[i]?.cardRef?.life)!
                    default:
                        break
                    }
                }
            }
        }
        return attValue
    }

    var roomUpValue: CGSSAttributeValue {
        return CGSSAttributeValue.init(visual: rawVisual / 10 , vocal: rawVocal / 10, dance: rawDance / 10, life: rawHP / 10)
    }
    var roomUpValueInGroove: CGSSAttributeValue {
        return CGSSAttributeValue.init(visual: rawVisualInGroove / 10 , vocal: rawVocalInGroove / 10, dance: rawDanceInGroove / 10, life: rawHPInGroove / 10)
    }
    
    //此处使用CGSSCardFilterType.Office代表全色歌曲
    func getSongTypeUpValue(type:CGSSCardFilterType) -> CGSSAttributeValue {
        var attValue = CGSSAttributeValue.init(visual: 0, vocal: 0, dance: 0, life: 0)
        for i in 0...5 {
            if self[i]?.cardRef?.cardFilterType == type {
                attValue.vocal += 30 * (self[i]?.cardRef?.vocal)!
                attValue.dance += 30 * (self[i]?.cardRef?.dance)!
                attValue.visual += 30 * (self[i]?.cardRef?.visual)!
            }

        }
        return attValue
    }
    func getSongTypeUpValueInGroove(type:CGSSCardFilterType) -> CGSSAttributeValue {
        var attValue = CGSSAttributeValue.init(visual: 0, vocal: 0, dance: 0, life: 0)
        for i in 0...4 {
            if self[i]?.cardRef?.cardFilterType == type {
                attValue.vocal += 30 * (self[i]?.cardRef?.vocal)!
                attValue.dance += 30 * (self[i]?.cardRef?.dance)!
                attValue.visual += 30 * (self[i]?.cardRef?.visual)!
            }
            
        }
        return attValue
    }
    
    func getPresentValue(type: CGSSCardFilterType) -> CGSSAttributeValue {
        var attValue = CGSSAttributeValue.init(visual: 0, vocal: 0, dance: 0, life: 0)
        attValue += rawPresentValue
        attValue += getSongTypeUpValue(type)
        attValue += roomUpValue
        attValue += leaderSkillUpValue
        return attValue
    }
    
    func getPresentValueInGroove(type: CGSSCardFilterType) -> CGSSAttributeValue {
        var attValue = CGSSAttributeValue.init(visual: 0, vocal: 0, dance: 0, life: 0)
        attValue += rawPresentValueInGroove
        attValue += getSongTypeUpValueInGroove(type)
        attValue += roomUpValueInGroove
        attValue += leaderSkillUpValueInGroove
        return attValue
    }
    
    //判断需要的指定颜色的队员是否满足条件
    func hasType(type:CGSSCardFilterType, count:Int?) -> Bool {
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

    func getContentFor(leaderSkill:CGSSLeaderSkill) -> [LeaderSkillUpContent] {
        var contents = [LeaderSkillUpContent]()
        if hasType(.Cute, count: leaderSkill.need_cute) && hasType(.Cool, count: leaderSkill.need_cool) && hasType(.Passion, count: leaderSkill.need_passion) {
            switch leaderSkill.target_attribute! {
            case "cute":
                for upType in getUpType(leaderSkill) {
                    let content = LeaderSkillUpContent.init(upType: upType, upTarget: .Cute, upValue: leaderSkill.up_value!)
                    contents.append(content)
                }
            case "cool":
                for upType in getUpType(leaderSkill) {
                    let content = LeaderSkillUpContent.init(upType: upType, upTarget: .Cool, upValue: leaderSkill.up_value!)
                    contents.append(content)
                }
            case "passion":
                for upType in getUpType(leaderSkill) {
                    let content = LeaderSkillUpContent.init(upType: upType, upTarget: .Passion, upValue: leaderSkill.up_value!)
                    contents.append(content)
                }
            case "all":
                for upType in getUpType(leaderSkill) {
                    let content1 = LeaderSkillUpContent.init(upType: upType, upTarget: .Cute, upValue: leaderSkill.up_value!)
                    contents.append(content1)
                    let content2 = LeaderSkillUpContent.init(upType: upType, upTarget: .Cool, upValue: leaderSkill.up_value!)
                    contents.append(content2)
                    let content3 = LeaderSkillUpContent.init(upType: upType, upTarget: .Passion, upValue: leaderSkill.up_value!)
                    contents.append(content3)
                }
            default:
                break
            }
            
        }
        return contents
    }
    

    //获取队长技能对队伍的加成效果
    func getUpContent() -> [CGSSCardFilterType: [LeaderSkillUpType: Int]] {
        var contents = [LeaderSkillUpContent]()
        //自己的队长技能
        if let leaderSkill = leader.cardRef?.leader_skill {
            contents.appendContentsOf(getContentFor(leaderSkill))
        }
        //队友的队长技能
        if let leaderSkill = friendLeader.cardRef?.leader_skill {
            contents.appendContentsOf(getContentFor(leaderSkill))
        }
        
        //合并同类型
        var newContents = [CGSSCardFilterType: [LeaderSkillUpType: Int]]()
        for content in contents {
            if newContents.keys.contains(content.upTarget) {
                if newContents[content.upTarget]!.keys.contains(content.upType) {
                    newContents[content.upTarget]![content.upType]! += content.upValue
                } else {
                    newContents[content.upTarget]![content.upType] = content.upValue
                }
            } else {
                newContents[content.upTarget] = [LeaderSkillUpType:Int]()
                newContents[content.upTarget]![content.upType] = content.upValue
            }

        }
        return newContents
    }
    
    func getUpType(leaderSkill:CGSSLeaderSkill) -> [LeaderSkillUpType] {
        switch leaderSkill.target_param! {
        case "vocal":
            return [LeaderSkillUpType.Vocal]
        case "dance":
            return [LeaderSkillUpType.Dance]
        case "visual":
            return [LeaderSkillUpType.Visual]
        case "all":
            return [LeaderSkillUpType.Vocal, LeaderSkillUpType.Dance, LeaderSkillUpType.Visual]
        case "life" :
            return [LeaderSkillUpType.Life]
        case "skill_probability":
            return [LeaderSkillUpType.Proc]
        default:
            return [LeaderSkillUpType]()
        }
    }

    
    init(leader:CGSSTeamMember, subs:[CGSSTeamMember], teamBackSupportValue:Int, friendLeader: CGSSTeamMember?) {
        self.leader = leader
        self.subs = subs
        self.teamBackSupportValue = teamBackSupportValue
        self.friendLeader = friendLeader ?? leader
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        self.leader = aDecoder.decodeObjectForKey("leader") as? CGSSTeamMember
        self.subs = aDecoder.decodeObjectForKey("subs") as? [CGSSTeamMember]
        self.teamBackSupportValue = aDecoder.decodeObjectForKey("teamBackSupportValue") as? Int
        self.friendLeader = aDecoder.decodeObjectForKey("friendLeader") as? CGSSTeamMember
        self.testDiff = aDecoder.decodeObjectForKey("testDiff") as? Int
        self.testLiveId = aDecoder.decodeObjectForKey("testLiveId") as? Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(leader, forKey: "leader")
        aCoder.encodeObject(subs, forKey: "subs")
        aCoder.encodeObject(teamBackSupportValue, forKey: "teamBackSupportValue")
        aCoder.encodeObject(friendLeader, forKey: "friendLeader")
        aCoder.encodeObject(testLiveId, forKey: "testLiveId")
        aCoder.encodeObject(testDiff, forKey: "testDiff")
    }
   
}

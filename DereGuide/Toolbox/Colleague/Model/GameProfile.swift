//
//  GameProfile.swift
//  DereGuide
//
//  Created by zzk on 2019/3/14.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation
import CoreData
import MessagePack

class GameProfile {
    
    let id: Int
    let leaderCardID: Int
    let cuteSupportCard: CardInfo?
    let coolSupportCard: CardInfo?
    let passionSupportCard: CardInfo?
    let allTypeSupportCard: CardInfo?
    let name: String
    
    struct CardInfo {
        let id: Int
        let potential: Potential
    }
    
    init(from messagePack: MessagePackValue) {
        
        let data = messagePack.dictionaryValue?["data"]
        let friendInfo = data?.dictionaryValue?["friend_info"]
        let userInfo = friendInfo?.dictionaryValue?["user_info"]
        id = userInfo?.dictionaryValue?["viewer_id"]?.unsignedIntegerValue.flatMap(Int.init) ?? 0
        name = userInfo?.dictionaryValue?["name"]?.stringValue ?? ""
        
        leaderCardID = friendInfo?.dictionaryValue?["leader_card_info"]?.dictionaryValue?["card_id"]?.unsignedIntegerValue.flatMap(Int.init) ?? 0
        
        let potentialInfos = friendInfo?.dictionaryValue?["user_chara_potential"]
        
        func cardOfIndex(i: Int) -> CardInfo {
            let potentialInfo = potentialInfos?.dictionaryValue?[.string("chara_\(i)")]
            let potential = Potential(
                vocal: potentialInfo?.dictionaryValue?["param_1"]?.unsignedIntegerValue.flatMap(Int.init) ?? 0,
                dance: potentialInfo?.dictionaryValue?["param_2"]?.unsignedIntegerValue.flatMap(Int.init) ?? 0,
                visual: potentialInfo?.dictionaryValue?["param_3"]?.unsignedIntegerValue.flatMap(Int.init) ?? 0,
                skill: potentialInfo?.dictionaryValue?["param_4"]?.unsignedIntegerValue.flatMap(Int.init) ?? 0,
                life: potentialInfo?.dictionaryValue?["param_5"]?.unsignedIntegerValue.flatMap(Int.init) ?? 0
            )
            let id = friendInfo?.dictionaryValue?["support_card_info"]?.dictionaryValue?[.uint(UInt64(i))]?.dictionaryValue?["card_id"]?.unsignedIntegerValue.flatMap(Int.init) ?? 0
            return CardInfo(id: id, potential: potential)
        }
        
        cuteSupportCard = cardOfIndex(i: 1)
        coolSupportCard = cardOfIndex(i: 2)
        passionSupportCard = cardOfIndex(i: 3)
        allTypeSupportCard = cardOfIndex(i: 4)
    }
}

extension GameProfile {
    
    var isValid: Bool {
        return String(id).match(pattern: "^[0-9]{9}$").count == 1 && cuteSupportCard != nil && leaderCardID != 0
    }
}

extension Profile {
    
    static func findOrCreate(in context: NSManagedObjectContext, gameProfile: GameProfile) -> Profile {
        let profile = Profile.findOrCreate(in: context, configure: { _ in })
        profile.gameID = String(gameProfile.id)
        profile.nickName = gameProfile.name
        profile.leaderCardID = Int32(gameProfile.leaderCardID)
        profile.cuteCardID = gameProfile.cuteSupportCard.flatMap { Int32($0.id) } ?? 0
        profile.coolCardID = gameProfile.coolSupportCard.flatMap { Int32($0.id) } ?? 0
        profile.passionCardID = gameProfile.passionSupportCard.flatMap { Int32($0.id) } ?? 0
        profile.cuteVocalLevel = gameProfile.cuteSupportCard.flatMap { Int16($0.potential.vocal) } ?? 0
        profile.allTypeCardID = gameProfile.allTypeSupportCard.flatMap { Int32($0.id) } ?? 0
        profile.passionVisualLevel = gameProfile.passionSupportCard.flatMap { Int16($0.potential.visual) } ?? 0
        profile.passionDanceLevel = gameProfile.passionSupportCard.flatMap { Int16($0.potential.dance) } ?? 0
        profile.passionVocalLevel = gameProfile.passionSupportCard.flatMap { Int16($0.potential.vocal) } ?? 0
        profile.coolDanceLevel = gameProfile.coolSupportCard.flatMap { Int16($0.potential.dance) } ?? 0
        profile.coolVocalLevel = gameProfile.coolSupportCard.flatMap { Int16($0.potential.vocal) } ?? 0
        profile.cuteVisualLevel = gameProfile.cuteSupportCard.flatMap { Int16($0.potential.visual) } ?? 0
        profile.cuteDanceLevel = gameProfile.cuteSupportCard.flatMap { Int16($0.potential.dance) } ?? 0
        profile.allTypeVisualLevel = gameProfile.allTypeSupportCard.flatMap { Int16($0.potential.visual) } ?? 0
        profile.allTypeDanceLevel = gameProfile.allTypeSupportCard.flatMap { Int16($0.potential.dance) } ?? 0
        profile.allTypeVocalLevel = gameProfile.allTypeSupportCard.flatMap { Int16($0.potential.vocal) } ?? 0
        profile.coolVisualLevel = gameProfile.coolSupportCard.flatMap { Int16($0.potential.visual) } ?? 0
        profile.cuteLifeLevel = gameProfile.cuteSupportCard.flatMap { Int16($0.potential.life) } ?? 0
        profile.cuteSkillPotentialLevel = gameProfile.cuteSupportCard.flatMap { Int16($0.potential.skill) } ?? 0
        profile.coolSkillPotentialLevel = gameProfile.coolSupportCard.flatMap { Int16($0.potential.skill) } ?? 0
        profile.passionSkillPotentialLevel = gameProfile.passionSupportCard.flatMap { Int16($0.potential.skill) } ?? 0
        profile.allTypeSkillPotentialLevel = gameProfile.allTypeSupportCard.flatMap { Int16($0.potential.skill) } ?? 0
        profile.coolLifeLevel = gameProfile.coolSupportCard.flatMap { Int16($0.potential.life) } ?? 0
        profile.passionLifeLevel = gameProfile.passionSupportCard.flatMap { Int16($0.potential.life) } ?? 0
        profile.allTypeLifeLevel = gameProfile.allTypeSupportCard.flatMap { Int16($0.potential.life) } ?? 0
        
        return profile
    }
}

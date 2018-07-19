//
//  Unit+CoreDataClass.swift
//  DereGuide
//
//  Created by zzk on 2017/7/7.
//  Copyright © 2017 zzk. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

public class Unit: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Unit> {
        return NSFetchRequest<Unit>(entityName: "Unit")
    }
    
    @NSManaged public var customAppeal: Int64
    @NSManaged public var supportAppeal: Int64
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var usesCustomAppeal: Bool
    @NSManaged public var members: Set<Member>
    
    @NSManaged fileprivate var primitiveCreatedAt: Date
    @NSManaged fileprivate var primitiveUpdatedAt: Date
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        primitiveUpdatedAt = Date()
        primitiveCreatedAt = Date()
    }
    
    public override func willSave() {
        super.willSave()
        if hasChanges {
            if let context = managedObjectContext {
                // modification made by main queue will upload to the remote
                if context.concurrencyType == .mainQueueConcurrencyType {
                    refreshUpdateDate()
                    if hasLocalTrackedChanges && !isInserted {
                        markForRemoteModification()
                    }
                }
            }
            // after unit uploaded successfully, upload members by marking them as changed
            if changedValues().keys.contains(where: {
                ["remoteIdentifier", "creatorID"].contains($0)
            }) {
                members.forEach {
                    $0.refreshUpdateDate()
                }
            }
        }
    }
    
    @discardableResult
    private static func insert(into moc: NSManagedObjectContext, customAppeal: Int64, supportAppeal: Int64, usesCustomAppeal: Bool, members: Set<Member>) -> Unit {
        let unit: Unit = moc.insertObject()
        unit.customAppeal = customAppeal
        unit.supportAppeal = supportAppeal
        unit.usesCustomAppeal = usesCustomAppeal
        unit.members = members
        return unit
    }
    
    @discardableResult
    static func insert(into moc: NSManagedObjectContext, customAppeal: Int = 0, supportAppeal: Int = Config.maximumSupportAppeal, usesCustomAppeal: Bool = false, members: [Member]) -> Unit {
        members.forEach {
            $0.participatedPosition = Int16(members.index(of: $0)!)
        }
        return insert(into: moc, customAppeal: Int64(customAppeal), supportAppeal: Int64(supportAppeal), usesCustomAppeal: usesCustomAppeal, members: Set(members))
    }
    
    @discardableResult
    static func insert(into moc: NSManagedObjectContext, anotherUnit: Unit) -> Unit {
        return insert(into: moc, customAppeal: anotherUnit.customAppeal, supportAppeal: anotherUnit.supportAppeal, usesCustomAppeal: anotherUnit.usesCustomAppeal, members: Set(anotherUnit.members.map {
            return Member.insert(into: moc, anotherMember: $0)
        }))
    }
    
}

extension Unit: Managed {
    
    public static var entityName: String {
        return "Unit"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(updatedAt), ascending: false)]
    }
    
    public static var defaultPredicate: NSPredicate {
        return notMarkedForDeletionPredicate
    }
    
}

extension Unit: RemoteRefreshable {
    @NSManaged public var markedForLocalChange: Bool
    var localTrackedKeys: [String] {
        return ["customAppeal", "supportAppeal", "usesCustomAppeal"]
    }
}

extension Unit: RemoteUpdatable {
    
    typealias R = RemoteUnit
    
    func update(using remoteRecord: RemoteUnit) {
        guard remoteRecord.localModifiedAt >= self.updatedAt else {
            print("no need to update this unit \(self.remoteIdentifier!)")
            markForRemoteModification()
            return
        }
        self.customAppeal = remoteRecord.customAppeal
        self.supportAppeal = remoteRecord.supportAppeal
        self.usesCustomAppeal = remoteRecord.usesCustomAppeal != 0
        self.updatedAt = remoteRecord.localModifiedAt
    }
    
}

extension Unit {}

extension Unit: UpdateTimestampable {}

extension Unit: DelayedDeletable {
    @NSManaged public var markedForDeletionDate: Date?
}

extension Unit: RemoteDeletable {
    @NSManaged public var markedForRemoteDeletion: Bool
    @NSManaged public var remoteIdentifier: String?
    
    var ckReference: CKReference? {
        guard let id = remoteIdentifier else {
            return nil
        }
        return CKReference(recordID: CKRecordID.init(recordName: id), action: .deleteSelf)
    }
    
    public func markForRemoteDeletion() {
        markedForRemoteDeletion = true
    }
}

extension Unit: UserOwnable {
    @NSManaged public var creatorID: String?
}

extension Unit: RemoteUploadable {
    public func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: RemoteUnit.recordType)
        record["customAppeal"] = customAppeal as CKRecordValue
        record["supportAppeal"] = supportAppeal as CKRecordValue
        record["usesCustomAppeal"] = (usesCustomAppeal ? 1 : 0) as CKRecordValue
        record["localCreatedAt"] = createdAt as NSDate
        record["localModifiedAt"] = updatedAt as NSDate
        return record
    }
}

extension Unit {
    
    var leader: Member {
        return orderedMembers[0]
    }
    
    var friendLeader: Member {
        return orderedMembers[5]
    }
    
    var subs: [Member] {
        return Array(members.sorted { $0.participatedPosition < $1.participatedPosition }[1...4])
    }
    
    var orderedMembers: [Member] {
        return members.sorted { $0.participatedPosition < $1.participatedPosition }
    }
    
    var skills: [CGSSRankedSkill] {
        var arr = [CGSSRankedSkill]()
        for i in 0...4 {
            if let skill = self[i].card?.skill {
                let level = Int(self[i].skillLevel)
                let rankedSkill = CGSSRankedSkill(level: level, skill: skill)
                arr.append(rankedSkill)
            }
        }
        return arr
    }
    
    subscript (index: Int) -> Member {
        return orderedMembers[index]
    }
    
    subscript (range: CountableClosedRange<Int>) -> ArraySlice<Member> {
        var arraySlice = ArraySlice<Member>()
        for index in range.lowerBound...range.upperBound {
            arraySlice.insert(self[index], at: index)
        }
        return arraySlice
    }
    
    func hasSkillType(_ type: CGSSSkillTypes) -> Bool {
        return orderedMembers[0..<5].contains { $0.card?.skillType == type }
    }
    
    /// if the player may have double hp at the start of groove final live
    var shouldHaveDoubleHPInGroove: Bool {
        let r1 = hasSkillType(.allRound) || hasSkillType(.heal)
        let r2 = hasSkillType(.boost) && hasSkillType(.guard)
        let r3 = hasSkillType(.synergy) && isThreeColor(isInGrooveOrParade: true)
        return r1 || r2 || r3
    }
    
    // 队伍原始值
    var rawAppeal: CGSSAppeal {
        var appeal = rawAppealInGroove
        let member = self[5]
        guard let card = member.card else {
            return appeal
        }
        appeal += card.appeal.addBy(potential: member.potential, rarity: card.rarityType)
        return appeal
    }
    
    var rawAppealInGroove: CGSSAppeal {
        var appeal = CGSSAppeal.zero
        for i in 0...4 {
            guard let card = self[i].card else {
                fatalError()
            }
            appeal += card.appeal.addBy(potential: self[i].potential, rarity: card.rarityType)
        }
        return appeal
    }
    
    private func getAppeal(_ type: CGSSCardTypes) -> CGSSAppeal {
        var appeal = CGSSAppeal.zero
        let contents = getUpContent()
        for i in 0...5 {
            guard let card = self[i].card else {
                fatalError()
            }
            appeal += card.getAppealBy(liveType: type, contents: contents, potential: self[i].potential)
        }
        return appeal
    }
    
    private func getAppealInGroove(_ type: CGSSCardTypes, burstType: LeaderSkillUpType) -> CGSSAppeal {
        var appeal = CGSSAppeal.zero
        let contents = getUpContentInGroove(by: burstType)
        for i in 0...4 {
            guard let card = self[i].card else {
                fatalError()
            }
            appeal += card.getAppealBy(liveType: type, contents: contents, potential: self[i].potential)
        }
        return appeal
    }
    
    private func getAppealInParade(_ type: CGSSLiveTypes) -> CGSSAppeal {
        var appeal = CGSSAppeal.zero
        let contents = getUpContentInParade()
        for i in 0...4 {
            guard let card = self[i].card else {
                fatalError()
            }
            appeal += card.getAppealBy(liveType: type, contents: contents, potential: self[i].potential)
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
    func hasType(_ type: CGSSCardTypes, count: Int, isInGrooveOrParade: Bool) -> Bool {
        if count == 0 {
            return true
        }
        
        var c = 0
        for i in 0...(isInGrooveOrParade ? 4 : 5) {
            guard let card = self[i].card else {
                fatalError()
            }
            if card.cardType == type {
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
        if let leaderSkill = leader.card?.leaderSkill {
            contents.append(contentsOf: getContentFor(leaderSkill, isInGrooveOrParade: false))
        }
        // 队友的队长技能
        if let leaderSkill = friendLeader.card?.leaderSkill {
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
        if let leaderSkill = leader.card?.leaderSkill {
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
        if let leaderSkill = leader.card?.leaderSkill {
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
    
    func validateMembers() -> Bool {
        return members.count == 6 && members.compactMap { (member) -> CGSSCard? in
           return member.card
        }.count == 6
    }
    
}

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

extension CGSSCard {
    // 扩展一个获取卡片在队伍中的表现值的方法
    func getAppealBy(liveType: CGSSCardTypes, roomUpValue: Int = LiveSimulationAdvanceOptionsManager.default.roomUpValue, contents: [CGSSCardTypes: [LeaderSkillUpType: Int]], potential: Potential) -> CGSSAppeal {
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

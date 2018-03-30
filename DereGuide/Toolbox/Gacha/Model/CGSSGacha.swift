//
//  CGSSGacha.swift
//  DereGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Array {
    func random() -> Element? {
        if count >= 0 {
            let rand = arc4random_uniform(UInt32(self.count))
            return self[Int(rand)]
        } else {
            return nil
        }
    }
}

extension CGSSGacha {
    
    var hasOdds: Bool {
        return id > 30075
    }
    
    var hasLocalRates: Bool {
        return id < 30180
    }
    
    var hasCachedRates: Bool {
        return cachedOdds != nil
    }
    
    var cardList: [CGSSCard] {
        get {
            var list = [CGSSCard]()
            let dao = CGSSDAO.shared
            for reward in self.rewardTable.values {
                if let card = dao.findCardById(reward.cardId) {
                    list.append(card)
                }
            }
            return list
        }
    }
    
    var bannerId: Int {
        var result = id - 30000
        if dicription.contains("クールタイプ") || dicription.contains("パッションタイプ") || dicription.contains("キュートタイプ") {
            result = 29
        } else if id == 30001 {
            // TODO: 初始卡池的图不存在 需要一个placeholder
        } else if id == 30013 {
            result = 12
        }
        return result
    }
    
    var detailBannerId: Int {
        var result = id - 30000
        if [30032, 30033, 30034].contains(id) {
            result -= 3
        }
        if dicription.contains("クールタイプ") {
            result -= 1
        } else if dicription.contains("パッションタイプ") {
            result -= 2
        } else if id == 30013 {
            result = 12
        } else if gachaType == .premium {
            result = (id - 1) / 3 * 3 + 1
        }
        
        return result
    }
    
    var bannerURL: URL! {
        return URL.init(string: String.init(format: "https://game.starlight-stage.jp/image/announce/title/thumbnail_gacha_%04d.png", bannerId))
    }
        
    var detailBannerURL: URL! {
        if id > 30170 && isReappeared {
            return URL(string: String(format: "https://games.starlight-stage.jp/image/announce/image/header_gacha_%04d.png", detailBannerId))
        } else if gachaType == .premium {
            return URL(string: String(format: "https://apis.game.starlight-stage.jp/image/announce/header/header_premium_%04d.png", detailBannerId % 10000))
        } else {
            return URL(string: String(format: "https://games.starlight-stage.jp/image/announce/header/header_gacha_%04d.png", detailBannerId))
        }
    }
    
    var isReappeared: Bool {
        return name.contains("復刻")
    }
    
    var gachaType: CGSSGachaTypes {
        if dicription.contains("フェス限定") {
            return CGSSGachaTypes.fes
        } else if dicription.contains("期間限定") {
            return CGSSGachaTypes.limit
        } else if dicription.contains("クールタイプ") || dicription.contains("パッションタイプ") || dicription.contains("キュートタイプ") {
            return CGSSGachaTypes.singleType
        } else if id >= 60000 && id < 70000 {
            return CGSSGachaTypes.premium
        } else {
            return CGSSGachaTypes.normal
        }
    }
    
    var gachaColor: UIColor {
        switch gachaType {
        case CGSSGachaTypes.normal:
            return Color.normalGacha
        case CGSSGachaTypes.limit:
            return Color.limitedGacha
        case CGSSGachaTypes.fes:
            return Color.cinFesGacha
        case CGSSGachaTypes.premium:
            return .premium
        default:
            return Color.allType
        }
    }

}

struct Reward {
    var cardId: Int
    var recommandOrder: Int
    var relativeOdds: Int
    var relativeSROdds: Int
}

struct CardWithOdds {
    var card: CGSSCard
    var odds: Int?
}

class CGSSGacha: NSObject {

    var dicription: String
    var endDate: String
    @objc dynamic var id: Int
    var name: String
    
    /// 8850 -> 88.5%
    var rareRatio: Int
    var srRatio: Int
    var ssrRatio: Int
    @objc dynamic var startDate: String
    
    var rewardTable = [Int: Reward]()
    var sr = [Reward]()
    var ssr = [Reward]()
    var r = [Reward]()
    var new = [Reward]()
    var newssr = [Reward]()
    var newsr = [Reward]()
    var newr = [Reward]()
    
    lazy var cachedOdds: GachaOdds? = {
        if let odds = GachaOdds(fromCachedDataByGachaID: self.id) {
            merge(gachaOdds: odds)
            return odds
        } else {
            return nil
        }
    }()
    
    lazy var cardsOfguaranteed: [CGSSCard] = {
        let semephore = DispatchSemaphore(value: 0)
        var result = [CGSSCard]()
        CGSSGameResource.shared.master.getGuaranteedCardIds(gacha: self, callback: { (cardIds) in
            result.append(contentsOf: cardIds.map { CGSSDAO.shared.findCardById($0) }.compactMap { $0 } )
            semephore.signal()
        })
        semephore.wait()
        return result
    }()
    
    init(id:Int, name:String, dicription:String, start_date:String, end_date:String, rare_ratio:Int, sr_ratio:Int, ssr_ratio:Int, rewards:[Reward]) {
        self.id = id
        self.name = name
        self.dicription = dicription
        self.startDate = start_date
        self.endDate = end_date
        self.rareRatio = rare_ratio
        self.srRatio = sr_ratio
        self.ssrRatio = ssr_ratio
        self.rewardTable = [Int: Reward]()
        let dao = CGSSDAO.shared
        for reward in rewards {
            if reward.recommandOrder > 0 {
                new.append(reward)
            }
            self.rewardTable[reward.cardId] = reward
            if let card = dao.findCardById(reward.cardId) {
                switch card.rarityType {
                case CGSSRarityTypes.ssr:
                    if reward.recommandOrder > 0 {
                        newssr.append(reward)
                    } else {
                        ssr.append(reward)
                    }
                case CGSSRarityTypes.sr:
                    if reward.recommandOrder > 0 {
                        newsr.append(reward)
                    } else {
                        sr.append(reward)
                    }
                case CGSSRarityTypes.r:
                    if reward.recommandOrder > 0 {
                        newr.append(reward)
                    } else {
                        r.append(reward)
                    }
                default:
                    break
                }
            }
        }
    }
    
    private struct RewardOdds {
        
        var reward: Reward
        
        /// included
        var start: Int
        
        /// not included
        var end: Int
    }
    
    private var odds: [RewardOdds]!
    private var srOdds: [RewardOdds]!
    
    private func generateOdds() {
        
        if odds == nil {
            var start = 0
            odds = [RewardOdds]()
            for reward in rewardTable.values {
                odds.append(RewardOdds.init(reward: reward, start: start, end: start + reward.relativeOdds))
                start += reward.relativeOdds
            }
        }
        
        if srOdds == nil {
            var start = 0
            srOdds = [RewardOdds]()
            for reward in rewardTable.values {
                srOdds.append(RewardOdds.init(reward: reward, start: start, end: start + reward.relativeSROdds))
                start += reward.relativeSROdds
            }
        }
    }
    
    /// merge gacha odds into local reward table
    ///
    /// - Parameter gachaOdds: gacha odds from remote api
    func merge(gachaOdds: GachaOdds) {
        srRatio = ((gachaOdds.chargeRate[.sr]?.double() ?? 0) * 100).roundedInt()
        ssrRatio = ((gachaOdds.chargeRate[.ssr]?.double() ?? 0) * 100).roundedInt()
        rareRatio = ((gachaOdds.chargeRate[.r]?.double() ?? 0) * 100).roundedInt()
        for (key, value) in gachaOdds.cardIDOdds {
            rewardTable[key]?.relativeOdds = (value.chargeOdds.double() * 10000).roundedInt()
            rewardTable[key]?.relativeSROdds = (value.srOdds.double() * 10000).roundedInt()
        }
    }
    
    func simulateOnce(srGuarantee: Bool) -> Int {
        if hasOdds {
            generateOdds()
            guard let arr = srGuarantee ? srOdds : odds, arr.count > 0, arr.last!.end > 0 else {
                return 0
            }
            var index: Int?
            repeat {
                let rand = arc4random_uniform(UInt32(arr.last?.end ?? 0))
                index = arr.index { $0.start <= Int(rand) && $0.end > Int(rand) }
            } while index == nil
            return arr[index!].reward.cardId
        } else {
            let rand = arc4random_uniform(10000)
            var rarity: CGSSRarityTypes
            switch rand {
            case UInt32(rareRatio + srRatio)..<10000:
                rarity = .ssr
            case UInt32(rareRatio)..<UInt32(rareRatio + srRatio):
                rarity = .sr
            default:
                rarity = .r
            }
            
            if srGuarantee && rarity == .r {
                rarity = .sr
            }
            
            switch rarity {
            case CGSSRarityTypes.ssr:
                //目前ssr新卡占40% sr新卡占20% r新卡占12% 
                if newssr.count > 0 && CGSSGlobal.isProc(rate: 40000) {
                    return newssr.random()!.cardId
                } else if ssr.count > 0 {
                    return ssr.random()!.cardId
                } else {
                    return 0
                }
            case CGSSRarityTypes.sr:
                if newsr.count > 0 && CGSSGlobal.isProc(rate: 20000) {
                    return newsr.random()!.cardId
                } else if sr.count > 0 {
                    return sr.random()!.cardId
                } else {
                    return 0
                }
            case CGSSRarityTypes.r:
                if newr.count > 0 && CGSSGlobal.isProc(rate: 12000) {
                    return newr.random()!.cardId
                } else if r.count > 0 {
                    return r.random()!.cardId
                } else {
                    return 0
                }
            default:
                return 0
            }
        }
    }

    func simulate(times: Int, srGuaranteeCount: Int) -> [Int] {
        var result = [Int]()
        guard srGuaranteeCount <= times else {
            fatalError("sr guarantees is greater than simulation times")
        }
        for i in 0..<times {
            if i + srGuaranteeCount >= times {
                result.append(simulateOnce(srGuarantee: true))
            } else {
                result.append(simulateOnce(srGuarantee: false))
            }
        }
        return result
    }
    
}


extension Double {
    
    func roundedInt(digits: Int = 0) -> Int {
        return Int(rounded(digits: digits))
    }
}

extension String {
    
    func double(`default`: Double = 0) -> Double {
        return Double(self) ?? `default`
    }
    
}

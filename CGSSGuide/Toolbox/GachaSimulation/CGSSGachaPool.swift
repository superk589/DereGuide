//
//  CGSSGachaPool.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
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

extension CGSSGachaPool {
    var cardList: [CGSSCard] {
        get {
            var list = [CGSSCard]()
            let dao = CGSSDAO.sharedDAO
            for rew in self.rewards {
                if let card = dao.findCardById(rew.cardId) {
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
        }
        return result
    }
    
    var gachaType: CGSSGachaTypes {
        if dicription.contains("フェス限定") {
            return CGSSGachaTypes.fes
        } else if dicription.contains("期間限定") {
            return CGSSGachaTypes.limit
        } else if dicription.contains("クールタイプ") || dicription.contains("パッションタイプ") || dicription.contains("キュートタイプ") {
            return CGSSGachaTypes.singleType
        } else {
            return CGSSGachaTypes.normal
        }
    }
}

struct Reward {
    var cardId: Int!
    var rewardRecommand: Int!
}

class CGSSGachaPool: CGSSBaseModel {
    
//    {
//
//    "dicription" : "新SSレア堀裕子登場 ! 10連ガシャはSレア以上のアイドル1人が確定で出現 ! ! ※アイドルの所属上限を超える場合、プレゼントに送られます。",
//    "end_date" : "2016-09-14 14:59:59",
//    "id" : "30067",
//    "name" : "プラチナオーディションガシャ",
//    "rare_ratio" : "8850",
//    "sr_ratio" : "1000",
//    "ssr_ratio" : "150",
//    "start_date" : "2016-09-09 15:00:00",
//    }

    var dicription: String
    var endDate: String
    var id: Int
    var name: String
    var rareRatio: Int
    var srRatio: Int
    var ssrRatio: Int
    var startDate: String
    
    var rewards = [Reward]()
    var sr = [Reward]()
    var ssr = [Reward]()
    var r = [Reward]()
    var new = [Reward]()
    var newssr = [Reward]()
    var newsr = [Reward]()
    var newr = [Reward]()
    
    init(id:Int, name:String, dicription:String, start_date:String, end_date:String, rare_ratio:Int, sr_ratio:Int, ssr_ratio:Int, rewards:[(Int, Int)]) {
        self.id = id
        self.name = name
        self.dicription = dicription
        self.startDate = start_date
        self.endDate = end_date
        self.rareRatio = rare_ratio
        self.srRatio = sr_ratio
        self.ssrRatio = ssr_ratio
        self.rewards = [Reward]()
        let dao = CGSSDAO.sharedDAO
        for reward in rewards {
            let rew = Reward.init(cardId: reward.0 , rewardRecommand: reward.1)
            if let card = dao.findCardById(rew.cardId) {
                if rew.rewardRecommand > 0 {
                    new.append(rew)
                }
                switch card.rarityType {
                case CGSSRarityTypes.ssr:
                    if rew.rewardRecommand > 0 {
                        newssr.append(rew)
                    } else {
                        ssr.append(rew)
                    }
                case CGSSRarityTypes.sr:
                    if rew.rewardRecommand > 0 {
                        newsr.append(rew)
                    } else {
                        sr.append(rew)
                    }
                case CGSSRarityTypes.r:
                    if rew.rewardRecommand > 0 {
                        newr.append(rew)
                    } else {
                        r.append(rew)
                    }
                default:
                    break
                }
                self.rewards.append(rew)
            }
        }
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func simulateOnce(srGuarantee: Bool) -> Int {
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

    func simulate(times:UInt32, srGuaranteeCount:Int) -> [Int] {
        var result = [Int]()
        var rands = [UInt32]()
        for _ in 0..<srGuaranteeCount {
            var rand:UInt32
            // !!!当sr低保数和总抽卡数相近时 可能存在效率问题 
            repeat {
                rand = arc4random_uniform(times)
            } while rands.contains(rand)
            rands.append(rand)
        }
        for i:UInt32 in 0...times - 1 {
            if rands.contains(i) {
                result.append(simulateOnce(srGuarantee: true))
            } else {
                result.append(simulateOnce(srGuarantee: false))
            }
        }
        return result
    }
}

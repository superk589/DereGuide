//
//  GachaPool.swift
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

extension GachaPool {
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
}

struct Reward {
    var cardId: Int!
    var rewardRecommand: Int!
}

class GachaPool {
    
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
                switch card.rarityFilterType {
                case .ssr:
                    if rew.rewardRecommand > 0 {
                        newssr.append(rew)
                    } else {
                        ssr.append(rew)
                    }
                case .sr:
                    sr.append(rew)
                case .r:
                    r.append(rew)
                default:
                    break
                }
                self.rewards.append(rew)
            }
        }
    }
    
    func simulateOnce(srGuarantee: Bool) -> Int {
        let rand = arc4random_uniform(10000)
        var rarity: CGSSCardRarityFilterType
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
        case .ssr:
            //目前只有ssr考虑新卡的几率加成(新卡共享40%总的ssr概率)
            //TODO: 如果有sr和r的新卡几率加成具体数据 再添加
            if newssr.count > 0 && CGSSGlobal.isProc(rate: 40000) {
                return newssr.random()!.cardId
            } else if ssr.count > 0 {
                return ssr.random()!.cardId
            } else {
                return 0
            }
        case .sr:
            if sr.count > 0 {
                return sr.random()!.cardId
            } else {
                return 0
            }
        case .r:
            if r.count > 0 {
                return r.random()!.cardId
            } else {
                return 0
            }
        default:
            return 0
        }
    }

    func simulate(times:Int) -> [Int] {
        var result = [Int]()
        let rand = arc4random_uniform(10)
        for i:UInt32 in 0...9 {
            if i == rand {
                result.append(simulateOnce(srGuarantee: true))
            } else {
                result.append(simulateOnce(srGuarantee: false))
            }
        }
        return result
    }
}

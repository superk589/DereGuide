//
//  GachaOdds.swift
//  DereGuide
//
//  Created by zzk on 19/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import MessagePack

enum ChargeRarityType: String, Codable {
    case ssr
    case sr
    case r

    init(rarityTypes: CGSSRarityTypes) {
        switch rarityTypes {
        case .ssr:
            self = .ssr
        case .sr:
            self = .sr
        default:
            self = .r
        }
    }
}

struct CardOdds: Codable {
    var cardID: Int
    var chargeOdds: String
    var srOdds: String
}

struct GachaOdds: Codable {
    
    static let path = Path.cache + "/Data/Gacha"
    
    private(set) var ssr = [CardOdds]()
    
    private(set) var sr = [CardOdds]()
    
    private(set) var r = [CardOdds]()
    
    var cardIDOdds: [Int: CardOdds] {
        let combined = ssr + sr + r
        return combined.reduce(into: [Int: CardOdds]()) { dict, odds in
            dict[odds.cardID] = odds
        }
    }
    
    private(set) var chargeRate = [ChargeRarityType: String]()
    
    private(set) var srChargeRate = [ChargeRarityType: String]()
    
    init?(fromMsgPack pack: MessagePackValue) {

        guard let rates = pack[.string("data")]?[.string("gacha_rate")] else { return nil }
        
        chargeRate[.r] = rates[.string("charge")]?[.string("r")]?.stringValue ?? ""
        chargeRate[.sr] = rates[.string("charge")]?[.string("sr")]?.stringValue ?? ""
        chargeRate[.ssr] = rates[.string("charge")]?[.string("ssr")]?.stringValue ?? ""
        
        srChargeRate[.r] = rates[.string("sr")]?[.string("r")]?.stringValue ?? ""
        srChargeRate[.sr] = rates[.string("sr")]?[.string("sr")]?.stringValue ?? ""
        srChargeRate[.ssr] = rates[.string("sr")]?[.string("ssr")]?.stringValue ?? ""
        
        guard let idols = pack[.string("data")]?[.string("idol_list")] else { return nil }
        
        let mapInnerPack: (MessagePackValue) -> CardOdds = { pack in
            let id = Int(pack[.string("card_id")]?.unsignedIntegerValue ?? 0)
            let chargeOdds = pack[.string("charge_odds")]?.stringValue ?? ""
            let srOdds = pack[.string("sr_odds")]?.stringValue ?? ""
            return CardOdds(cardID: id, chargeOdds: chargeOdds, srOdds: srOdds)
        }
        
        ssr = idols[.string("ssr")]?.arrayValue?.map(mapInnerPack) ?? []
        
        sr = idols[.string("sr")]?.arrayValue?.map(mapInnerPack) ?? []
        
        r = idols[.string("r")]?.arrayValue?.map(mapInnerPack) ?? []
        
        guard (ssr + sr + r).count > 0 else { return nil }
        
    }
    
    init?(fromCachedDataByGachaID gachaID: Int) {
        let url = URL(fileURLWithPath: GachaOdds.path + "/\(gachaID).json")
        if let data = try? Data(contentsOf: url), let odds = try? JSONDecoder().decode(GachaOdds.self, from: data), odds.ssr.count > 0 {
            self = odds
        } else {
            return nil
        }
    }
    
    func save(gachaID: Int) throws {
        if !FileManager.default.fileExists(atPath: GachaOdds.path) {
            try FileManager.default.createDirectory(atPath: GachaOdds.path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = URL(fileURLWithPath: GachaOdds.path + "/\(gachaID).json")
        let data = try JSONEncoder().encode(self)
        try data.write(to: url)
    }

}

//
//  CGSSGachaFilter.swift
//  DereGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

struct CGSSGachaFilter: CGSSFilter {
    
    var gachaTypes: CGSSGachaTypes
    
    var searchText: String = ""
    
    init(typeMask: UInt) {
        gachaTypes = CGSSGachaTypes.init(rawValue: typeMask)
    }
    
    func filter(_ list: [CGSSGachaPool]) -> [CGSSGachaPool] {
        let result = list.filter { (v: CGSSGachaPool) -> Bool in
            let r1: Bool = searchText == "" ? true : {
                let comps = searchText.components(separatedBy: "")
                for comp in comps {
                    if comp == "" { continue }
                    let b1 = v.name.lowercased().contains(comp.lowercased())
                    let b2 = v.dicription.lowercased().contains(comp.lowercased())
                    if b1 || b2 {
                        continue
                    } else {
                        return false
                    }
                }
                return true
                }()
            let r2: Bool = {
                if gachaTypes.contains(v.gachaType) {
                    return true
                }
                return false
            }()
            return r1 && r2
        }
        return result
        
    }
    
    
    func save(to path: String) {
        toDictionary().write(toFile: path, atomically: true)
    }
    
    func toDictionary() -> NSDictionary {
        let dict = ["typeMask": gachaTypes.rawValue] as NSDictionary
        return dict
    }
    
    init?(fromFile path: String) {
        if let dict = NSDictionary.init(contentsOfFile: path) {
            if let typeMask = dict.object(forKey: "typeMask") as? UInt {
                self.init(typeMask: typeMask)
                return
            }
        }
        return nil
    }
    
    
}

//
//  CGSSAttributeValue.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/6.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

struct CGSSAttributeValue {
    var visual:Int
    var vocal:Int
    var dance:Int
    var life:Int
    var total:Int {
        return visual + dance + vocal
    }
    func toStringArray() -> [String]{
        return [String(vocal), String(dance), String(visual), String(total)]
    }
    func toStringArrayWithBackValue(backValue:Int) -> [String] {
        return [String(vocal), String(dance), String(visual), String(total + backValue)]
    }
}

func + (a1:CGSSAttributeValue, a2:CGSSAttributeValue) -> CGSSAttributeValue {
    return CGSSAttributeValue.init(visual: a1.visual+a2.visual, vocal: a1.vocal+a2.vocal, dance: a1.dance+a2.dance, life: a1.life+a2.life)
}
func += (inout a1:CGSSAttributeValue, a2:CGSSAttributeValue) {
    a1 = a1 + a2
}


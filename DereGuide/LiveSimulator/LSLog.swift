//
//  LSLog.swift
//  DereGuide
//
//  Created by zzk on 2017/4/1.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

struct LSLog {
    
    /// 从1开始的Index
    var noteIndex: Int
    
    /// 计算所有加成的最终得分
    var score: Int
    
    /// 累计得分
    var sum: Int
    
    /// 基础分
    var baseScore: Double
    
    /// 基础C分加成(SSR - 118, 115; SR - 112 etc.)
    var baseComboBonus: Int
    
    /// 已经计算了skillBoost后的c分加成
    var comboBonus: Int
    
    /// 基础P分加成(SSR - 117, 118; SR - 115 etc.)
    var basePerfectBonus: Int
    
    /// 已经计算了skillBoost后的p分加成
    var perfectBonus: Int
    
    /// 连击加成
    var comboFactor: Double
    
    /// 技能增强数值(SSR - 1200)
    var skillBoost: Int
    
    var lifeRestore: Int
    
    var currentLife: Int
    
    var perfectLock: Bool
    
    var strongPerfectLock: Bool
    
    var comboContinue: Bool
    
    var `guard`: Bool
    
    var toDictionary: [String: Any] {
        return [
            "note_index": noteIndex,
            "score": score,
            "sum": sum,
            "base_score": baseScore,
            "base_combo_bonus": baseComboBonus,
            "combo_bonus": comboBonus,
            "base_perfect_bonus": basePerfectBonus,
            "perfect_bonus": perfectBonus,
            "combo_factor": comboFactor,
            "skill_boost": skillBoost
        ]
    }
}

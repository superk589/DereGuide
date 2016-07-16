//
//  CGSSSkill.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

public class CGSSSkill: NSObject, NSCoding {
    //    {
    //    "result": [
    //    {
    //    "condition": 14,
    public var condition:Int?
    //    ; Time between potential procs.
    public var cutin_type:Int?
    //    "cutin_type": 1,
    public var effect_length:(Int?,Int?)?
    //    "effect_length": [
    //    500,
    //    750
    //    ],
    //    ; Length of active effect at level 1 and level 10. For other levels,
    //    ; linearly interpolate.
    //    ; Divide by 100 to get seconds.
    public var explain:String?
    //    "explain": "14秒毎、中確率でしばらくの間、PERFECTでライフ3回復",
    //    ; Japanese effect description.
    public var explain_en:String?
    //    "explain_en": "Every 14 seconds: there is a 35..52.5% chance that all Perfect notes will restore 3 health for 5..7.5 seconds.",
    //    ; English effect description. Not directly translated from JA, but
    //    ; machine-generated.
    public var id:Int?
    //    "id": 200167,
    public var judge_type:Int?
    //    "judge_type": 1,
    public var proc_chance:(Int?,Int?)?
    //    "proc_chance": [
    //    3500,
    //    5250
    //    ],
    //    ; Proc chance at level 1 and level 10. For other levels,
    //    ; linearly interpolate.
    //    ; Divide by 100 to get percentage.
    public var skill_name:String?
    //    "skill_name": "気高き微笑",
    //    ; Translation usually available via read_tl.
    public var skill_trigger_type:Int?
    //    "skill_trigger_type": 0,
    //    ; Trigger effect type.
    //    ; Usually 0 except on Overload, which has 1.
    public var skill_trigger_value:Int?
    //    "skill_trigger_value": 0,
    //    ; This value is used by the skill's proc effect.
    public var skill_type:String?
    //    "skill_type": 17,
    public var value:Int?
    //    "value": 3
    //    ; This value is used by the skill's active effect.
    //    ; this value is a percentage (e.g. 116).
    
    public init(condition:Int, cutin_type:Int, effect_length:(Int?,Int?), explain:String, explain_en:String, id:Int, judge_type:Int, proc_chance:(Int?,Int?), skill_name:String, skill_trigger_type:Int, skill_trigger_value:Int, skill_type:String, value:Int) {
        self.condition = condition
        self.cutin_type = cutin_type
        self.effect_length = effect_length
        self.explain = explain
        self.explain_en = explain_en
        self.id = id
        //    "id": 200167,
        self.judge_type = judge_type
        //    "judge_type": 1,
        self.proc_chance = proc_chance
        
        self.skill_name = skill_name
        //    "skill_name": "気高き微笑",
        //    ; Translation usually available via read_tl.
        self.skill_trigger_type = skill_trigger_type
        //    "skill_trigger_type": 0,
        //    ; Trigger effect type.
        //    ; Usually 0 except on Overload, which has 1.
        self.skill_trigger_value = skill_trigger_value
        //    "skill_trigger_value": 0,
        //    ; This value is used by the skill's proc effect.
        self.skill_type = skill_type
        //    "skill_type": 17,
        self.value = value
    }
    public init(condition:Int?, cutin_type:Int?, effect_length:(Int?,Int?)?, explain:String?, explain_en:String?, id:Int?, judge_type:Int?, proc_chance:(Int?,Int?)?, skill_name:String?, skill_trigger_type:Int?, skill_trigger_value:Int?, skill_type:String?, value:Int?) {
        self.condition = condition
        self.cutin_type = cutin_type
        self.effect_length = effect_length
        self.explain = explain
        self.explain_en = explain_en
        self.id = id
        //    "id": 200167,
        self.judge_type = judge_type
        //    "judge_type": 1,
        self.proc_chance = proc_chance
        
        self.skill_name = skill_name
        //    "skill_name": "気高き微笑",
        //    ; Translation usually available via read_tl.
        self.skill_trigger_type = skill_trigger_type
        //    "skill_trigger_type": 0,
        //    ; Trigger effect type.
        //    ; Usually 0 except on Overload, which has 1.
        self.skill_trigger_value = skill_trigger_value
        //    "skill_trigger_value": 0,
        //    ; This value is used by the skill's proc effect.
        self.skill_type = skill_type
        //    "skill_type": 17,
        self.value = value
    }
    
    public convenience init?(attList:NSDictionary?){
        if let root2 = attList {
            let condition = root2["condition"] as? Int
            let cutin_type = root2["cutin_type"] as? Int
            let explain = root2["explain"] as? String
            let explain_en = root2["explain_en"] as? String
            let id = root2["id"] as? Int
            //    "id": 200167,
            let judge_type = root2["judge_type"] as? Int
            //    "judge_type": 1,
            var proc_chance:(Int?,Int?)? = (0,0)
            if let array1 = root2["proc_chance"] as? NSArray {
                if let v0 = array1[0] as? Int {
                    proc_chance!.0 = v0
                }
                if let v1 = array1[1] as? Int {
                    proc_chance!.1 = v1
                }
            }
            var effect_length:(Int?,Int?)? = (0,0)
            if let array2 = root2["effect_length"] as? NSArray {
                if let v0 = array2[0] as? Int {
                    effect_length!.0 = v0
                }
                if let v1 = array2[1] as? Int {
                    effect_length!.1 = v1
                }
            }
            
            
            let skill_name = root2["skill_name"] as? String
            //    "skill_name": "気高き微笑",
            //    ; Translation usually available via read_tl.
            let skill_trigger_type = root2["skill_trigger_type"] as? Int
            //    "skill_trigger_type": 0,
            //    ; Trigger effect type.
            //    ; Usually 0 except on Overload, which has 1.
            let skill_trigger_value = root2["skill_trigger_value"] as? Int
            //    "skill_trigger_value": 0,
            //    ; This value is used by the skill's proc effect.
            let skill_type = root2["skill_type"] as? String
            //    "skill_type": 17,
            let value = root2["value"] as? Int
            
            self.init(condition: condition, cutin_type: cutin_type, effect_length: effect_length, explain: explain, explain_en: explain_en, id: id, judge_type: judge_type, proc_chance: proc_chance, skill_name: skill_name, skill_trigger_type: skill_trigger_type, skill_trigger_value: skill_trigger_value, skill_type: skill_type, value: value)
            return
        }
        return nil
    }
    public convenience init?(jsonData:NSData) {
        let jsonObj = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
        
        if let root = jsonObj as? NSDictionary{
            if let result = root["result"] as? NSArray{
                self.init(attList: result[0] as? NSDictionary)
                return
            }
        }
        return nil
        
    }
    
    public func descroption() -> String {
        var str = ""
        str += String(condition)
        //    ; Time between potential procs.
        str += String(cutin_type)
        //    "cutin_type": 1,
        str += String(effect_length)
        //    "effect_length": [
        //    500,
        //    750
        //    ],
        //    ; Length of active effect at level 1 and level 10. For other levels,
        //    ; linearly interpolate.
        //    ; Divide by 100 to get seconds.
        str += String(explain)
        str += String(explain_en)
        //    "explain": "14秒毎、中確率でしばらくの間、PERFECTでライフ3回復",
        //    ; Japanese effect description.
        //    "explain_en": "Every 14 seconds: there is a 35..52.5% chance that all Perfect notes will restore 3 health for 5..7.5 seconds.",
        //    ; English effect description. Not directly translated from JA, but
        //    ; machine-generated.
        str += String(id)
        //    "id": 200167,
        str += String(judge_type)
        //    "judge_type": 1,
        str += String(proc_chance)
        //    "proc_chance": [
        //    3500,
        //    5250
        //    ],
        //    ; Proc chance at level 1 and level 10. For other levels,
        //    ; linearly interpolate.
        //    ; Divide by 100 to get percentage.
        str += String(skill_name)
        //    "skill_name": "気高き微笑",
        //    ; Translation usually available via read_tl.
        str += String(skill_trigger_type)
        //    "skill_trigger_type": 0,
        //    ; Trigger effect type.
        //    ; Usually 0 except on Overload, which has 1.
        str += String(skill_trigger_value)
        //    "skill_trigger_value": 0,
        //    ; This value is used by the skill's proc effect.
        str += String(skill_type)
        //    "skill_type": 17,
        str += String(value)
        return str
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(condition, forKey: "condition")
        aCoder.encodeObject(cutin_type, forKey: "cutin_type")
        
        if let x = effect_length {
            aCoder.encodeObject(x.0, forKey: "effect_length0")
            aCoder.encodeObject(x.1, forKey: "effect_length1")
        }
        
        aCoder.encodeObject(explain, forKey: "explain")
        aCoder.encodeObject(explain_en, forKey: "explain_en")
        aCoder.encodeObject(id, forKey: "id")
        //    "id": 200167,
        aCoder.encodeObject(judge_type, forKey: "judge_type")
        //    "judge_type": 1,
        if let x = proc_chance {
            aCoder.encodeObject(x.0, forKey: "proc_chance0")
            aCoder.encodeObject(x.1, forKey: "proc_chance1")
        }
        
        aCoder.encodeObject(skill_name, forKey: "skill_name")
        //    "skill_name": "気高き微笑",
        //    ; Translation usually available via read_tl.
        aCoder.encodeObject(skill_trigger_type, forKey: "skill_trigger_type")
        //    "skill_trigger_type": 0,
        //    ; Trigger effect type.
        //    ; Usually 0 except on Overload, which has 1.
        aCoder.encodeObject(skill_trigger_value, forKey: "skill_trigger_value")
        //    "skill_trigger_value": 0,
        //    ; This value is used by the skill's proc effect.
        aCoder.encodeObject(skill_type, forKey: "skill_type")
        //    "skill_type": 17,
        aCoder.encodeObject(value, forKey: "value")
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        self.condition =  aDecoder.decodeObjectForKey("condition") as? Int
        self.cutin_type =  aDecoder.decodeObjectForKey("cutin_type") as? Int
        let effect_length0 = aDecoder.decodeObjectForKey("effect_length0") as? Int
        let effect_length1 = aDecoder.decodeObjectForKey("effect_length1") as? Int
        
        self.effect_length = (effect_length0, effect_length1)
        self.explain =  aDecoder.decodeObjectForKey("explain") as? String
        self.explain_en =  aDecoder.decodeObjectForKey("explain_en") as? String
        
        self.id =  aDecoder.decodeObjectForKey("id") as? Int
        //    "id": 200167,
        self.judge_type =  aDecoder.decodeObjectForKey("judge_type") as? Int
        //    "judge_type": 1,
        let proc_chance0 = aDecoder.decodeObjectForKey("proc_chance0") as? Int
        let proc_chance1 = aDecoder.decodeObjectForKey("proc_chance1") as? Int
        self.proc_chance =  (proc_chance0, proc_chance1)
        
        self.skill_name =  aDecoder.decodeObjectForKey("skill_name") as? String
        //    "skill_name": "気高き微笑",
        //    ; Translation usually available via read_tl.
        self.skill_trigger_type =  aDecoder.decodeObjectForKey("skill_trigger_type") as? Int
        //    "skill_trigger_type": 0,
        //    ; Trigger effect type.
        //    ; Usually 0 except on Overload, which has 1.
        self.skill_trigger_value =  aDecoder.decodeObjectForKey("skill_trigger_value") as? Int
        //    "skill_trigger_value": 0,
        //    ; This value is used by the skill's proc effect.
        self.skill_type =  aDecoder.decodeObjectForKey("skill_type") as? String
        //    "skill_type": 17,
        self.value =  aDecoder.decodeObjectForKey("value") as? Int
        
    }
    //    "value": 3
    //    ; This value is used by the skill's active effect.
    //    ; For percentage-based skills like Score Bonus,
    //    ; this value is a percentage (e.g. 116).    }
}

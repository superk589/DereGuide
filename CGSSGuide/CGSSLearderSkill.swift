//
//  CGSSLearderSkill.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation


public class CGSSLeaderSkill: NSObject, NSCoding {
    //    {
    //    "result": [
    //    {
    public var explain:String?
    //    "explain": "クールアイドルのライフ20％アップ",
    //    "explain_en": "Raises the life of all Cool members by 20%.",
    public var explain_en:String?
    //    ; Machine-generated, not a direct translation.
    public var id:Int?
    //    "id": 33,
    public var name:String?
    //    "name": "クールエナジー",
    //    ; English name may be available via read_tl
    public var need_cool:Int?
    //    "need_cool": 0,
    public var need_cute:Int?
    //    "need_cute": 0,
    public var need_passion:Int?
    //    "need_passion": 0,
    public var target_attribute:String?
    //    "target_attribute": "cool",
    //    ; Member type it applies to. Any of "cute", "cool", "passion",
    //    ; "all".
    public var target_param:String?
    //    "target_param": "life",
    //    ; Card stat that gets the bonus. Any of "vocal", "visual",
    //    ; "dance", "all", "life", "skill_probability".
    public var type:Int?
    //    "type": 20,
    public var up_type:Int?
    //    "up_type": 1,
    public var up_value:Int?
    //    "up_value": 20
    //    ; Bonus percent.
    
    public init (explain:String, explain_en:String, id:Int, name:String, need_cool:Int, need_cute:Int, need_passion:Int, target_attribute:String, target_param:String, type:Int, up_type:Int, up_value:Int) {
        self.explain = explain
        self.explain_en = explain_en
        self.id = id
        self.name = name
        self.need_cool = need_cool
        self.need_cute = need_cute
        self.need_passion = need_passion
        self.target_attribute = target_attribute
        self.target_param = target_param
        self.type = type
        self.up_type = up_type
        self.up_value = up_value
    }
    public init (explain:String?, explain_en:String?, id:Int?, name:String?, need_cool:Int?, need_cute:Int?, need_passion:Int?, target_attribute:String?, target_param:String?, type:Int?, up_type:Int?, up_value:Int?) {
        self.explain = explain
        self.explain_en = explain_en
        self.id = id
        self.name = name
        self.need_cool = need_cool
        self.need_cute = need_cute
        self.need_passion = need_passion
        self.target_attribute = target_attribute
        self.target_param = target_param
        self.type = type
        self.up_type = up_type
        self.up_value = up_value
    }
    
    public convenience init?(attList:NSDictionary?){
        if let root2 = attList{
            let name = root2["name"] as? String
            let need_cool = root2["need_cool"] as? Int
            let explain = root2["explain"] as? String
            let explain_en = root2["explain_en"] as? String
            let id = root2["id"] as? Int
            
            let need_cute = root2["need_cute"] as? Int
            let need_passion = root2["need_passion"] as? Int
            let target_attribute = root2["target_attribute"] as? String
            let target_param = root2["target_param"] as? String
            let type = root2["type"] as? Int
            let up_type = root2["up_type"] as? Int
            let up_value = root2["up_value"] as? Int
            
            self.init(explain: explain, explain_en: explain_en, id: id, name: name, need_cool: need_cool, need_cute: need_cute, need_passion: need_passion, target_attribute: target_attribute, target_param: target_param, type: type, up_type: up_type, up_value: up_value)
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
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(need_cool, forKey: "need_cool")
        aCoder.encodeObject(explain, forKey: "explain")
        aCoder.encodeObject(explain_en, forKey: "explain_en")
        aCoder.encodeObject(id, forKey: "id")
        
        aCoder.encodeObject(need_cute, forKey: "need_cute")
        aCoder.encodeObject(need_passion, forKey: "need_passion")
        aCoder.encodeObject(target_attribute, forKey: "target_attribute")
        aCoder.encodeObject(target_param, forKey: "target_param")
        
        aCoder.encodeObject(type, forKey: "type")
        aCoder.encodeObject(up_type, forKey: "up_type")
        aCoder.encodeObject(up_value, forKey: "up_value")
        
    }
    public required init?(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObjectForKey("name") as? String
        need_cool = aDecoder.decodeObjectForKey("need_cool") as? Int
        explain = aDecoder.decodeObjectForKey("explain") as? String
        explain_en = aDecoder.decodeObjectForKey("explain_en") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        
        need_cute = aDecoder.decodeObjectForKey("need_cute") as? Int
        need_passion = aDecoder.decodeObjectForKey("need_passion") as? Int
        target_attribute = aDecoder.decodeObjectForKey("target_attribute") as? String
        target_param = aDecoder.decodeObjectForKey("target_param") as? String
        
        type = aDecoder.decodeObjectForKey("type") as? Int
        up_type = aDecoder.decodeObjectForKey("up_type") as? Int
        up_value = aDecoder.decodeObjectForKey("up_value") as? Int
        
    }
    
    
    
}

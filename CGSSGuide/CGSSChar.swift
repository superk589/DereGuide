//
//  CGSSChar.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

public class CGSSChar: NSObject, NSCoding {
    //    GET /api/v1/char_t/168
    //
    //    {
    //    "result": [
    //    {
    public var age:Int?
    //    "age": 20,
    //    ; If this is ridiculously high, index into category 6
    //    ; of text_data.
    public var birth_day:Int?
    //    "birth_day": 26,
    public var birth_month:Int?
    //    "birth_month": 2,
    public var blood_type:Int?
    //    "blood_type": 2002,
    //    ; Category 3 of text_data.
    public var body_size_1:Int?
    //    "body_size_1": 86,
    public var body_size_2:Int?
    //    "body_size_2": 57,
    public var body_size_3:Int?
    //    "body_size_3": 86,
    public var chara_id:Int?
    //    "chara_id": 168,
    public var constellation:Int?
    //    "constellation": 1005,
    //    ; Category 4 of text_data.
    public var conventional:String?
    //    "conventional": "Kurokawa Chiaki",
    public var favorite:String?
    //    "favorite": "クラシック鑑賞",
    public var hand:Int?
    //    "hand": 3001,
    //    ; Category 5 of text_data (subtract 3000 for index).
    public var height:Int?
    //    "height": 163,
    public var home_town:Int?
    //    "home_town": 12,
    //    ; Category 2 of text_data.
    public var kana_spaced:String?
    //    "kana_spaced": "くろかわ ちあき",
    public var kanji_spaced:String?
    //    "kanji_spaced": "黒川 千秋",
    public var model_bust_id:Int?
    //    "model_bust_id": 2,
    public var model_height_id:Int?
    //    "model_height_id": 2,
    public var model_skin_id:Int?
    //    "model_skin_id": 1,
    public var model_wight_id:Int?
    //    "model_weight_id": 0,
    public var name:String?
    //    "name": "黒川千秋",
    public var name_kana:String?
    //    "name_kana": "くろかわちあき",
    public var personality:Int?
    //    "personality": 3,
    public var spine_size:Int?
    //    "spine_size": 1,
    public var type:String?
    //    "type": "cool",
    //    ; Any of "cool", "cute", "passion", "office"
    //    ; (last one reserved for Chihiro)
    //    "valist": [],
    public var valist:NSMutableArray?
    public var voice:String?
    //    "voice": "",
    //    ; Voice actress name (Japanese)
    public var weight:Int?
    //    "weight": 45
    //    ; If this is ridiculously high, index into category 6
    //    ; of text_data.
    //    }
    //    ]
    //    }
    public init(age:Int, birth_day:Int, birth_month:Int, blood_type:Int, body_size_1:Int, body_size_2:Int, body_size_3:Int, chara_id:Int, constellation:Int, conventional:String, favorite:String, hand:Int, height:Int, home_town:Int, kana_spaced:String, kanji_spaced:String, model_bust_id:Int, model_height_id:Int, model_skin_id:Int, model_wight_id:Int, name:String, name_kana:String, personality:Int, spine_size:Int, type:String, valist:NSMutableArray?, voice:String, weight:Int) {
        self.age = age
        self.birth_day = birth_day
        self.birth_month = birth_month
        self.blood_type = blood_type
        self.body_size_1 = body_size_1
        self.body_size_2 = body_size_2
        self.body_size_3 = body_size_3
        self.chara_id = chara_id
        self.constellation = constellation
        self.conventional = conventional
        self.favorite = favorite
        self.hand = hand
        self.height = height
        self.home_town = home_town
        
        self.kana_spaced = kana_spaced
        self.kanji_spaced = kanji_spaced
        self.model_bust_id = model_bust_id
        self.model_height_id = model_height_id
        self.model_skin_id = model_skin_id
        self.model_wight_id = model_wight_id
        self.name = name
        self.name_kana = name_kana
        self.personality = personality
        self.spine_size = spine_size
        self.type = type
        self.valist = valist
        self.voice = voice
        self.weight = weight
        
    }
    public init(age:Int?, birth_day:Int?, birth_month:Int?, blood_type:Int?, body_size_1:Int?, body_size_2:Int?, body_size_3:Int?, chara_id:Int?, constellation:Int?, conventional:String?, favorite:String?, hand:Int?, height:Int?, home_town:Int?, kana_spaced:String?, kanji_spaced:String?, model_bust_id:Int?, model_height_id:Int?, model_skin_id:Int?, model_wight_id:Int?, name:String?, name_kana:String?, personality:Int?, spine_size:Int?, type:String?, valist:NSMutableArray?, voice:String?, weight:Int?) {
        self.age = age
        self.birth_day = birth_day
        self.birth_month = birth_month
        self.blood_type = blood_type
        self.body_size_1 = body_size_1
        self.body_size_2 = body_size_2
        self.body_size_3 = body_size_3
        self.chara_id = chara_id
        self.constellation = constellation
        self.conventional = conventional
        self.favorite = favorite
        self.hand = hand
        self.height = height
        self.home_town = home_town
        
        self.kana_spaced = kana_spaced
        self.kanji_spaced = kanji_spaced
        self.model_bust_id = model_bust_id
        self.model_height_id = model_height_id
        self.model_skin_id = model_skin_id
        self.model_wight_id = model_wight_id
        self.name = name
        self.name_kana = name_kana
        self.personality = personality
        self.spine_size = spine_size
        self.type = type
        self.valist = valist
        self.voice = voice
        self.weight = weight
    }
    
    public convenience init?(attList: NSDictionary?) {
        if let root2 = attList {
            
            let age = root2["age"] as? Int
            let birth_day = root2["birth_day"] as? Int
            let birth_month = root2["birth_month"] as? Int
            let blood_type = root2["blood_type"] as? Int
            let body_size_1 = root2["body_size_1"] as? Int
            let body_size_2 = root2["body_size_2"] as? Int
            let body_size_3 = root2["body_size_3"] as? Int
            let chara_id = root2["chara_id"] as? Int
            let constellation = root2["constellation"] as? Int
            let conventional = root2["conventional"] as? String
            let favorite = root2["favorite"] as? String
            let hand = root2["hand"] as? Int
            let height = root2["height"] as? Int
            let home_town = root2["home_town"] as? Int
            
            let kana_spaced = root2["kana_spaced"] as? String
            let kanji_spaced = root2["kanji_spaced"] as? String
            let model_bust_id = root2["model_bust_id"] as? Int
            let model_height_id = root2["model_height_id"] as? Int
            let model_skin_id = root2["model_skin_id"] as? Int
            let model_wight_id = root2["model_wight_id"] as? Int
            let name = root2["name"] as? String
            let name_kana = root2["name_kana"] as? String
            let personality = root2["personality"] as? Int
            let spine_size = root2["spine_size"] as? Int
            let type = root2["type"] as? String
            
            let valist:NSMutableArray? = NSMutableArray()
            if let array2 = root2["valist"] as? NSMutableArray {
                for item in array2 {
                    if let str = item as? String {
                        valist?.addObject(str)
                    }
                    
                }
            }
            let voice = root2["voice"] as? String
            let weight = root2["weight"] as? Int
            self.init(age: age, birth_day: birth_day, birth_month: birth_month, blood_type: blood_type, body_size_1: body_size_1, body_size_2: body_size_2, body_size_3: body_size_3, chara_id: chara_id, constellation: constellation, conventional: conventional, favorite: favorite, hand: hand, height: height, home_town: home_town, kana_spaced: kana_spaced, kanji_spaced: kanji_spaced, model_bust_id: model_bust_id, model_height_id: model_height_id, model_skin_id: model_skin_id, model_wight_id: model_wight_id, name: name, name_kana: name_kana, personality: personality, spine_size: spine_size, type: type, valist: valist, voice: voice, weight: weight)
            return
        }
        return nil
    }
    
    public convenience init?(jsonData:NSData) {
        let jsonObj = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
        
        if let root = jsonObj as? NSDictionary{
            if let result = root["result"] as? NSMutableArray{
                self.init(attList: result[0] as? NSDictionary)
                return
            }
        }
        return nil
        //self.init(condition: nil, cutin_type: nil, effect_length: nil, explain: nil, id: nil, judge_type: nil, proc_chance: nil, skill_name: nil, skill_trigger_type: nil, skill_trigger_value: nil, skill_type: nil, value: nil)
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(age, forKey: "age")
        aCoder.encodeObject(birth_day, forKey: "birth_day")
        aCoder.encodeObject(birth_month, forKey: "birth_month")
        aCoder.encodeObject(blood_type, forKey: "blood_type")
        aCoder.encodeObject(body_size_1, forKey: "body_size_1")
        aCoder.encodeObject(body_size_2, forKey: "body_size_2")
        aCoder.encodeObject(body_size_3, forKey: "body_size_3")
        aCoder.encodeObject(chara_id, forKey: "chara_id")
        aCoder.encodeObject(constellation, forKey: "constellation")
        aCoder.encodeObject(conventional, forKey: "conventional")
        aCoder.encodeObject(favorite, forKey: "favorite")
        aCoder.encodeObject(hand, forKey: "hand")
        aCoder.encodeObject(height, forKey: "height")
        aCoder.encodeObject(home_town, forKey: "home_town")
        
        aCoder.encodeObject(kana_spaced, forKey: "kana_spaced")
        aCoder.encodeObject(kanji_spaced, forKey: "kanji_spaced")
        aCoder.encodeObject(model_bust_id, forKey: "model_bust_id")
        aCoder.encodeObject(model_height_id, forKey: "model_height_id")
        aCoder.encodeObject(model_skin_id, forKey: "model_skin_id")
        aCoder.encodeObject(model_wight_id, forKey: "model_wight_id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(name_kana, forKey: "name_kana")
        aCoder.encodeObject(personality, forKey: "personality")
        aCoder.encodeObject(spine_size, forKey: "spine_size")
        aCoder.encodeObject(type, forKey: "type")
        
        aCoder.encodeObject(valist, forKey: "valist")
        aCoder.encodeObject(voice, forKey: "voice")
        aCoder.encodeObject(weight, forKey: "weight")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        self.age = aDecoder.decodeObjectForKey("age") as? Int
        self.birth_day = aDecoder.decodeObjectForKey("birth_day") as? Int
        self.birth_month = aDecoder.decodeObjectForKey("birth_month") as? Int
        self.blood_type = aDecoder.decodeObjectForKey("blood_type") as? Int
        self.body_size_1 = aDecoder.decodeObjectForKey("body_size_1") as? Int
        self.body_size_2 = aDecoder.decodeObjectForKey("body_size_2") as? Int
        self.body_size_3 = aDecoder.decodeObjectForKey("body_size_3") as? Int
        self.chara_id = aDecoder.decodeObjectForKey("chara_id") as? Int
        self.constellation = aDecoder.decodeObjectForKey("constellation") as? Int
        self.conventional = aDecoder.decodeObjectForKey("conventional") as? String
        self.favorite = aDecoder.decodeObjectForKey("favorite") as? String
        self.hand = aDecoder.decodeObjectForKey("hand") as? Int
        self.height = aDecoder.decodeObjectForKey("height") as? Int
        self.home_town = aDecoder.decodeObjectForKey("home_town") as? Int
        
        self.kana_spaced = aDecoder.decodeObjectForKey("kana_spaced") as? String
        self.kanji_spaced = aDecoder.decodeObjectForKey("kanji_spaced") as? String
        self.model_bust_id = aDecoder.decodeObjectForKey("model_bust_id") as? Int
        self.model_height_id = aDecoder.decodeObjectForKey("model_height_id") as? Int
        self.model_skin_id = aDecoder.decodeObjectForKey("model_skin_id") as? Int
        self.model_wight_id = aDecoder.decodeObjectForKey("model_wight_id") as? Int
        self.name = aDecoder.decodeObjectForKey("name") as? String
        self.name_kana = aDecoder.decodeObjectForKey("name_kana") as? String
        self.personality = aDecoder.decodeObjectForKey("personality") as? Int
        self.spine_size = aDecoder.decodeObjectForKey("spine_size") as? Int
        self.type = aDecoder.decodeObjectForKey("type") as? String
        
        self.valist = aDecoder.decodeObjectForKey("valist") as? NSMutableArray
        self.voice = aDecoder.decodeObjectForKey("voice") as? String
        self.weight = aDecoder.decodeObjectForKey("weight") as? Int
    }
    
}

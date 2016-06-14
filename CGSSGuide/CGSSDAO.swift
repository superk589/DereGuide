//
//  CGSSDAO.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/14.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CGSSFoundation

public class CGSSDAO: NSObject {
    public static let SkillKey = "skill"
    public static let CarDKey = "card"
    public static let CharKey = "char"
    public static let LeaderSkillKey = "leaderskill"
    public static let sharedDAO = CGSSDAO()
    
    public var skillDict:NSMutableDictionary?
    public var cardDict:NSMutableDictionary?
    public var leaderSkillDict:NSMutableDictionary?
    public var charDict:NSMutableDictionary?
    func getDataPath() -> String? {
        return NSBundle.mainBundle().pathForResource("data", ofType: "plist")
    }
    func getDictForKey(key:String) -> NSMutableDictionary? {
        switch key {
        case "skill":
            return self.skillDict
        case "card":
            return self.cardDict
        case "char":
            return self.charDict
        case "leaderskill":
            return self.leaderSkillDict
        default:
            return nil
        }
    }
    
    func loadDataFromFile(key:String) {
        if let path = getDataPath() {
            if let theData = NSData(contentsOfFile: path) {
                let achiver = NSKeyedUnarchiver(forReadingWithData: theData)
                switch key {
                case CGSSDAO.SkillKey:
                    self.skillDict = achiver.decodeObjectForKey(key) as? NSMutableDictionary
                case CGSSDAO.CarDKey:
                    self.cardDict = achiver.decodeObjectForKey(key) as? NSMutableDictionary
                case CGSSDAO.CharKey:
                    self.charDict = achiver.decodeObjectForKey(key) as? NSMutableDictionary
                case CGSSDAO.LeaderSkillKey:
                    self.leaderSkillDict = achiver.decodeObjectForKey(key) as? NSMutableDictionary
                default: break
                    //
                }
            }
        }
    }
    
    func loadAllDataFromFile() {
        loadDataFromFile(CGSSDAO.SkillKey)
        loadDataFromFile(CGSSDAO.LeaderSkillKey)
        loadDataFromFile(CGSSDAO.CharKey)
        loadDataFromFile(CGSSDAO.CarDKey)
    }
    
    private override init() {

        super.init()
        //self.getDataFromWebApi()
        
        self.loadAllDataFromFile()
        //try? initAllData()
        //checkForUpdate()
        //        for card in self.cardList!.allValues {
        //            let c = card as! CGSSCard
        //            print(c.name)
        //            print(c.album_id)
        //        }
    }
    
    public func getDataFromWebApi() {
        var x = NSHomeDirectory()
        
        var listData = NSMutableDictionary()
        var path = NSBundle.mainBundle().resourcePath! + "/data.plist"
        for i in 100000...300000 {
            if (i%100000)/300 > 0 {
                continue
            }
            print(i)
            //for i in 1...100 {

            var strURL = NSString(format: "http://starlight.hyspace.io/api/v1/skill_t/%d",i)
            //var strURL = NSString(format: "https://starlight.kirara.ca/api/v1/skill_t/%d",i)
            strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let url = NSURL(string: strURL as String)!
            let request = NSURLRequest(URL: url)
            let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)


            //data.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true)
            //    let skill1 = try CGSSSkill.init(jsonData: data)
            //    if skill1 != nil {
            //        print("\(i) 有数据")
            //        skillList.setValue(skill1, forKey: String(i))
            //    }
            if data == nil {
                continue
            }
            
            let char1 = try CGSSSkill.init(jsonData:data!)
            if char1 != nil {
                print("\(i) 有数据")
                //var str = NSString.init(data: data, encoding: NSUTF8StringEncoding)
                //try str?.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true ,encoding:NSUTF8StringEncoding)
                listData.setValue(char1!, forKey: String(i) )

            }
        }
        let theData = NSMutableData()
        let achiver = NSKeyedArchiver(forWritingWithMutableData: theData)
        achiver.encodeObject(listData, forKey: CGSSDAO.SkillKey)


        listData = NSMutableDictionary()
        for i in 0...500 {
            //            if (i%100000)/300 > 0 {
            //                continue
            //            }
            //for i in 1...100 {

            var strURL = NSString(format: "http://starlight.hyspace.io/api/v1/char_t/%d",i)
            //var strURL = NSString(format: "https://starlight.kirara.ca/api/v1/skill_t/%d",i)
            strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let url = NSURL(string: strURL as String)!
            let request = NSURLRequest(URL: url)
            let error: NSError?
            let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            if data == nil {
                continue
            }

            //data.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true)
            //    let skill1 = try CGSSSkill.init(jsonData: data)
            //    if skill1 != nil {
            //        print("\(i) 有数据")
            //        skillList.setValue(skill1, forKey: String(i))
            //    }
            let char1 = try? CGSSChar.init(jsonData:data!)
            if char1 != nil {
                print("\(i) 有数据")
                //var str = NSString.init(data: data, encoding: NSUTF8StringEncoding)
                //try str?.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true ,encoding:NSUTF8StringEncoding)
                listData.setValue(char1!, forKey: String(i) )
            }
        }

        achiver.encodeObject(listData, forKey: CGSSDAO.CharKey)


        listData = NSMutableDictionary()
        for i in 0...500 {
            //            if (i%100000)/300 > 0 {
            //                continue
            //            }
            //for i in 1...100 {

            var strURL = NSString(format: "http://starlight.hyspace.io/api/v1/leader_skill_t/%d",i)
            //var strURL = NSString(format: "https://starlight.kirara.ca/api/v1/skill_t/%d",i)
            strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let url = NSURL(string: strURL as String)!
            let request = NSURLRequest(URL: url)
            let error: NSError?
            let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            if data == nil {
                continue
            }

            //data.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true)
            //    let skill1 = try CGSSSkill.init(jsonData: data)
            //    if skill1 != nil {
            //        print("\(i) 有数据")
            //        skillList.setValue(skill1, forKey: String(i))
            //    }
            let char1 = try? CGSSLeaderSkill.init(jsonData:data!)
            if char1 != nil {
                print("\(i) 有数据")
                //var str = NSString.init(data: data, encoding: NSUTF8StringEncoding)
                //try str?.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true ,encoding:NSUTF8StringEncoding)
                listData.setValue(char1!, forKey: String(i) )
            }
        }

        achiver.encodeObject(listData, forKey: CGSSDAO.LeaderSkillKey)



        listData = NSMutableDictionary()
        for i in 100000...400000 {
            if (i%100000)/300 > 0 {
                continue
            }
            //for i in 1...100 {

            var strURL = NSString(format: "http://starlight.hyspace.io/api/v1/card_t/%d",i)
            //var strURL = NSString(format: "https://starlight.kirara.ca/api/v1/skill_t/%d",i)
            strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            let url = NSURL(string: strURL as String)!
            let request = NSURLRequest(URL: url)
            let error: NSError?
            let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            if data == nil {
                continue
            }

            //data.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true)
            //    let skill1 = try CGSSSkill.init(jsonData: data)
            //    if skill1 != nil {
            //        print("\(i) 有数据")
            //        skillList.setValue(skill1, forKey: String(i))
            //    }
            let char1 = try? CGSSCard.init(jsonData:data!)
            if char1 != nil {
                print("\(i) 有数据")
                //var str = NSString.init(data: data, encoding: NSUTF8StringEncoding)
                //try str?.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true ,encoding:NSUTF8StringEncoding)
                listData.setValue(char1!, forKey: String(i) )
            }
        }

        achiver.encodeObject(listData, forKey: CGSSDAO.CarDKey)
        achiver.finishEncoding()
        theData.writeToFile(path, atomically: true)
        theData.writeToFile("/Users/zzk" + "/Documents/" + "data.plist", atomically: true)
    
    }
    func checkForUpdate() {
        // todo
    }
    func findCharById(id:Int) -> CGSSChar? {
        if let dic = self.charDict {
            return dic.objectForKey(String(id)) as? CGSSChar
        }
        return nil
    }
    
    func findSkillById(id:Int) -> CGSSSkill? {
        if let dic = self.skillDict {
            return dic.objectForKey(String(id)) as? CGSSSkill
        }
        return nil
    }
    func findLeaderSkillById(id:Int) -> CGSSLeaderSkill? {
        if let dic = self.leaderSkillDict {
            return dic.objectForKey(String(id)) as? CGSSLeaderSkill
        }
        return nil
    }
    
    
    public func getSortedList(dic:NSMutableDictionary!, attList:[String], compare:(Int,Int)->Bool) -> NSMutableArray {
        let cList = NSMutableArray.init(array: (dic.allValues))
        cList.sort { (v1, v2) -> Bool in
            for att in attList {
                let a1 = v1.valueForKey(att) as! Int
                let a2 = v2.valueForKey(att) as! Int
                if a1 == a2 {
                    continue
                }
                else {
                    return compare(a1, a2)
                }
            }
            return false
        }
        return cList
    }
}










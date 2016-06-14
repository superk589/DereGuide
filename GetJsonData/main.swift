//
//  main.swift
//  GetJsonData
//
//  Created by zzk on 16/6/11.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation


var skillList = NSMutableDictionary()
var path = NSHomeDirectory() + "/Documents/" + CGSSDAO.LeaderSkillKey + ".plist"
//cardlist.writeToFile(path, atomically: true)
//
//var theData2 = NSData(contentsOfFile: path)!
//var achiver2 = NSKeyedUnarchiver(forReadingWithData: theData2)
//var listdata = achiver2.decodeObjectForKey("skill") as! NSMutableDictionary
//print((listdata.allValues[0] as! CGSSSkill).descroption())


//var cardlist = NSMutableArray()
//for i in 100000...400186 {
//    if (i%100000)/300 > 0 {
//        continue
//    }
for i in 1...100 {


    print(i)
    var strURL = NSString(format: "http://starlight.hyspace.io/api/v1/leader_skill_t/%d",i)
    //var strURL = NSString(format: "https://starlight.kirara.ca/api/v1/skill_t/%d",i)
    strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    let url = NSURL(string: strURL as String)!
    var request = NSURLRequest(URL: url)
    var error: NSError?
    var data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
    
    
    //data.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true)
//    let skill1 = try CGSSSkill.init(jsonData: data)
//    if skill1 != nil {
//        print("\(i) 有数据")
//        skillList.setValue(skill1, forKey: String(i))
//    }
    let char1 = try CGSSLeaderSkill.init(jsonData:data)
    if char1 != nil {
        print("\(i) 有数据")
        //var str = NSString.init(data: data, encoding: NSUTF8StringEncoding)
        //try str?.writeToFile(NSHomeDirectory() + "/Documents/" + "aaa.txt", atomically: true ,encoding:NSUTF8StringEncoding)
        skillList.setValue(char1, forKey: String(i) )
    }
}
var theData = NSMutableData()
var achiver = NSKeyedArchiver(forWritingWithMutableData: theData)
achiver.encodeObject(skillList, forKey: CGSSDAO.LeaderSkillKey)
achiver.finishEncoding()
theData.writeToFile(path, atomically: true)

//
//  main.swift
//  DownloadImageOfCard
//
//  Created by zzk on 16/6/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

//获取所有偶像的大图
for i in 0...9 {
    var strURL = NSString(format: "https://hoshimoriuta.kirara.ca/icons2/icons_" + String(i)  + "@2x.jpg")

    strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    let url = NSURL(string: strURL as String)!
    var request = NSURLRequest(URL: url)
    var error: NSError?
    var data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
    let toPath = NSHomeDirectory() + "/Documents/" + String(i) + ".jpg"
    data.writeToFile(toPath, atomically: true)

}



//
//var strURL = "http://imascg-slstage-wiki.gamerch.com/"
//
//
//
//let path = NSHomeDirectory() + "/Documents/" + "Card.plist"
//let storePath = NSHomeDirectory() + "/Documents/"
//
//let cardDict = NSDictionary.init(contentsOfFile: path)
//
//
//for (k,v) in cardDict! {
//    let url = NSURL(string: strURL + (k as! String))
//    
//    var request = NSURLRequest(URL: url!)
//    var error: NSError?
//    var data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
//
//    var resDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
//
//
//print(resDict)
//
//}


//获取所有偶像的小图标
//for i in 0...9 {
//    var strURL = NSString(format: "https://hoshimoriuta.kirara.ca/icons2/icons_" + String(i)  + "@2x.jpg")
//    
//    strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//    let url = NSURL(string: strURL as String)!
//    var request = NSURLRequest(URL: url)
//    var error: NSError?
//    var data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
//    let toPath = NSHomeDirectory() + "/Documents/" + String(i) + ".jpg"
//    data.writeToFile(toPath, atomically: true)
//
//}

//
////获取css解析小图标位置
//func getStringByPattern(str:String, pattern:String) -> [NSString] {
//    let regex = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive )
//    let res = regex!.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
//    var arr = Array<NSString>()
//    for checkingRes in res {
//       
//        arr.append((str as NSString).substringWithRange(checkingRes.range))
//        
//    }
//    return arr
//}
//
//var strURL = NSString(format: "https://hoshimoriuta.kirara.ca/icons2/icons@2x.css")
//
//    strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//    let url = NSURL(string: strURL as String)!
//    var request = NSURLRequest(URL: url)
//
//    var error: NSError?
//    var data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
//var s = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
//
//let pattern = "100185\\{([^\\{]*)\\}"
//let s1 = getStringByPattern(s, pattern: pattern).first as? String
//if let s2 = s1 {
//    let file_name = getStringByPattern(s2, pattern: "icons_[0-9]+@2x.jpg").first
//    let urlx = getStringByPattern(s2, pattern: "icons[^\"]+").first
//    
//    
//    let arr = getStringByPattern(s2, pattern: "[0-9]+px")
//    var arr2 = [Int]()
//    for str in arr {
//        let integer = str.stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: "px"))
//        print(integer)
//        arr2.append(Int(integer)!)
//    }
//    print( arr2)
//}
//
//
//
//
//let toPath = NSHomeDirectory() + "/Documents/" + "x" + ".jpg"
//data.writeToFile(toPath, atomically: true)
//
//
//
//
//
//
//
//
//

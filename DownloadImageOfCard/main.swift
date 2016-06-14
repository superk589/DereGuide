//
//  main.swift
//  DownloadImageOfCard
//
//  Created by zzk on 16/6/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
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
var strURL = NSString(format: "https://hoshimoriuta.kirara.ca/chara2/162/3.png")

    strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    let url = NSURL(string: strURL as String)!
    var request = NSURLRequest(URL: url)
    var error: NSError?
    var data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
    let toPath = NSHomeDirectory() + "/Documents/" + "200167" + ".png"
    data.writeToFile(toPath, atomically: true)


//
//  main.swift
//  ReadFileToPlist
//
//  Created by zzk on 16/6/3.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
//打开文件

let manager = NSFileManager.defaultManager()
let fileNames = ["CenterSkill", "SpecialSkill", "Card"]

for fileName in fileNames {
    let fromPath = NSHomeDirectory() + "/Documents/" + fileName + ".txt"
    let toPath = NSHomeDirectory() + "/Documents/" + fileName + ".plist"
    let readHandler = NSFileHandle(forReadingAtPath: fromPath)!
    let data = readHandler.readDataToEndOfFile()
    let readString = NSString(data: data, encoding: NSUTF8StringEncoding)
    let lines = readString?.componentsSeparatedByString("\n")
    
    var dic = NSMutableDictionary()
    for line in lines! {
        let temp = line.componentsSeparatedByString("\t")
        var subDic = NSMutableDictionary()
        switch fileName {
        case "CardIconIndex" :
            if let i = Int(temp[2]) {
                subDic["iconIndex"] = i
            }
            else {
                subDic["iconIndex"] = 0
            }
            dic[temp[1]] = subDic
            
        case "CenterSkill" :
            subDic["skillName"] = temp[2]
            subDic["skillDesc"] = temp[3]
            dic[temp[0]] = subDic
        case "SpecialSkill" :
            subDic["skillType"] = temp[3]
            subDic["skillDesc"] = temp[4]
            dic[temp[0]] = subDic
        case "Card" :
            subDic["cardNo"] = temp[0]
            subDic["cardRare"] = temp[3]
            subDic["characterName"] = temp[4]
            subDic["iconIndex"] = 1
            dic[temp[1]] = subDic
        default : break
        }
    }

    dic.writeToFile(toPath, atomically: true)
}


let fileNames2 = ["CardValue_SSR", "CardValue_SSR+", "CardValue_SR", "CardValue_SR+"]

for fileName in fileNames2 {
    let fromPath = NSHomeDirectory() + "/Documents/" + fileName + ".txt"
    let toPath = NSHomeDirectory() + "/Documents/" + "Card.plist"
    let readHandler = NSFileHandle(forReadingAtPath: fromPath)!
    let data = readHandler.readDataToEndOfFile()
    let readString = NSString(data: data, encoding: NSUTF8StringEncoding)
    let lines = readString?.componentsSeparatedByString("\n")
    
    var dic = NSMutableDictionary(contentsOfFile: toPath)!
    for line in lines! {
        let temp = line.componentsSeparatedByString("\t")
        if var subDic:NSMutableDictionary = dic[temp[0]] as? NSMutableDictionary {
            subDic["life"] = temp[1]
            subDic["vocal"] = temp[2]
            subDic["dance"] = temp[3]
            subDic["visual"] = temp[4]
            dic[temp[0]] = subDic
        }
               
    }
    
    dic.writeToFile(toPath, atomically: true)
}


let fileNames3 = ["CardIconIndex"]

for fileName in fileNames3 {
    let fromPath = NSHomeDirectory() + "/Documents/" + fileName + ".txt"
    let toPath = NSHomeDirectory() + "/Documents/" + "Card.plist"
    let readHandler = NSFileHandle(forReadingAtPath: fromPath)!
    let data = readHandler.readDataToEndOfFile()
    let readString = NSString(data: data, encoding: NSUTF8StringEncoding)
    let lines = readString?.componentsSeparatedByString("\n")
    
    var dic = NSMutableDictionary(contentsOfFile: toPath)!
    for line in lines! {
        let temp = line.componentsSeparatedByString("\t")
        if var subDic:NSMutableDictionary = dic[temp[1]] as? NSMutableDictionary {
            if let i = Int(temp[2]) {
                subDic["iconIndex"] = i
            }
            else {
                subDic["iconIndex"] = 0
            }
            dic[temp[1]] = subDic
        }
        
    }
    
    dic.writeToFile(toPath, atomically: true)
}



/*
let fromPath = NSHomeDirectory() + "/Documents/" + "Card.txt"
let toPath = NSHomeDirectory() + "/Documents/" + "CardByNo.plist"
let readHandler = NSFileHandle(forReadingAtPath: fromPath)!
let data = readHandler.readDataToEndOfFile()
let readString = NSString(data: data, encoding: NSUTF8StringEncoding)
let lines = readString?.componentsSeparatedByString("\n")

var arrayOfCard = Array<Dictionary<String,String>>()
for line in lines! {
    let temp = line.componentsSeparatedByString("\t")
    var subDic = Dictionary<String,String>()
    subDic["cardRare"] = temp[3]
    subDic["characterName"] = temp[4]
    subDic["cardName"] = temp[1]
    arrayOfCard.append(subDic)
}
let nsarray = NSArray.init(array: arrayOfCard)
nsarray.writeToFile(toPath, atomically: true)
*/


//
//  BeatmapHashManager.swift
//  CGSSGuide
//
//  Created by zzk on 2017/2/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class BeatmapHashManager {
    
    var path = NSHomeDirectory() + "/Documents/beatmapHash.plist"

    static let `default` = BeatmapHashManager()
    
    private init() {
        if let array = NSDictionary.init(contentsOfFile: path) as? [Int: String] {
            hashTable = array
        } else {
            hashTable = [Int: String]()
        }
    }
    
    var hashTable: [Int: String] {
        didSet {
            (hashTable as NSDictionary).write(toFile: path, atomically: true)
        }
    }
    
}

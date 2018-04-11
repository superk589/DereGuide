//
//  BeatmapHashManager.swift
//  DereGuide
//
//  Created by zzk on 2017/2/14.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class BeatmapHashManager {
    
    var path = Path.cache + "/beatmapHash.plist"

    static let `default` = BeatmapHashManager()
    
    private init() {
        if let array = NSDictionary.init(contentsOfFile: path) as? [String: String] {
            hashTable = array
        } else {
            hashTable = [String: String]()
        }
    }
    
    var hashTable: [String: String] {
        didSet {
            (hashTable as NSDictionary).write(toFile: path, atomically: true)
        }
    }
    
}

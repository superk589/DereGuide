//
//  CGSSTeamManager.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSTeamManager {

    var teams:[CGSSTeam] {
        didSet {
            save()
        }
    }
    
    static let `default` = CGSSTeamManager()
    static let filePath = NSHomeDirectory() + "/Documents/teams.plist"

    init() {
        if let theData = try? Data(contentsOf: URL(fileURLWithPath: CGSSTeamManager.filePath)) {
            let achiver = NSKeyedUnarchiver(forReadingWith: theData)
            self.teams = achiver.decodeObject(forKey: "team") as? [CGSSTeam] ?? [CGSSTeam]()
        } else {
            self.teams = [CGSSTeam]()
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .userInitiated).async {
            let path = CGSSTeamManager.filePath
            let theData = NSMutableData()
            let achiver = NSKeyedArchiver(forWritingWith: theData)
            achiver.encode(self.teams , forKey: "team")
            achiver.finishEncoding()
            theData.write(toFile: path, atomically: true)
        }
    }
}

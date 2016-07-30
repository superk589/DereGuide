//
//  CGSSTeamManager.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSTeamManager: NSObject {

    var teams:[CGSSTeam]!
    static let defaultManager = CGSSTeamManager()
    static let teamsFilePath = NSHomeDirectory()+"/Documents/teams.plist"

    
    override init() {
        super.init()
        initTeams()
    }
    
    func initTeams() {
        if let theData = NSData(contentsOfFile: CGSSTeamManager.teamsFilePath) {
            let achiver = NSKeyedUnarchiver(forReadingWithData: theData)
                self.teams = achiver.decodeObjectForKey("team") as? [CGSSTeam] ?? [CGSSTeam]()
        } else {
            self.teams = [CGSSTeam]()
        }
    }
    func writeToFile(complete:(()->Void)?) {
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            let path = CGSSTeamManager.teamsFilePath
            let theData = NSMutableData()
            let achiver = NSKeyedArchiver(forWritingWithMutableData: theData)
            achiver.encodeObject(self.teams , forKey: "team")
            achiver.finishEncoding()
            theData.writeToFile(path, atomically: true)
            dispatch_async(dispatch_get_main_queue(), {
                complete?()
            })
        }
    }
    
    func addATeam(team:CGSSTeam) {
        teams.append(team)
        writeToFile(nil)
    }
    
    func removeATeam(index:Int) {
        teams.removeAtIndex(index)
        writeToFile(nil)
    }
    func getTeamByIndex(index:Int) -> CGSSTeam {
        return self.teams[index]
    }
 
}

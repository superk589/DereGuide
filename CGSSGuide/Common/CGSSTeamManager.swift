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
        if let theData = try? Data(contentsOf: URL(fileURLWithPath: CGSSTeamManager.teamsFilePath)) {
            let achiver = NSKeyedUnarchiver(forReadingWith: theData)
                self.teams = achiver.decodeObject(forKey: "team") as? [CGSSTeam] ?? [CGSSTeam]()
        } else {
            self.teams = [CGSSTeam]()
        }
    }
    func writeToFile(_ complete:(()->Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            let path = CGSSTeamManager.teamsFilePath
            let theData = NSMutableData()
            let achiver = NSKeyedArchiver(forWritingWith: theData)
            achiver.encode(self.teams , forKey: "team")
            achiver.finishEncoding()
            theData.write(toFile: path, atomically: true)
            DispatchQueue.main.async(execute: {
                complete?()
            })
        }
    }
    
    func addATeam(_ team:CGSSTeam) {
        addATeam(team, complete: nil)
    }
    fileprivate func addATeam(_ team:CGSSTeam, complete:(()->Void)?) {
        teams.insert(team, at: 0)
        writeToFile(complete)
    }
    func removeATeamAtIndex(_ index:Int) {
        removeATeamAtIndex(index, complete: nil)
    }
    fileprivate func removeATeamAtIndex(_ index:Int, complete:(()->Void)?) {
        teams.remove(at: index)
        writeToFile(complete)
    }
    fileprivate func removeATeam(_ team:CGSSTeam, complete:(()->Void)?) {
        if let index = teams.index(of: team) {
            teams.remove(at: index)
            writeToFile(complete)
        }
    }
    func removeATeam(_ team:CGSSTeam) {
        removeATeam(team, complete: nil)
    }
    func getTeamByIndex(_ index:Int) -> CGSSTeam {
        return self.teams[index]
    }
 
}

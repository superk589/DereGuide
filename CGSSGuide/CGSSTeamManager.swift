//
//  CGSSTeamManager.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSTeamManager: NSObject {

    var teams:[CGSSTeam]! {
        didSet {
            writeFavoriteCardsToFile()
        }
    }

    static let defaultManager = CGSSTeamManager()
    static let teamsFilePath = NSHomeDirectory()+"/Documents/teams.plist"

    
    override init() {
        super.init()
        initTeams()
    }
    
    func initTeams() {
        teams = [CGSSTeam]()
        let arr = NSArray.init(contentsOfFile: CGSSTeamManager.teamsFilePath) as? [[[Int]]] ?? [[[Int]]]()
        for teamArr in arr {
            let team = CGSSTeam.init(members: teamArr[0], skills: teamArr[1])
            teams.append(team)
        }
    }
    func writeFavoriteCardsToFile() {
        var arr = [[[Int]]]()
        for team in teams {
            arr.append([team.members, team.skills])
        }
        
        (arr as NSArray).writeToFile(CGSSTeamManager.teamsFilePath, atomically: true)
    }
    
    func addATeam(team:CGSSTeam) {
        teams.append(team)
    }
    
    func removeATeam(index:Int) {
        teams.removeAtIndex(index)
        
    }
}

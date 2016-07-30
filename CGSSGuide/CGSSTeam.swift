//
//  CGSSTeam.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSTeam: NSObject, NSCoding {
    var leader: CGSSTeamMember!
    var subs: [CGSSTeamMember]!
    //队伍总表现值
    var teamPresentValue:Int? {
        return 0
    }
    var teamVocal:Int? {
        return 0
    }
    var teamDance:Int? {
        return 0
    }
    var teamVisual:Int? {
        return 0
    }
    var teamBackSupportValue:Int?
    
    init(leader:CGSSTeamMember, subs:[CGSSTeamMember], teamBackSupportValue:Int) {
        self.leader = leader
        self.subs = subs
        self.teamBackSupportValue = teamBackSupportValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.leader = aDecoder.decodeObjectForKey("leader") as? CGSSTeamMember
        self.subs = aDecoder.decodeObjectForKey("subs") as? [CGSSTeamMember]
        self.teamBackSupportValue = aDecoder.decodeObjectForKey("teamBackSupportValue") as? Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(leader, forKey: "leader")
        aCoder.encodeObject(subs, forKey: "subs")
        aCoder.encodeObject(teamBackSupportValue, forKey: "teamBackSupportValue")
    }
   
}

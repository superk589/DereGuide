//
//  CGSSTeam.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSTeam {
    var members:[Int]!
    var skills:[Int]!
    
    var teamPresentValue:Int?
    var teamBackSupportValue:Int?
    
    
    var teamLeader: CGSSCard? {
        if members[0] > 0 {
            return CGSSDAO.sharedDAO.findCardById(members[0])
        }
        return nil
    }
    
    init(members:[Int], skills:[Int]) {
        self.members = members
        self.skills = skills
    }
    convenience init() {
        let members = [Int].init(count: 0, repeatedValue: 5)
        let skills = [Int].init(count: 1, repeatedValue: 5)
        self.init(members: members, skills: skills)
    }
   
}

//
//  CGSSTeamMember.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSTeamMember: NSObject, NSCoding {
    var id:Int?
    var skillLevel:Int?
    var cardRef: CGSSCard? {
        let dao = CGSSDAO.sharedDAO
        return dao.findCardById(id!)
    }
    init(id:Int, skillLevel:Int) {
        self.id = id
        self.skillLevel = skillLevel
    }
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as? Int
        self.skillLevel = aDecoder.decodeObjectForKey("skillLevel") as? Int
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(skillLevel, forKey: "skillLevel")
    }
}

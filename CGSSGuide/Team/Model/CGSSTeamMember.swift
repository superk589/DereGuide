//
//  CGSSTeamMember.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

enum CGSSTeamMemberType {
	case leader
	case sub
	case friend
}

extension CGSSTeamMember {
    
}

class CGSSTeamMember: NSObject, NSCoding {
	var id: Int?
	var skillLevel: Int?
    var vocalLevel: Int?
    var danceLevel: Int?
    var visualLevel:Int?
	var cardRef: CGSSCard? {
		let dao = CGSSDAO.sharedDAO
		return dao.findCardById(id!)
	}
    init(id: Int, skillLevel: Int, vocalLevel:Int = 0, danceLevel:Int = 0 ,visualLevel:Int = 0) {
		self.id = id
		self.skillLevel = skillLevel
        self.vocalLevel = vocalLevel
        self.danceLevel = danceLevel
        self.visualLevel = visualLevel
	}
	required init?(coder aDecoder: NSCoder) {
		self.id = aDecoder.decodeObject(forKey: "id") as? Int
		self.skillLevel = aDecoder.decodeObject(forKey: "skillLevel") as? Int
        self.vocalLevel = aDecoder.decodeObject(forKey: "vocalLevel") as? Int ?? 0
        self.danceLevel = aDecoder.decodeObject(forKey: "danceLevel") as? Int ?? 0
        self.visualLevel = aDecoder.decodeObject(forKey: "visualLevel") as? Int ?? 0
	}
	func encode(with aCoder: NSCoder) {
		aCoder.encode(id, forKey: "id")
		aCoder.encode(skillLevel, forKey: "skillLevel")
        aCoder.encode(vocalLevel, forKey: "vocalLevel")
        aCoder.encode(danceLevel, forKey: "danceLevel")
        aCoder.encode(visualLevel, forKey: "visualLevel")
	}
}

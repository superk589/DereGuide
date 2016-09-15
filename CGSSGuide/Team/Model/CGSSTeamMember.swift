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

class CGSSTeamMember: NSObject, NSCoding {
	var id: Int?
	var skillLevel: Int?
	var cardRef: CGSSCard? {
		let dao = CGSSDAO.sharedDAO
		return dao.findCardById(id!)
	}
	init(id: Int, skillLevel: Int) {
		self.id = id
		self.skillLevel = skillLevel
	}
	required init?(coder aDecoder: NSCoder) {
		self.id = aDecoder.decodeObject(forKey: "id") as? Int
		self.skillLevel = aDecoder.decodeObject(forKey: "skillLevel") as? Int
	}
	func encode(with aCoder: NSCoder) {
		aCoder.encode(id, forKey: "id")
		aCoder.encode(skillLevel, forKey: "skillLevel")
	}
}

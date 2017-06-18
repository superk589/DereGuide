//
//  CGSSTeamMember.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

enum CGSSTeamMemberType: CustomStringConvertible {
	case leader
	case sub(Int)
	case friend
    
    init(index: Int) {
        switch index {
        case 0:
            self = .leader
        case 1...4:
            self = .sub(index)
        case 5:
            self = .friend
        default:
            fatalError()
        }
    }
    
    var description: String {
        switch self {
        case .leader:
            return NSLocalizedString("队长", comment: "")
        case .sub(let index):
            return NSLocalizedString("队员", comment: "") + "\(index)"
        case .friend:
            return NSLocalizedString("好友", comment: "")
        }
    }
}

extension CGSSTeamMember {
    var potential: CGSSPotential {
        return CGSSPotential(vocalLevel: vocalLevel ?? 0, danceLevel: danceLevel ?? 0, visualLevel: visualLevel ?? 0, lifeLevel: 0)
    }
}

class CGSSTeamMember: NSObject, NSCoding {
	var id: Int?
	var skillLevel: Int?
    var vocalLevel: Int?
    var danceLevel: Int?
    var visualLevel:Int?
	var cardRef: CGSSCard? {
		let dao = CGSSDAO.shared
		return dao.findCardById(id!)
	}
    
    init(id: Int, skillLevel: Int, vocalLevel:Int = 0, danceLevel:Int = 0 ,visualLevel:Int = 0) {
		self.id = id
		self.skillLevel = skillLevel
        self.vocalLevel = vocalLevel
        self.danceLevel = danceLevel
        self.visualLevel = visualLevel
	}
    
    convenience init (id: Int, skillLevel: Int, potential: CGSSPotential) {
        self.init(id: id, skillLevel: skillLevel, vocalLevel: potential.vocalLevel, danceLevel: potential.danceLevel, visualLevel: potential.visualLevel)
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

    class func initWithAnother(teamMember: CGSSTeamMember) -> CGSSTeamMember {
        let model = CGSSTeamMember.init(id: teamMember.id!, skillLevel: teamMember.skillLevel!, vocalLevel: teamMember.vocalLevel!, danceLevel: teamMember.danceLevel!, visualLevel: teamMember.visualLevel!)
        return model
    }
}

extension CGSSTeamMember {
    static func ==(lhs: CGSSTeamMember, rhs: CGSSTeamMember) -> Bool {
        if let lCard = lhs.cardRef, let rCard = rhs.cardRef {
            if lCard.id == rCard.id && lhs.potential == rhs.potential {
                return true
            }
        }
        return false
    }
}

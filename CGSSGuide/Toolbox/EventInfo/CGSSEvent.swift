//
//  CGSSEvent.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

extension CGSSEvent {
    var eventType: CGSSEventTypes {
        return CGSSEventTypes.init(eventType: type)
    }
    dynamic var updateDate: Date {
        return startDate.toDate()
    }
}

class CGSSEvent: CGSSBaseModel {
    var id:Int
    var type:Int
    var startDate:String
    var endDate:String
    var name:String
    var secondHalfStartDate:String
    
    var reward:[Reward]
    
    init(id:Int, type:Int, startDate:String, endDate:String, name:String, secondHalfStartDate:String, reward:[Reward]) {
        self.id = id
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
        self.secondHalfStartDate = secondHalfStartDate
        self.reward = reward
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

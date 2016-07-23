//
//  CGSSBeatmap.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

public class CGSSBeatmap: CGSSBaseModel{
    class Note {
        var id:Int?
        var sec:Int?
        var type:Int?
        var startPos:Int?
        var finishPos:Int?
        var status:Int?
        var sync:Int?
        var groupId:Int?
    }
    var notes:NSMutableArray?
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.notes = aDecoder.decodeObjectForKey("notes") as? NSMutableArray
    }
    override public func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.notes, forKey: "notes")
    }
    init(json:JSON) {
        let array = json.arrayValue
        for sub in array {
            let note = Note()
            note.id = sub["id"].intValue
            note.sec = sub["sec"].intValue
            note.type = sub["type"].intValue
            note.startPos = sub["startPos"].intValue
            note.finishPos = sub["finishPos"].intValue
            note.status = sub["status"].intValue
            note.sync = sub["sync"].intValue
            note.groupId = sub["groupId"].intValue
            self.notes?.addObject(note)
        }
        super.init()
    }
    
}

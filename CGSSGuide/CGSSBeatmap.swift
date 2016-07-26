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
    class Note: NSObject, NSCoding {
        var id:Int?
        var sec:Float?
        var type:Int?
        var startPos:Int?
        var finishPos:Int?
        var status:Int?
        var sync:Int?
        var groupId:Int?
        override init() {
            super.init()
        }
        required init?(coder aDecoder: NSCoder) {
            self.id = aDecoder.decodeObjectForKey("id") as? Int
            self.sec = aDecoder.decodeObjectForKey("sec") as? Float
            self.type = aDecoder.decodeObjectForKey("type") as? Int
            self.startPos = aDecoder.decodeObjectForKey("startPos") as? Int
            self.finishPos = aDecoder.decodeObjectForKey("finishPos") as? Int
            self.status = aDecoder.decodeObjectForKey("status") as? Int
            self.sync = aDecoder.decodeObjectForKey("sync") as? Int
            self.groupId = aDecoder.decodeObjectForKey("groupId") as? Int
        }
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(self.id, forKey: "id")
            aCoder.encodeObject(self.sec, forKey: "sec")
            aCoder.encodeObject(self.type, forKey: "type")
            aCoder.encodeObject(self.startPos, forKey: "startPos")
            aCoder.encodeObject(self.finishPos, forKey: "finishPos")
            aCoder.encodeObject(self.status, forKey: "status")
            aCoder.encodeObject(self.sync, forKey: "sync")
            aCoder.encodeObject(self.groupId, forKey: "groupId")
        }
    }
    var notes:[Note]

    var numberOfNotes:Int {
        if let note = notes.first {
            return note.status ?? 0
        }
        return 0
    }
    
    var firstNote:Note? {
        for i in 0...notes.count - 1 {
            if notes[i].finishPos != 0 {
                return notes[i]
            }
        }
        return nil
    }
    
    var lastNote:Note? {
        for i in 0...notes.count - 1 {
            if notes[notes.count - i - 1].finishPos != 0 {
                return notes[notes.count - i - 1]
            }
        }
        return nil
    }
    
    var preSeconds:Float? {
        return firstNote?.sec
    }
    var postSeconds:Float? {
        return lastNote?.sec
    }
    var totalSeconds:Float {
        return notes.last!.sec!
    }
    
    var validSeconds:Float {
        return postSeconds! - preSeconds!
    }
        
    required public init?(coder aDecoder: NSCoder) {
        self.notes = aDecoder.decodeObjectForKey("notes") as? [Note] ?? [Note]()
        super.init(coder: aDecoder)
        
    }
    override public func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.notes, forKey: "notes")
    }
    init(json:JSON) {
        self.notes = [Note]()
        let array = json.arrayValue
        for sub in array {
            let note = Note()
            note.id = sub["id"].intValue
            note.sec = sub["sec"].floatValue
            note.type = sub["type"].intValue
            note.startPos = sub["startPos"].intValue
            note.finishPos = sub["finishPos"].intValue
            note.status = sub["status"].intValue
            note.sync = sub["sync"].intValue
            note.groupId = sub["groupId"].intValue
            self.notes.append(note)
        }
        super.init()
    }
    
    
    
}

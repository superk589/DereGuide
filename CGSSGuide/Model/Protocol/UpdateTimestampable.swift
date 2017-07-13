//
//  UpdateTimestampable.swift
//  Moody
//
//  Created by Florian on 25/08/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import Foundation
import CoreData

let UpdateTimestampKey = "updatedAt"

protocol UpdateTimestampable: class {
    var updatedAt: Date { get set }
    func refreshUpdateDate()
}

extension UpdateTimestampable where Self: NSManagedObject {
    
    func refreshUpdateDate() {
        // avoid cycle changing
        guard changedValue(forKey: UpdateTimestampKey) == nil else { return }
        updatedAt = Date()
    }
    
}

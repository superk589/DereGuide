//
//  UnitsRemote.swift
//  CGSSGuide
//
//  Created by Florian on 21/09/15.
//  Copyright © 2015 objc.io. All rights reserved.
//

import CloudKit

final class UnitsRemote: Remote {

    typealias R = RemoteUnit
    typealias L = Unit
    
    static let subscriptionID: String = "My Units"
}

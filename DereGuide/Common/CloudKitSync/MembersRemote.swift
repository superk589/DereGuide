//
//  MembersRemote.swift
//  DereGuide
//
//  Created by zzk on 2017/7/14.
//  Copyright © 2017 zzk. All rights reserved.
//

import CloudKit

final class MembersRemote: Remote {
    
    static let subscriptionID: String = "My Members"

    typealias R = RemoteMember
    typealias L = Member
    
}

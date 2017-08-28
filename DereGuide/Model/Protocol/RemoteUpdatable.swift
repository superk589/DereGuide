//
//  RemoteUpdatable.swift
//  DereGuide
//
//  Created by zzk on 2017/7/22.
//  Copyright © 2017年 zzk. All rights reserved.
//

import CoreData

/// can be updated from remote
protocol RemoteUpdatable {
    associatedtype R: RemoteRecord
    func update(using remoteRecord: R)
}

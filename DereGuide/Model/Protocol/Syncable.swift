//
//  Syncable.swift
//  DereGuide
//
//  Created by zzk on 2017/8/1.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

protocol Syncable: RemoteUpdatable, RemoteUploadable, RemoteDeletable, DelayedDeletable, RemoteRefreshable {
    
}

extension Syncable {
    
}

//
//  BaseSession.swift
//  DereGuide
//
//  Created by zzk on 2017/1/25.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation

class BaseSession {
    
    static let shared = BaseSession()
    var session: URLSession!
    
    private init() {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 30
        session = URLSession.init(configuration: config)
    }
    
}


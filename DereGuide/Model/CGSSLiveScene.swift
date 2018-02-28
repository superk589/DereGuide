//
//  CGSSLiveScene.swift
//  DereGuide
//
//  Created by zzk on 2017/5/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
struct CGSSLiveScene {
    
    var live: CGSSLive
    var difficulty: CGSSLiveDifficulty
    
}

extension CGSSLiveScene {
    
    var beatmap: CGSSBeatmap? {
        return live.getBeatmap(of: difficulty)
    }
    
    var stars: Int {
        return live.getLiveDetail(of: difficulty)?.stars ?? 0
    }
    
    var sRankScore: Int {
        return live.getLiveDetail(of: difficulty)?.rankSCondition ?? 0
    }
}

//
//  SongDetailLiveDifficultyView.swift
//  DereGuide
//
//  Created by zzk on 05/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class SongDetailLiveDifficultyView: LiveDifficultyView {
    
    private var shouldShowText: Bool = true
    
    func setup(liveDetail: CGSSLiveDetail, shouldShowText: Bool = true) {
        let color = backgoundView.zk.backgroundColor
        backgoundView.zk.backgroundColor = liveDetail.difficulty.color
        
        if color != backgoundView.zk.backgroundColor {
            backgoundView.image = nil
            backgoundView.render()
        }
        
        self.shouldShowText = shouldShowText
        
        if shouldShowText {
            label.text = liveDetail.difficulty.description + " \(liveDetail.stars)"
        } else {
            label.text = "\(liveDetail.stars)"
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        label.sizeToFit()
        var frame = label.bounds
        frame.size.width += 10
        frame.size.height = 33
        if !shouldShowText {
            let suitableWidth = UIDevice.current.userInterfaceIdiom == .pad ? floor((min(768, Screen.shortSide) - 156) / 7) : floor((Screen.shortSide - 136) / 5)
            frame.size.width = suitableWidth
        }
        return frame.size
    }

}

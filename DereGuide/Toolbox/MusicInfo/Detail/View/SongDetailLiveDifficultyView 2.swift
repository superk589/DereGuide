//
//  SongDetailLiveDifficultyView.swift
//  DereGuide
//
//  Created by zzk on 05/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class SongDetailLiveDifficultyView: LiveDifficultyView {
    
    var difficulty: CGSSLiveDifficulty?

    func setup(difficulty: CGSSLiveDifficulty, stars: Int?) {
        self.difficulty = difficulty
        let color = backgoundView.zk.backgroundColor
        backgoundView.zk.backgroundColor = difficulty.color
        
        if color != backgoundView.zk.backgroundColor {
            backgoundView.image = nil
            backgoundView.render()
        }
        if let stars = stars {
            label.text = difficulty.description + " \(stars)"
        } else {
            label.text = difficulty.description
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        label.sizeToFit()
        var frame = label.bounds
        frame.size.width += 10
        frame.size.height = 33
        return frame.size
    }

}

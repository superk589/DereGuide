//
//  LiveTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class LiveTableViewController: BaseLiveTableViewController {

    override func selectScene(_ scene: CGSSLiveScene) {
        super.selectScene(scene)
        let vc = BeatmapViewController()
        vc.setup(with: scene)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



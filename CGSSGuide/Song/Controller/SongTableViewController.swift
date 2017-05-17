//
//  SongTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class SongTableViewController: BaseSongTableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func selectLive(_ live: CGSSLive, beatmap: CGSSBeatmap, difficulty: CGSSLiveDifficulty) {
        super.selectLive(live, beatmap: beatmap, difficulty: difficulty)
        let vc = BeatmapViewController()
        vc.setup(with: live, difficulty: difficulty)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}



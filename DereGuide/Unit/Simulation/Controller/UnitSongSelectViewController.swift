//
//  UnitSongSelectViewController.swift
//  DereGuide
//
//  Created by zzk on 16/8/7.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class UnitSongSelectViewController: BaseLiveTableViewController {
    
    override var filter: CGSSLiveFilter {
        get {
            return CGSSSorterFilterManager.default.unitLiveFilter
        }
        set {
            CGSSSorterFilterManager.default.unitLiveFilter = newValue
        }
    }
    
    override var sorter: CGSSSorter {
        get {
            return CGSSSorterFilterManager.default.unitLiveSorter
        }
        set {
            CGSSSorterFilterManager.default.unitLiveSorter = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = leftItem
        // Do any additional setup after loading the view.
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func selectScene(_ scene: CGSSLiveScene) {
        super.selectScene(scene)
        navigationController?.popViewController(animated: true)
    }
    
    override func doneAndReturn(filter: CGSSLiveFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.unitLiveFilter = filter
        CGSSSorterFilterManager.default.unitLiveSorter = sorter
        CGSSSorterFilterManager.default.saveForUnitLive()
        updateUI()
    }
    
    override func liveTableViewCell(_ liveTableViewCell: LiveTableViewCell, didSelect jacketImageView: BannerView, musicDataID: Int) {
        // do nothing
    }
}

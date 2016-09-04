//
//  TeamSongSelectViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamSongSelectViewController: BaseSongTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .Plain, target: self, action: #selector(tbBack))

        toolbarItems = [backItem]
        
        // Do any additional setup after loading the view.
    }
    
    func tbBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func selectLive(live: CGSSLive, beatmaps: [CGSSBeatmap], diff: Int) {
        super.selectLive(live, beatmaps: beatmaps, diff: diff)
        navigationController?.popViewControllerAnimated(true)
    }
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

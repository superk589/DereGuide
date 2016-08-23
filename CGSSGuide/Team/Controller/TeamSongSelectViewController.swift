//
//  TeamSongSelectViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamSongSelectViewController: BaseSongTableViewController {
    
    var tb: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        tb = UIToolbar.init(frame: CGRectMake(0, CGSSGlobal.height - 40, CGSSGlobal.width, 40))
        tableView.tableFooterView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 40))
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .Plain, target: self, action: #selector(tbBack))
        tb.items = [backItem]
        
        // Do any additional setup after loading the view.
    }
    
    func tbBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let superview = tableView.superview {
            superview.addSubview(tb)
            tb.fy = superview.fheight - 40
        }
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

//
//  BeatmapViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BeatmapViewController: UIViewController {

    var live:CGSSLive!
    var beatmaps:[CGSSBeatmap]!
    var bv:BeatmapView!
    var descLabel: UILabel!
    var preSetDiff:Int?
    var currentDiff:Int! {
        didSet {
            let dao = CGSSDAO.sharedDAO
            let song = dao.findSongById(live.musicId!)
            titleLabel.text = "\(song!.title!)\n\(live.getStarsForDiff(currentDiff))☆ \(CGSSTool.diffStringFromInt(currentDiff)) bpm: \(song!.bpm!) notes: \(beatmaps[currentDiff-1].numberOfNotes)"
            bv?.initWith(beatmaps[currentDiff-1], bpm: (song?.bpm)!, type: live.type!)
            bv?.setNeedsDisplay()
        }
    }


    var tv:UIToolbar!
    var titleLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()        
        bv = BeatmapView()
        bv.frame = CGRectMake(0, 64, CGSSTool.width, CGSSTool.height - 64 )

        //自定义descLabel
//        descLabel = UILabel.init(frame: CGRectMake(0, 69, CGSSTool.width, 14))
//        descLabel.textAlignment = .Center
//        descLabel.font = UIFont.systemFontOfSize(12)

        //自定义title描述歌曲信息
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(0, 0, 0, 44)
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFontOfSize(12)
        titleLabel.textAlignment = .Center
        navigationItem.titleView = titleLabel
        
        //如果没有指定难度 则初始化难度为最高难度
        currentDiff = preSetDiff ?? live.maxDiff
        
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "难度", style: .Plain, target: self, action: #selector(self.selectDiff))
     

        
        self.view.addSubview(bv)
        //self.view.addSubview(descLabel)
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
//
//        for v in beatmaps[3].notes! {
//            let note = v as! CGSSBeatmap.Note
//            print(note.sec)
//        }
        // Do any additional setup after loading the view.
    }
    
    func selectDiff() {
        let alvc = UIAlertController.init(title: "选择难度", message: "", preferredStyle: .ActionSheet)
        for i in 1...live.maxDiff {
            alvc.addAction(UIAlertAction.init(title: CGSSTool.diffStringFromInt(i), style: .Default, handler: { (a) in
                self.currentDiff = i
            }))
        }
        alvc.addAction(UIAlertAction.init(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alvc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initWithLive(live:CGSSLive, beatmaps:[CGSSBeatmap]) -> Bool {
        //打开谱面时 隐藏tabbar
        self.hidesBottomBarWhenPushed = true
        self.beatmaps = beatmaps
        self.live = live
        return true
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

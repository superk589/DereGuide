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
    var maxDiff:Int!
    var currentDiff:Int! {
        didSet {
            let dao = CGSSDAO.sharedDAO
            let song = dao.findSongById(live.musicId!)
            titleLabel.text = "\(song!.title!)\n\(live.getStarsForDiff(currentDiff))☆ \(diffStringFromInt(currentDiff)) bpm: \(song!.bpm!) notes: \(beatmaps[currentDiff-1].numberOfNotes)"
            bv?.initWith(beatmaps[currentDiff-1], bpm: (song?.bpm)!, type: live.type!)
            bv?.setNeedsDisplay()
        }
    }
    func diffStringFromInt(i:Int) -> String {
        switch i {
        case 1 :
            return "DEBUT"
        case 2:
            return "REGULAR"
        case 3:
            return "PRO"
        case 4:
            return "MASTER"
        case 5:
            return "MASTER+"
        default:
            return "UNKNOWN"
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
        
        //初始化难度为最高难度
        currentDiff = maxDiff
        
    
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
        for i in 1...maxDiff {
            alvc.addAction(UIAlertAction.init(title: diffStringFromInt(i), style: .Default, handler: { (a) in
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
    
    
    func initWithLive(live:CGSSLive) -> Bool {
        //打开谱面时 隐藏tabbar
        self.hidesBottomBarWhenPushed = true

        var beatmaps = [CGSSBeatmap]()
        let dao = CGSSDAO.sharedDAO
        maxDiff = (live.masterPlus == 0) ? 4 : 5
        for i in 1...maxDiff {
            if let beatmap = dao.findBeatmapById(live.id!, diffId: i) {
                beatmaps.append(beatmap)
            } else {
                let alert = UIAlertController.init(title: "数据缺失", message: "缺少难度为\(diffStringFromInt(i))的歌曲,建议等待当前更新完成,或尝试下拉歌曲列表手动更新数据", preferredStyle: .Alert)
                alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
                self.navigationController?.presentViewController(alert, animated: true, completion: nil)
                return false
            }

        }
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

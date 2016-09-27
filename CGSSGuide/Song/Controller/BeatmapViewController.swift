//
//  BeatmapViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BeatmapViewController: UIViewController {
    
    var live: CGSSLive!
    var beatmaps: [CGSSBeatmap]!
    var bv: BeatmapView!
    var descLabel: UILabel!
    var preSetDiff: Int?
    var currentDiff: Int! {
        didSet {
            let dao = CGSSDAO.sharedDAO
            let song = dao.findSongById(live.musicId!)
            titleLabel.text = "\(song!.title!)\n\(live.getStarsForDiff(currentDiff))☆ \(CGSSGlobal.diffStringFromInt(i: currentDiff)) bpm: \(song!.bpm!) notes: \(beatmaps[currentDiff-1].numberOfNotes)"
            bv?.initWith(beatmaps[currentDiff - 1], bpm: (song?.bpm)!, type: live.type!)
            bv?.setNeedsDisplay()
        }
    }
    
    var tv: UIToolbar!
    var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        bv = BeatmapView()
        bv.frame = CGRect(x: 0, y: 64, width: CGSSGlobal.width, height: CGSSGlobal.height - 64)
        
        // 自定义descLabel
//        descLabel = UILabel.init(frame: CGRectMake(0, 69, CGSSTool.width, 14))
//        descLabel.textAlignment = .Center
//        descLabel.font = UIFont.systemFontOfSize(12)
        
        // 自定义title描述歌曲信息
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        navigationItem.titleView = titleLabel
        
        // 如果没有指定难度 则初始化难度为最高难度
        currentDiff = preSetDiff ?? live.maxDiff
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("难度", comment: "谱面页面导航按钮"), style: .plain, target: self, action: #selector(self.selectDiff))
        
        self.view.addSubview(bv)
        // self.view.addSubview(descLabel)
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
//
//        for v in beatmaps[3].notes! {
//            let note = v as! CGSSBeatmap.Note
//            print(note.sec)
//        }
        // Do any additional setup after loading the view.
    }
    
    func selectDiff() {
        let alert = UIAlertController.init(title: NSLocalizedString("选择难度", comment: "底部弹出框标题"), message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        for i in 1...live.maxDiff {
            alert.addAction(UIAlertAction.init(title: CGSSGlobal.diffStringFromInt(i: i), style: .default, handler: { (a) in
                self.currentDiff = i
                }))
        }
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "底部弹出框按钮"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initWithLive(_ live: CGSSLive, beatmaps: [CGSSBeatmap]) -> Bool {
        // 打开谱面时 隐藏tabbar
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

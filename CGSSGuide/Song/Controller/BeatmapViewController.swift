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
    var flipItem:UIBarButtonItem!
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

        // 设置toolbar
        prepareToolbar()
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
    
    private func prepareToolbar() {
        //let imageItem = UIBarButtonItem.init(image: UIImage.init(named: "822-photo-2-toolbar"), style: .plain, target: self, action: #selector(enterImageView))
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let shareItem = UIBarButtonItem.init(image: UIImage.init(named: "702-share-toolbar"), style: .plain, target: self, action: #selector(share))
        spaceItem.width = 40
        flipItem = UIBarButtonItem.init(image: UIImage.init(named: "1110-rotate-toolbar"), style: .plain, target: self, action: #selector(flip))
        self.toolbarItems = [shareItem, spaceItem, flipItem]
    }
    
    func initWithLive(_ live: CGSSLive, beatmaps: [CGSSBeatmap]) -> Bool {
        // 打开谱面时 隐藏tabbar
        self.hidesBottomBarWhenPushed = true
        self.beatmaps = beatmaps
        self.live = live
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func getImageTitle() -> String {
        return "\(live.musicRef?.title ?? "") \(live.getStarsForDiff(currentDiff))☆ \(CGSSGlobal.diffStringFromInt(i: currentDiff)) bpm: \(live.bpm) notes: \(beatmaps[currentDiff - 1].numberOfNotes) \(NSLocalizedString("时长", comment: "队伍详情页面")): \(Int(beatmaps[currentDiff - 1].totalSeconds))\(NSLocalizedString("秒", comment: "队伍详情页面")) \(bv.mirrorFlip ? "mirror flipped" : "") powered by CGSSGuide"
    }
    func enterImageView() {
        bv.exportImageAsync(title: getImageTitle()) { (image) in
            let data = UIImagePNGRepresentation(image)
            try? data?.write(to: URL.init(fileURLWithPath: "/Users/zzk/Desktop/aaa.png"))
        }
    }
    
    func share() {
        CGSSLoadingHUDManager.default.show()
        bv.exportImageAsync(title: getImageTitle()) { (image) in
            CGSSLoadingHUDManager.default.hide()
            let urlArray = [image];
            let activityVC = UIActivityViewController.init(activityItems: urlArray, applicationActivities: nil)
            // 需要屏蔽的模块
            let cludeActivitys:[UIActivityType] = [
                // 保存到本地相册
                //UIActivityType.saveToCameraRoll,

                // 拷贝 复制
                //UIActivityType.copyToPasteboard,

                // 打印
                //UIActivityType.print,

                // 指定联系人
                //UIActivityTypeAssignToContact,

                // Facebook
                //UIActivityType.postToFacebook,

                // 微博
                //UIActivityType.postToWeibo,

                // 短信
                //UIActivityType.message,

                // 邮箱
                //UIActivityType.mail,

                // 腾讯微博
                //UIActivityType.postToTencentWeibo,

                // twitter
                //UIActivityTypePostToTwitter,

                // vimeo
                //UIActivityTypePostToVimeo,

                // airDrop
                //UIActivityTypeAirDrop,

                //UIActivityTypeAddToReadingList,
                //UIActivityTypePostToFlickr,
                //UIActivityTypeOpenInIBooks, // 9.0
            ]
            // 排除活动类型
            activityVC.excludedActivityTypes = cludeActivitys
            
            // 呈现分享界面
            self.present(activityVC, animated: true, completion: { 
                
            })
        }
    }
    
    func flip() {
        bv.mirrorFlip = !bv.mirrorFlip
        if bv.mirrorFlip {
            flipItem.image = UIImage.init(named: "1110-rotate-toolbar-selected")
        } else {
            flipItem.image = UIImage.init(named: "1110-rotate-toolbar")
        }
    }
    
}

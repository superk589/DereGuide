//
//  BeatmapViewController.swift
//  DereGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class BeatmapViewController: UIViewController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    var scene: CGSSLiveScene!
    
    private func updateUI() {
        if let beatmap = checkBeatmapData(scene) {
            titleLabel?.text = "\(scene.live.name)\n\(scene.stars)☆ \(scene.difficulty.description) bpm: \(scene.live.bpm) notes: \(beatmap.numberOfNotes)"
            pause()
            beatmapView?.setup(beatmap: beatmap, bpm: scene.live.bpm, type: scene.live.type, setting: setting)
            beatmapView?.setNeedsDisplay()
        }
    }
    
    var beatmapView: BeatmapView!
    var descLabel: UILabel!
    var flipItem: UIBarButtonItem!
    var tv: UIToolbar!
    var titleLabel: UILabel!
    
    private typealias Setting = BeatmapAdvanceOptionsViewController.Setting
    private var setting = Setting.load() ?? Setting()
    
    lazy var filterController: BeatmapAdvanceOptionsViewController = {
        let vc = BeatmapAdvanceOptionsViewController(style: .grouped)
        vc.setting = self.setting
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareToolbar()
        print("Beatmap loaded, liveId: \(scene.live.id) musicId: \(scene.live.musicDataId)")
        
        beatmapView = BeatmapView()
        beatmapView.settingDelegate = self

        self.view.addSubview(beatmapView)
        beatmapView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        if #available(iOS 11.0, *) {
            view.layoutIfNeeded()
        }
        beatmapView.contentMode = .redraw
        beatmapView.delegate = self
        
        // 自定义title描述歌曲信息
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.baselineAdjustment = .alignCenters
        navigationItem.titleView = titleLabel
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("难度", comment: "谱面页面导航按钮"), style: .plain, target: self, action: #selector(self.selectDiff))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        self.view.backgroundColor = UIColor.white
        
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let progress = beatmapView.getProgress(for: CGPoint(x: 0, y: beatmapView.playOffsetY - beatmapView.contentOffset.y))
        let shouldResume = beatmapView.isAutoScrolling
        if shouldResume {
            pause()
        }
        coordinator.animate(alongsideTransition: { (context) in
            self.beatmapView.setProgress(progress, for: CGPoint(x: 0, y: self.beatmapView.playOffsetY - self.beatmapView.contentOffset.y))
            self.beatmapView.setNeedsDisplay()
        }, completion: { finished in
            if shouldResume && !self.beatmapView.isAutoScrolling {
                self.play()
            }
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            beatmapView.contentOffset = CGPoint(x: 0, y: beatmapView.contentSize.height - beatmapView.frame.size.height + beatmapView.adjustedContentInset.bottom)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if beatmapView.isAutoScrolling {
            pause()
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectDiff() {
        let alert = UIAlertController.init(title: NSLocalizedString("选择难度", comment: "底部弹出框标题"), message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        for detail in scene.live.details {
            alert.addAction(UIAlertAction.init(title: detail.difficulty.description, style: .default, handler: { (a) in
                self.scene.difficulty = detail.difficulty
            }))
        }
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "底部弹出框按钮"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showBeatmapNotFoundAlert() {
        let alert = UIAlertController.init(title: NSLocalizedString("数据缺失", comment: "弹出框标题"), message: NSLocalizedString("未找到对应谱面，建议等待当前更新完成，或尝试下拉歌曲列表手动更新数据。如果更新后仍未找到，可能是官方还未更新此谱面。", comment: "弹出框正文"), preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func checkBeatmapData(_ scene: CGSSLiveScene) -> CGSSBeatmap? {
        if let beatmap = scene.beatmap {
            if let info = checkShiftingInfo() {
                beatmap.addShiftingOffset(info: info, rawBpm: scene.live.bpm)
            } else {
                beatmap.addStartOffset(rawBpm: scene.live.bpm)
            }
            return beatmap
        } else {
            showBeatmapNotFoundAlert()
            return nil
        }
    }
    
    func checkShiftingInfo() -> CGSSBeatmapShiftingInfo? {
        if let path = Bundle.main.path(forResource: "BpmShift", ofType: "plist"), let dict = NSDictionary.init(contentsOfFile: path) {
            for (k, v) in dict {
                let keys = (k as! String).components(separatedBy: ",")
                for key in keys {
                    if Int(key) == scene.live.id {
                        return CGSSBeatmapShiftingInfo.init(info: v as! NSDictionary)
                    }
                }
            }
        }
        return nil
    }
    
    lazy private var playItem = UIBarButtonItem(image: #imageLiteral(resourceName: "1241-play-toolbar"), style: .plain, target: self, action: #selector(self.play))
    lazy private var pauseItem = UIBarButtonItem(image: #imageLiteral(resourceName: "1242-pause-toolbar"), style: .plain, target: self, action: #selector(self.pause))

    private func prepareToolbar() {
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpaceItem.width = 20
        let shareItem = UIBarButtonItem(image: #imageLiteral(resourceName: "702-share-toolbar"), style: .plain, target: self, action: #selector(share))
        let advanceItem = UIBarButtonItem(title: NSLocalizedString("选项", comment: ""), style: .plain, target: self, action: #selector(showAdvanceOptions))
        
        let fixedSpaceItem2 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpaceItem2.width = 20
       
        
        flipItem = UIBarButtonItem(image: #imageLiteral(resourceName: "1110-rotate-toolbar"), style: .plain, target: self, action: #selector(flip))
        
        toolbarItems = [shareItem, fixedSpaceItem, flipItem, fixedSpaceItem2, playItem, spaceItem, advanceItem]
    }
  
    func setup(with scene: CGSSLiveScene) {
        self.scene = scene
    }
    
    func getImageTitle() -> String {
        return "\(scene.live.name) \(scene.stars)☆ \(scene.difficulty.description) bpm:\(scene.live.bpm) notes:\(scene.beatmap?.numberOfNotes ?? 0) length:\(Int(scene.beatmap?.totalSeconds ?? 0))s \(beatmapView.mirrorFlip ? "mirror flipped" : "") powered by \(Config.appName)"
    }
    
    func enterImageView() {
        beatmapView.exportImageAsync(title: getImageTitle()) { (image) in
            let data = UIImagePNGRepresentation(image!)
            try? data?.write(to: URL.init(fileURLWithPath: "/Users/zzk/Desktop/aaa.png"))
        }
    }
    
    @objc private func share(item: UIBarButtonItem) {
        // enterImageView()
        CGSSLoadingHUDManager.default.show()
        beatmapView.exportImageAsync(title: getImageTitle()) { (image) in
            CGSSLoadingHUDManager.default.hide()
            if image == nil {
                return
            }
            let urlArray = [image!]
            let activityVC = UIActivityViewController.init(activityItems: urlArray, applicationActivities: nil)
            activityVC.popoverPresentationController?.barButtonItem = item
            // activityVC.popoverPresentationController?.sourceRect = CGRect(x: item.width / 2, y: 0, width: 0, height: 0)
            
            // 需要屏蔽的模块
            let cludeActivitys:[UIActivityType] = []
            
            // 排除活动类型
            activityVC.excludedActivityTypes = cludeActivitys
            
            // 呈现分享界面
            self.present(activityVC, animated: true, completion: {
                
            })
        }
    }
    
    @objc private func showAdvanceOptions() {
        let nav = BaseNavigationController(rootViewController: filterController)
        filterController.setting = setting
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func flip() {
        beatmapView.mirrorFlip = !beatmapView.mirrorFlip
        if beatmapView.mirrorFlip {
            flipItem.image = #imageLiteral(resourceName: "1110-rotate-toolbar-selected")
        } else {
            flipItem.image = #imageLiteral(resourceName: "1110-rotate-toolbar")
        }
    }
    
    @objc private func play() {
        if let index = toolbarItems?.index(of: playItem) {
            toolbarItems?[index] = pauseItem
        }
        startAutoScrolling()
    }
    
    @objc private func pause() {
        if let index = toolbarItems?.index(of: pauseItem) {
            toolbarItems?[index] = playItem
        }
        endAutoScrolling()
    }
    
    private lazy var displayLink = CADisplayLink(target: self.beatmapView, selector: #selector(BeatmapView.frameUpdated(displayLink:)))
    
    func startAutoScrolling() {
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
        beatmapView.startAutoScrolling()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func endAutoScrolling() {
        // if click too quickly, the main runloop may receive two or more pause action, removing display link from runloop twice will crash.
        if beatmapView.isAutoScrolling {
            displayLink.remove(from: .current, forMode: .defaultRunLoopMode)
            beatmapView.endAutoScrolling()
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    @objc private func enterBackground() {
        if beatmapView.isAutoScrolling {
            pause()
        }
    }
    
    deinit {
        displayLink.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}

extension BeatmapViewController: BeatmapViewSettingDelegate {
    
    func beatmapView(_ beatmapView: BeatmapView, didChange setting: BeatmapAdvanceOptionsViewController.Setting) {
        self.setting = setting
        self.setting.save()
    }
}

extension BeatmapViewController: BeatmapAdvanceOptionsViewControllerDelegate {
    
    func didDone(_ beatmapAdvanceOptionsViewController: BeatmapAdvanceOptionsViewController) {
        self.setting = beatmapAdvanceOptionsViewController.setting
        view.setNeedsLayout()
        updateUI()
    }
    
}

extension BeatmapViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        beatmapView.setNeedsDisplay()
        guard let drawer = beatmapView.drawer else { return }
        if beatmapView.isAutoScrolling && beatmapView.playOffsetY + drawer.heightInset < drawer.getPointY(beatmapView.beatmap.lastNote?.offsetSecond ?? 0) {
            pause()
        }
    }
    
}

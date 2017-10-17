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
    
    var scene: CGSSLiveScene! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let beatmap = checkBeatmapData(scene) {
            titleLabel?.text = "\(scene.live.name)\n\(scene.stars)☆ \(scene.difficulty.description) bpm: \(scene.live.bpm) notes: \(beatmap.numberOfNotes)"
            bv?.setup(beatmap: beatmap, bpm: scene.live.bpm, type: scene.live.type, setting: setting)
            bv?.setNeedsDisplay()
        }
    }
    
    var bv: BeatmapView!
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
        
        bv = BeatmapView()
        self.view.addSubview(bv)
        bv.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(-44)
            } else {
                make.edges.equalToSuperview()
            }
        }
        bv.contentMode = .redraw
        
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
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.bv.beatmapDrawer.widthInset = size.width / 7.2
            self.bv.beatmapDrawer.innerWidthInset = size.width / 7.2
            self.bv.setNeedsDisplay()
        }, completion: nil)
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func selectDiff() {
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
    
    private func prepareToolbar() {
        // let imageItem = UIBarButtonItem.init(image: UIImage.init(named: "822-photo-2-toolbar"), style: .plain, target: self, action: #selector(enterImageView))
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedSpaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpaceItem.width = 30
        let shareItem = UIBarButtonItem.init(image: UIImage.init(named: "702-share-toolbar"), style: .plain, target: self, action: #selector(share))
        let advanceItem = UIBarButtonItem(title: NSLocalizedString("高级选项", comment: ""), style: .plain, target: self, action: #selector(showAdvanceOptions))
        flipItem = UIBarButtonItem.init(image: UIImage.init(named: "1110-rotate-toolbar"), style: .plain, target: self, action: #selector(flip))
        self.toolbarItems = [shareItem, fixedSpaceItem, flipItem, spaceItem, advanceItem]
    }
  
    func setup(with scene: CGSSLiveScene) {
        self.scene = scene
    }
    
    func getImageTitle() -> String {
        return "\(scene.live.name) \(scene.stars)☆ \(scene.difficulty.description) bpm:\(scene.live.bpm) notes:\(scene.beatmap?.numberOfNotes ?? 0) length:\(Int(scene.beatmap?.totalSeconds ?? 0))s \(bv.mirrorFlip ? "mirror flipped" : "") powered by \(Config.appName)"
    }
    
    func enterImageView() {
        bv.exportImageAsync(title: getImageTitle()) { (image) in
            let data = UIImagePNGRepresentation(image!)
            try? data?.write(to: URL.init(fileURLWithPath: "/Users/zzk/Desktop/aaa.png"))
        }
    }
    
    @objc func share(item: UIBarButtonItem) {
        // enterImageView()
        CGSSLoadingHUDManager.default.show()
        bv.exportImageAsync(title: getImageTitle()) { (image) in
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
    
    @objc func showAdvanceOptions() {
        let nav = BaseNavigationController(rootViewController: filterController)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true, completion: nil)
    }
    
    @objc func flip() {
        bv.mirrorFlip = !bv.mirrorFlip
        if bv.mirrorFlip {
            flipItem.image = UIImage.init(named: "1110-rotate-toolbar-selected")
        } else {
            flipItem.image = UIImage.init(named: "1110-rotate-toolbar")
        }
    }
}

extension BeatmapViewController: BeatmapAdvanceOptionsViewControllerDelegate {
    
    func didDone(_ beatmapAdvanceOptionsViewController: BeatmapAdvanceOptionsViewController) {
        self.setting = beatmapAdvanceOptionsViewController.setting
        updateUI()
    }
    
}

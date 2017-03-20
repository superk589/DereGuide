//
//  EventDetailController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class EventDetailController: BaseViewController, BannerViewContainerViewController {
    
    var eventDetailView: EventDetailView!
    var sv: UIScrollView!
    var event: CGSSEvent!
    var bannerId: Int!
    var banner: BannerView!
    
    var ptList: EventPtRankingList?
    var scoreList: EventScoreRankingList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = NavigationTitleLabel()
        label.text = event.name
        navigationItem.titleView = label
        
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = leftItem
        
        sv = UIScrollView()
        view.addSubview(sv)
        sv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        banner = BannerView()
        sv.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Screen.width * 212 / 824)
        }
        banner.sd_setImage(with: event.detailBannerURL)
        
        eventDetailView = EventDetailView()
        sv.addSubview(eventDetailView)
        eventDetailView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(banner.snp.bottom)
            make.width.equalToSuperview()
        }
        eventDetailView.setup(event: event, bannerId: bannerId)
        eventDetailView.delegate = self
        
        requestData()
        // Do any additional setup after loading the view.
    }
    
    func requestData() {
        
        if CGSSEventTypes.ptRankingExists.contains(event.eventType) {
            requestPtData()
        }
        if CGSSEventTypes.scoreRankingExists.contains(event.eventType) {
            requestScoreData()
        }
    }
    
    func requestPtData() {
        EventPtDataRequest.requestPtData(event: event) { (list) in
            self.ptList = list
            if list != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.eventDetailView.setup(ptList: list!, onGoing: self?.event.isOnGoing ?? false)
                }
            }
        }
    }
    
    func requestScoreData() {
        EventPtDataRequest.requestHighScoreData(event: event) { (list) in
            self.scoreList = list
            if list != nil {
                DispatchQueue.main.async { [weak self] in
                     self?.eventDetailView.setup(scoreList: list!, onGoing: self?.event.isOnGoing ?? false)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventDetailController: EventDetailViewDelegate {
    func refreshPtView(eventDetailView: EventDetailView) {
        requestPtData()
    }
    
    func refreshScoreView(eventDetailView: EventDetailView) {
        requestScoreData()
    }

    func gotoPtChartView(eventDetailView: EventDetailView) {
        if let list = self.ptList, list.list.count > 0 {
            let vc = EventChartController()
            vc.rankingList = list
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func gotoScoreChartView(eventDetailView: EventDetailView) {
        if let list = self.scoreList, list.list.count > 0 {
            let vc = EventChartController()
            vc.rankingList = list
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func eventDetailView(_ view: EventDetailView, didClick icon: CGSSCardIconView) {
        if let id = icon.cardId {
            if let card = CGSSDAO.sharedDAO.findCardById(id) {
                let vc = CardDetailViewController()
                vc.card = card
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func showBeatmapNotFoundAlert() {
        let alert = UIAlertController.init(title: NSLocalizedString("数据缺失", comment: "弹出框标题"), message: NSLocalizedString("未找到对应谱面，建议等待当前更新完成，或尝试下拉歌曲列表手动更新数据。如果更新后仍未找到，可能是官方还未更新此谱面。", comment: "弹出框正文"), preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func eventDetailView(_ view: EventDetailView, didSelect live: CGSSLive, of difficulty: Int) {
        if let _ = CGSSGameResource.shared.getBeatmap(liveId: live.id, of: difficulty) {
            let beatmapVC = BeatmapViewController()
            beatmapVC.setup(live, diff: difficulty)
            navigationController?.pushViewController(beatmapVC, animated: true)
        } else {
            let alert = UIAlertController.init(title: NSLocalizedString("数据缺失", comment: "弹出框标题"), message: NSLocalizedString("未找到对应谱面，建议等待当前更新完成，或尝试下拉歌曲列表手动更新数据。如果更新后仍未找到，可能是官方还未更新此谱面。", comment: "弹出框正文"), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
}

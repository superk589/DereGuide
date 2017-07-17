//
//  GachaDetailController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import StoreKit

class GachaDetailController: BaseViewController, BannerViewContainerViewController {

    var pool: CGSSGachaPool! {
        didSet {
            print("load gacha pool \(pool.id)")
        }
    }
    
    var sv: UIScrollView!
    
    var banner: BannerView!
    
    var gachaDetailView: GachaDetailView!
    
    var simulationView: GachaSimulateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = NavigationTitleLabel()
        label.text = pool.name
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
            make.top.equalToSuperview()
            make.left.equalToSuperview().priority(900)
            make.right.equalToSuperview().priority(900)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(824)
            make.height.equalTo(banner.snp.width).multipliedBy(212.0 / 824.0)
        }
        banner.sd_setImage(with: pool.detailBannerURL)
        
        gachaDetailView = GachaDetailView()
        sv.addSubview(gachaDetailView)
        gachaDetailView.snp.makeConstraints { (make) in
            make.left.right.equalTo(banner)
            make.top.equalTo(banner.snp.bottom)
        }
        gachaDetailView.setupWith(pool: pool)
        gachaDetailView.delegate = self
        
        simulationView = GachaSimulateView()
        sv.addSubview(simulationView)
        simulationView.snp.makeConstraints { (make) in
            make.left.right.equalTo(banner)
            make.top.equalTo(gachaDetailView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        simulationView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backAction() {
        navigationController?.popViewController(animated: true)
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

// MARK: GachaDetailViewDelegate
extension GachaDetailController: GachaDetailViewDelegate {
    func seeModeCard(gachaDetailView view: GachaDetailView) {
        let vc = GachaCardTableViewController()
        vc.setup(with: pool)
        navigationController?.pushViewController(vc, animated: true)
    }
    func gachaDetailView(_ view: GachaDetailView, didClick cardIcon: CGSSCardIconView) {
        let vc = CardDetailViewController()
        vc.card = CGSSDAO.shared.findCardById(cardIcon.cardId!)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: GachaSimulateViewDelegate
extension GachaDetailController: GachaSimulateViewDelegate {
    func tenGacha(gachaSimulateView: GachaSimulateView) {
        let cardIds = pool.simulate(times: 10, srGuaranteeCount: 1)
        simulationView.setupResultView(cardIds: cardIds)
        
        /// first time using ten pull in gacha view controller, shows app store rating alert in app.
        if #available(iOS 10.3, *) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                if !UserDefaults.standard.hasRated {
                    SKStoreReviewController.requestReview()
                    UserDefaults.standard.hasRated = true
                }
            })
        }
    }
    func singleGacha(gachaSimulateView: GachaSimulateView) {
        let cardId = pool.simulateOnce(srGuarantee: false)
        simulationView.setupResultView(cardIds: [cardId])
    }
    
    func gachaSimulateView(_ view: GachaSimulateView, didClick cardIcon: CGSSCardIconView) {
        if let card = CGSSDAO.shared.findCardById(cardIcon.cardId!) {
            let vc = CardDetailViewController()
            vc.card = card
            navigationController?.pushViewController(vc, animated: true)
        }        
    }
}

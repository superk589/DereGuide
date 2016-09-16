//
//  GachaViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class GachaViewController: RefreshableTableViewController {
    
    var gachaViews = [GachaView]()
    var simulateView: GachaSimulateView!
    var gachaPools = [GachaPool]()
    var headerView: UIView!
    
    var poolIndex : Int! {
        didSet {
            gachaViews[poolIndex].setSelect()
        }
        willSet {
            if poolIndex != nil {
                gachaViews[poolIndex].setDeselect()
            }
        }
    }
    
    var currentPool: GachaPool? {
        if poolIndex != nil {
            return gachaPools[poolIndex]
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        headerView.backgroundColor = UIColor.white
        simulateView = GachaSimulateView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        simulateView.delegate = self
        headerView.addSubview(simulateView)
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        refresh()
        // Do any additional setup after loading the view.
    }
    
    override func refresh() {
        wipe()
        if let pools = CGSSGameResource.sharedResource.getGachaPool(), pools.count > 0 {
            self.gachaPools.append(contentsOf: pools)
            for i in 0..<pools.count {
                let pool = pools[i]
                let y:CGFloat = i > 0 ? gachaViews[i - 1].fy + gachaViews[i - 1].fheight : 0
                let gachaView = GachaView.init(frame: CGRect(x: 0, y: y, width: CGSSGlobal.width, height: 0))
                gachaView.tag = i
                gachaView.delegate = self
                headerView.addSubview(gachaView)
                gachaView.setupWith(pool: pool)
                gachaViews.append(gachaView)
            }
            poolIndex = 0
        } else {
            let gachaView = GachaView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
            gachaView.tag = 0
            gachaView.delegate = self
            headerView.addSubview(gachaView)
            gachaViews.append(gachaView)
            gachaView.setupWithNoPool()
        }
        simulateView.fy = gachaViews.last!.fy + gachaViews.last!.fheight
        headerView.fheight = simulateView.fy + simulateView.fheight + 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for sub in simulateView.resultView.subviews {
            if sub.subviews.count > 0 {
                sub.addGlowAnimateAlongBorder(clockwise: true, imageName: "star", count: 3, cornerRadius: sub.fheight / 8)
            }
        }
    }
    
    func wipe() {
        gachaPools.removeAll()
        for subView in gachaViews {
            subView.removeFromSuperview()
        }
        gachaViews.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refresherValueChanged() {
        check(0b1000001)
    }

}

extension GachaViewController : GachaViewDelegate, GachaSimulateViewDelegate {
    func iconClick(iv: CGSSCardIconView) {
        let cardDV = CardDetailViewController()
        cardDV.card = CGSSDAO.sharedDAO.findCardById(iv.cardId!)
        navigationController?.pushViewController(cardDV, animated: true)
    }
    func tenGacha() {
        if let arr = currentPool?.simulate(times: 10) {
            simulateView.setupResultView(cardIds: arr)
        }
    }
    func singleGacha() {
        if let a = currentPool?.simulateOnce(srGuarantee: false) {
            simulateView.setupResultView(cardIds: [a])
        }
    }
    
    func didSelect(gachaView: GachaView) {
        poolIndex = gachaView.tag
    }
    
    func seeMoreCard(gachaView: GachaView) {
        let pool = gachaPools[gachaView.tag]
        let gachaCardListVC = GachaCardTableViewController()
        gachaCardListVC.defaultCardList = pool.cardList
        self.navigationController?.pushViewController(gachaCardListVC, animated: true)
    }
}

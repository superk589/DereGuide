//
//  GachaViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class GachaViewController: RefreshableTableViewController {
    
    // var gachaViews = [GachaView]()
    var simulateView: GachaSimulateView!
    var gachaPools = [GachaPool]()
    var headerView: UIView!
    lazy var fixedView: UIView = {
        let view = UIView.init(frame: self.headerView.bounds)
        self.tableView.addSubview(view)
        return view
    }()
    
    
    var poolIndex: Int! {
        didSet {
            if let cell = tableView.cellForRow(at: IndexPath.init(row: poolIndex, section: 0)) as? GachaPoolTableViewCell {
                cell.setSelect()
                headerHidden = false
            }
        }
        willSet {
            if poolIndex != nil {
                if let cell = tableView.cellForRow(at: IndexPath.init(row: poolIndex, section: 0)) as? GachaPoolTableViewCell {
                    cell.setDeselect()
                }
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
        headerView.fheight = simulateView.fbottom
        if let pools = CGSSGameResource.sharedResource.getGachaPool(), pools.count > 0 {
            self.gachaPools.append(contentsOf: pools)
            poolIndex = 0
        }
        tableView.register(GachaPoolTableViewCell.self, forCellReuseIdentifier: "GachaCell")
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.estimatedRowHeight = 225
        //tableView.tableHeaderView = headerView
        tableView.tableHeaderView = UIView.init(frame: headerView.bounds)
        fixedView.addSubview(headerView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "764-arrow-down-toolbar-selected.png"), style: .plain, target: self, action: #selector(showOrHideHeader))
        // Do any additional setup after loading the view.
    }
    
    func showOrHideHeader(barItem: UIBarButtonItem) {
        headerHidden = !headerHidden
    }
    
    override func refresh() {
        gachaPools.removeAll()
        if let pools = CGSSGameResource.sharedResource.getGachaPool(), pools.count > 0 {
            self.gachaPools.append(contentsOf: pools)
            poolIndex = 0
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //NotificationCenter.default.addObserver(self, selector: #selector(renewAnimation), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        CGSSNotificationCenter.add(self, selector: #selector(refresh), name: CGSSNotificationCenter.updateEnd, object: nil)
        //renewAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func renewAnimation() {
        for sub in simulateView.resultView.subviews {
            if sub.subviews.count > 0 {
                sub.addGlowAnimateAlongBorder(clockwise: true, imageName: "star", count: 3, cornerRadius: sub.fheight / 8)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(gachaPools.count, 1)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return headerView.fheight
//    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return headerView
//    }
//    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GachaCell", for: indexPath) as! GachaPoolTableViewCell
        if gachaPools.count == 0 {
            cell.tag = -1
            cell.delegate = self
            cell.setupWithoutPool()
        } else {
            let pool = gachaPools[indexPath.row]
            cell.tag = 1000 + indexPath.row
            cell.delegate = self
            cell.setupWith(pool: pool)
            if poolIndex == indexPath.row {
                cell.setSelect()
            } else {
                cell.setDeselect()
            }
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refresherValueChanged() {
        check(0b1000001)
    }
    
    // var lastContentOffsetY: CGFloat = 0
    var headerHidden:Bool = true {
        didSet {
            lastOffsetY = tableView.contentOffset.y
            if oldValue != headerHidden {
                if headerHidden {
                    navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "764-arrow-down-toolbar-selected.png")
                } else {
                    navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "763-arrow-up-toolbar-selected.png")
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.headerView.fy = self.headerHidden ? max(-self.fixedView.fy, -self.headerView.fheight) : max(-self.fixedView.fy, 0)
                    self.fixedView.fheight = max(self.headerView.fbottom, 0)
                })
            }
        }
    }
    var lastOffsetY:CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fixedView.fy = tableView.contentOffset.y + tableView.contentInset.top
        if abs(lastOffsetY - tableView.contentOffset.y) > headerView.fheight {
            headerHidden = true
        }
        if !headerHidden {
            if fixedView.fy < 0 {
                headerView.fy = -fixedView.fy
            } else {
                headerView.fy = 0
            }
        } else {
            headerView.fy = max(-fixedView.fy, -headerView.fheight)
        }
        fixedView.fheight = max(headerView.fbottom, 0)
    }
}

extension GachaViewController : GachaPoolTableViewCellDelegate, GachaSimulateViewDelegate {
    func iconClick(iv: CGSSCardIconView) {
        let cardDV = CardDetailViewController()
        cardDV.card = CGSSDAO.sharedDAO.findCardById(iv.cardId!)
        navigationController?.pushViewController(cardDV, animated: true)
    }
    func tenGacha() {
        if let arr = currentPool?.simulate(times: 10, srGuaranteeCount: 1) {
            simulateView.setupResultView(cardIds: arr)
        }
    }
    func singleGacha() {
        if let a = currentPool?.simulateOnce(srGuarantee: false) {
            simulateView.setupResultView(cardIds: [a])
        }
    }
    
    func didSelect(cell: GachaPoolTableViewCell) {
        let index = cell.tag - 1000
        if index >= 0 {
            poolIndex = index
            
            let rect = tableView.rectForRow(at: IndexPath.init(row: index, section: 0))
            if  rect.origin.y <= fixedView.fbottom {
                tableView.setContentOffset(CGPoint.init(x: 0, y: rect.origin.y - fixedView.fheight - tableView.contentInset.top), animated: true)
            }
        }
    }
    
    func seeMoreCard(cell: GachaPoolTableViewCell) {
        let pool = gachaPools[cell.tag - 1000]
        let gachaCardListVC = GachaCardTableViewController()
        gachaCardListVC.defaultCardList = pool.cardList
        self.navigationController?.pushViewController(gachaCardListVC, animated: true)
    }
}


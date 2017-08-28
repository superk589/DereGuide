//
//  BaseCardTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController
import SnapKit

protocol BaseCardTableViewControllerDelegate {
    func selectCard(_ card: CGSSCard)
}

class BaseCardTableViewController: BaseModelTableViewController, CardFilterSortControllerDelegate, ZKDrawerControllerDelegate {
    
    var cardList = [CGSSCard]()
    var filter: CGSSCardFilter {
        set {
            CGSSSorterFilterManager.default.cardfilter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.cardfilter
        }
    }
    var sorter: CGSSSorter {
        set {
            CGSSSorterFilterManager.default.cardSorter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.cardSorter
        }
    }
    var delegate: BaseCardTableViewControllerDelegate?
    
    lazy var filterVC: CardFilterSortController = {
        let vc = CardFilterSortController()
        vc.filter = self.filter
        vc.sorter = self.sorter
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化导航栏的搜索条
        navigationItem.titleView = searchBar
        searchBar.placeholder = NSLocalizedString("日文名/罗马音/技能/稀有度", comment: "搜索框文字, 不宜过长")
        
        let item1 = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = item1
        
        tableView.separatorStyle = .none
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "CardCell")
   
        NotificationCenter.default.addObserver(self, selector: #selector(setNeedsReloadData), name: .gameResoureceProcessedEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setNeedsReloadData), name: .favoriteCardsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged(notification:)), name: .dataRemoved, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func updateUI() {
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            DispatchQueue.main.sync {
                self?.filter.searchText = self?.searchBar.text ?? ""
            }
            var newList = self?.filter.filter(CGSSDAO.shared.cardDict.allValues as! [CGSSCard]) ?? [CGSSCard]()
            self?.sorter.sortList(&newList)
            DispatchQueue.main.async {
                CGSSLoadingHUDManager.default.hide()
                //确保cardList在主线程中改变的原子性, 防止筛选过程中tableView滑动崩溃
                self?.cardList = newList
                self?.tableView.reloadData()
            }
        }
    }
    
    override func reloadData() {
        updateUI()
    }
  
    override func checkUpdate() {
        check([.card, .master])
    }
    
    @objc func dataChanged(notification: Notification) {
        if let types = notification.userInfo?[CGSSUpdateDataTypesName] as? CGSSUpdateDataTypes {
            if types.contains(.master) || types.contains(.card) {
                self.setNeedsReloadData()
            }
        }
    }
    
    @available(iOS 10.0, *)
    func transitionToCollectionView() {
//        navigationController?.isHeroEnabled = true
//        isHeroEnabled = true
        let vc = BaseCardCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.cards = self.cardList
//        hero_replaceViewController(with: vc)
        
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func filterAction() {
        drawerController?.show(.right, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let drawer = drawerController
        drawer?.rightViewController = filterVC
        drawer?.delegate = self
        drawer?.defaultRightWidth = min(Screen.shortSide - 68, 400)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        drawerController?.rightViewController = nil
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, didHide vc: UIViewController) {
        
    }
    func drawerController(_ drawerVC: ZKDrawerController, willShow vc: UIViewController) {
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardTableViewCell
        
        let row = indexPath.row
        let card = cardList[row]
        cell.setup(with: card)
//        cell.cardView.cardIconView.heroID = "\(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        delegate?.selectCard(cardList[indexPath.row])
    }
    
    func doneAndReturn(filter: CGSSCardFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.cardfilter = filter
        CGSSSorterFilterManager.default.cardSorter = sorter
        CGSSSorterFilterManager.default.saveForCard()
        updateUI()
    }
    
}

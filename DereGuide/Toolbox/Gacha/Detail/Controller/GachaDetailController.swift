//
//  GachaDetailController.swift
//  DereGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import StoreKit

class GachaDetailController: BaseTableViewController {

    var gacha: CGSSGacha! {
        didSet {
            print("load gacha \(gacha.id)")
        }
    }
    
    private struct Row: CustomStringConvertible {
        var type: UITableViewCell.Type
        var description: String {
            return type.description()
        }
    }
    
    private var rows = [Row]()
    
    var gachaResult = GachaSimulationResult(times: 0, ssrCount: 0, srCount: 0)
    
    var gachaCardIDs = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
        
        prepareRows()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        // fix on iOS 9, after custom transition, tableView may have wrong origin
        if tableView.frame.origin.y != 0 {
            tableView.frame.origin.y = 0
        }
    }
    
    private func prepareNavigationBar() {
        let label = NavigationTitleLabel()
        label.text = gacha.name
        navigationItem.titleView = label
        
        let leftItem = UIBarButtonItem(image: #imageLiteral(resourceName: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = leftItem
    }

    private func prepareRows() {
        rows.removeAll()
        
        rows.append(Row(type: GachaDetailBannerCell.self))
        rows.append(Row(type: GachaDetailBasicCell.self))
        rows.append(Row(type: GachaDetailNewCardsCell.self))
        rows.append(Row(type: GachaDetailGuaranteesCell.self))
        if gacha.hasCachedRates {
            rows.append(Row(type: GachaDetailSimulatorCell.self))
        } else {
            rows.append(Row(type: GachaDetailLoadingCell.self))
            requestData()
        }
        
        rows.forEach {
            tableView.register($0.type, forCellReuseIdentifier: $0.description)
        }
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func resetAction() {
        gachaResult = GachaSimulationResult(times: 0, ssrCount: 0, srCount: 0)
        simulatorView?.wipeResultView()
        simulatorView?.wipeResultGrid()
    }
    
    private var simulatorView: GachaSimulatorView? {
        let index = self.rows.enumerated().first { $0.element.type == GachaDetailSimulatorCell.self }?.offset
        if let index = index, let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GachaDetailSimulatorCell {
            return cell.simulatorView
        } else {
            return nil
        }
    }
    
    private var loadingView: LoadingView? {
        let index = self.rows.enumerated().first { $0.element.type == GachaDetailLoadingCell.self }?.offset
        if let index = index, let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GachaDetailLoadingCell {
            return cell.loadingView
        } else {
            return nil
        }
    }
    
    private func requestData() {
        loadingView?.status = .loading
        APIClient.shared.gachaRates(gachaID: gacha.id) { [weak self] (pack) in
            DispatchQueue.main.async {
                if let pack = pack, let odds = GachaOdds(fromMsgPack: pack), let id = self?.gacha.id {
                    try? odds.save(gachaID: id)
                    self?.gacha.cachedOdds = odds
                    self?.gacha.merge(gachaOdds: odds)
                    self?.prepareRows()
                    self?.tableView.reloadData()
                } else {
                    let index = self?.rows.enumerated().first { $0.element.type == GachaDetailLoadingCell.self }?.offset
                    if let index = index, let cell = self?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GachaDetailLoadingCell {
                        // if there is no network, the loading image disappears after 0.5 to let user know we have retried.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            cell.loadingView.status = .failed
                        })
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rows[indexPath.row].description, for: indexPath)
        switch cell {
        case let cell as GachaDetailBannerCell:
            cell.setup(bannerURL: gacha.detailBannerURL)
        case let cell as GachaDetailBasicCell:
            cell.setup(pool: gacha)
        case let cell as GachaDetailNewCardsCell:
            let dao = CGSSDAO.shared
            var cards = [CGSSCard]()
            for reward in gacha.new {
                if let card = dao.findCardById(reward.cardId) {
                    cards.append(card)
                }
            }
            let sorter = CGSSSorter.init(property: "sRarity")
            sorter.sortList(&cards)
            
            if gacha.hasLocalRates {
                let odds = cards.map { CardWithOdds(card:$0, odds: gacha.rewardTable[$0.id]?.relativeOdds) }
                cell.setup(cardsWithOdds: odds)
            } else {
                let cardWithOdds: [CardWithOdds] = cards.map {
                    if let odds = gacha.cachedOdds?.cardIDOdds[$0.id]?.chargeOdds {
                        return CardWithOdds(card: $0, odds: Int(((Double(odds) ?? 0) * 10000).rounded()))
                    } else {
                        return CardWithOdds(card: $0, odds: nil)
                    }
                }
                cell.setup(cardsWithOdds: cardWithOdds)
            }
            cell.delegate = self
        case let cell as GachaDetailGuaranteesCell:
            cell.setup(cards: gacha.cardsOfguaranteed)
            cell.delegate = self
        case let cell as GachaDetailSimulatorCell:
            cell.setup(cardIDs: gachaCardIDs, result: gachaResult)
            cell.delegate = self
        case let cell as GachaDetailLoadingCell:
            if cell.loadingView.status == .loading {
                cell.loadingView.indicator.startAnimating()
            }
            cell.delegate = self
        default:
            break
        }
        return cell
    }
    
}

extension GachaDetailController: GachaSimulatorViewDelegate {
    func tenGacha(gachaSimulatorView: GachaSimulatorView) {
        gachaCardIDs = gacha.simulate(times: 10, srGuaranteeCount: 1)
        let ssrCount = gachaCardIDs.filter { CGSSDAO.shared.findCardById($0)?.rarityType == .ssr }.count
        let srCount = gachaCardIDs.filter { CGSSDAO.shared.findCardById($0)?.rarityType == .sr }.count
        gachaResult += GachaSimulationResult(times: 10, ssrCount: ssrCount, srCount: srCount)
        simulatorView?.setup(cardIDs: gachaCardIDs, result: gachaResult)
        
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
    
    func singleGacha(gachaSimulatorView: GachaSimulatorView) {
        gachaCardIDs = [gacha.simulateOnce(srGuarantee: false)]
        let ssrCount = gachaCardIDs.filter { CGSSDAO.shared.findCardById($0)?.rarityType == .ssr }.count
        let srCount = gachaCardIDs.filter { CGSSDAO.shared.findCardById($0)?.rarityType == .sr }.count
        gachaResult += GachaSimulationResult(times: 1, ssrCount: ssrCount, srCount: srCount)
        simulatorView?.setup(cardIDs: gachaCardIDs, result: gachaResult)
    }
    
    func gachaSimulateView(_ gachaSimulatorView: GachaSimulatorView, didClick cardIcon: CGSSCardIconView) {
        if let card = CGSSDAO.shared.findCardById(cardIcon.cardID!) {
            let vc = CardDetailViewController()
            vc.card = card
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func resetResult(gachaSimulatorView: GachaSimulatorView) {
        gachaResult = GachaSimulationResult(times: 0, ssrCount: 0, srCount: 0)
        simulatorView?.wipeResultView()
        simulatorView?.wipeResultGrid()
    }
    
}

extension GachaDetailController: CGSSIconViewDelegate {
    
    func iconClick(_ iv: CGSSIconView) {
        if let icon = iv as? CGSSCardIconView, let id = icon.cardID {
            let vc = CardDetailViewController()
            vc.card = CGSSDAO.shared.findCardById(id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension GachaDetailController: GachaDetailNewCardsCellDelegate {
    
    func navigateToFullAvailableList(gachaDetailNewCardsCell: GachaDetailNewCardsCell) {
        let vc = GachaCardTableViewController()
        vc.setup(with: gacha)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension GachaDetailController: CardDetailRelatedCardsCellDelegate {
    
    func didClickRightDetail(_ cardDetailRelatedCardsCell: CardDetailRelatedCardsCell) {
        // hided, do nothing
    }

}

extension GachaDetailController: LoadingViewDelegate {
    
    func retry(loadingView: LoadingView) {
        requestData()
    }
    
}

extension GachaDetailController: BannerContainer {

    var bannerView: BannerView? {
        let index = self.rows.enumerated().first { $0.element.type == GachaDetailBannerCell.self }?.offset
        if let index = index, let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GachaDetailBannerCell {
            return cell.banner
        } else {
            return nil
        }
    }

    var otherView: UIView? {
        return tableView
    }

}


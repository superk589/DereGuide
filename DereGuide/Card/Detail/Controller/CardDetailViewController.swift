//
//  CardDetailViewController.swift
//  DereGuide
//
//  Created by zzk on 16/6/16.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import SnapKit
import ImageViewer
import SDWebImage
import AudioToolbox

class CardDetailViewController: BaseTableViewController {
    
    var card: CGSSCard! {
        didSet {
           loadDataAsync()
        }
    }
    
    private func createGalleryItem(url: URL?) -> GalleryItem {
        let myFetchImageBlock: FetchImageBlock = { (completion) in
            guard let url = url else {
                completion(nil)
                return
            }
            SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _, _) in
                completion(image)
            })
        }
        
        let itemViewControllerBlock: ItemViewControllerBlock = { index, itemCount, fetchImageBlock, configuration, isInitialController in
            
            return GalleryImageItemBaseController(index: index, itemCount: itemCount, fetchImageBlock: myFetchImageBlock, configuration: configuration, isInitialController: isInitialController)
        }
        
        let galleryItem = GalleryItem.custom(fetchImageBlock: myFetchImageBlock, itemViewControllerBlock: itemViewControllerBlock)
        
        return galleryItem
    }
    
    lazy var items: [GalleryItem] = {
        var result = [GalleryItem]()
        
        result.append(self.createGalleryItem(url: URL(string: self.card.cardImageRef)))

        if self.card.hasSpread {
            result.append(self.createGalleryItem(url: self.card.spreadImageURL))
        }
        if self.card.hasSign {
            result.append(self.createGalleryItem(url: self.card.signImageURL))
        }
        return result
    }()
    
    fileprivate struct Row: CustomStringConvertible {
        var type: UITableViewCell.Type
        var description: String {
            return type.description()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isSpreadModeOn
    }
    
    fileprivate var rows: [Row] = []
    
    private func loadDataAsync() {
        CGSSGameResource.shared.master.getMusicInfo(charaID: card.charaId) { (songs) in
            DispatchQueue.main.async {
                self.songs = songs
                self.prepareRows()
                self.registerCells()
                self.tableView?.reloadData()
                print("load card \(self.card.id!)")
            }
        }
    }
    
    private func prepareRows() {
        rows.removeAll()
        guard let card = self.card else {
            return
        }
        rows.append(Row(type: CardDetailBasicCell.self))
        rows.append(Row(type: CardDetailAppealCell.self))
        rows.append(Row(type: CardDetailRelativeStrengthCell.self))
        if card.skill != nil {
            rows.append(Row(type: CardDetailSkillCell.self))
        }
        if card.leaderSkill != nil {
            rows.append(Row(type: CardDetailLeaderSkillCell.self))
        }
        
        rows.append(Row(type: CardDetailEvolutionCell.self))
        rows.append(Row(type: CardDetailRelatedCardsCell.self))
        
        if card.rarityType.rawValue >= CGSSRarityTypes.sr.rawValue {
            rows.append(Row(type: CardDetailSourceCell.self))
        }
        
        if songs.count > 0 {
            let row = Row(type: CardDetailMVCell.self)
            self.rows.append(row)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        tableView.estimatedRowHeight = 68
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    private func registerCells() {
        for row in rows {
            tableView
            .register(row.type, forCellReuseIdentifier: row.description)
        }
    }
    
    @available(iOS 9.0, *)
    override var previewActionItems: [UIPreviewActionItem] {
        let titleString: String
        let manager = FavoriteCardsManager.shared
        if manager.contains(card.id) {
            titleString = NSLocalizedString("取消收藏", comment: "")
        } else {
            titleString = NSLocalizedString("收藏", comment: "")
        }
        let item3 = UIPreviewAction.init(title: titleString, style: .default, handler: { (action, vc) in
            if let card = (vc as? CardDetailViewController)?.card {
                if manager.contains(card.id) {
                    manager.remove(card.id)
                } else {
                    manager.add(card)
                }
            }
        })
        return [item3]
    }
    
    func prepareToolbar() {

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if isShowing {
            setSpreadImageMode(card.hasSpread && UIDevice.current.orientation.isLandscape, animated: false)
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    fileprivate var isSpreadModeOn = false
    fileprivate func setSpreadImageMode(_ isOn: Bool, animated: Bool) {
        isSpreadModeOn = isOn
        setNeedsStatusBarAppearanceUpdate()
        
        navigationController?.setToolbarHidden(isOn, animated: animated)
        navigationController?.setNavigationBarHidden(isOn, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !isOn
        
        if animated {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        let indexPath = IndexPath(row: 0, section: 0)
        if isOn {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: animated)
        }
    }
    
    private var isShowing = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShowing = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isShowing = false
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSpreadModeOn && indexPath.row == 0 {
            return UIScreen.main.bounds.height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    private var songs = [CGSSSong]()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.description, for: indexPath)
        switch cell {
        case let cell as CardDetailSetable:
            cell.setup(with: card)
        default:
            break
        }
        
        switch cell {
        case let cell as CardDetailRelatedCardsCell:
            cell.delegate = self
        case let cell as CardDetailEvolutionCell:
            cell.delegate = self
        case let cell as CardDetailMVCell:
            cell.delegate = self
            cell.setup(songs: songs)
        default:
            break
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isSpreadModeOn {
            setSpreadImageMode(false, animated: true)
        }
    }
}

extension CardDetailViewController: CardDetailRelatedCardsCellDelegate {
    func didClickRightDetail(_ cardDetailRelatedCardsCell: CardDetailRelatedCardsCell) {
        let vc = CharDetailViewController()
        vc.chara = card.chara
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CardDetailViewController: GalleryItemsDataSource {
    
    func itemCount() -> Int {
        var count = 1
        if card.hasSpread {
            count += 1
        }
        if card.signImageURL != nil {
            count += 1
        }
        return count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return items[index]
    }
    
}

extension CardDetailViewController: CGSSIconViewDelegate {
    func iconClick(_ iv: CGSSIconView) {
        if let icon = iv as? CGSSCardIconView {
            let dao = CGSSDAO.shared
            // 如果因为数据更新导致未查找到指定的卡片, 则不弹出新页面
            if let card = dao.findCardById(icon.cardID!) {
                let cardDetailVC = CardDetailViewController()
                cardDetailVC.card = card
                // cardDetailVC.modalTransitionStyle = .CoverVertical
                self.navigationController?.pushViewController(cardDetailVC, animated: true)
            }
        }
    }
}

extension CardDetailViewController: CardDetailMVCellDelegate {
    func cardDetailMVCell(_ cardDetailMVCell: CardDetailMVCell, didClickAt index: Int) {
        let vc = SongDetailController()
        vc.setup(songs: songs, index: index)
        navigationController?.pushViewController(vc, animated: true)
    }
}

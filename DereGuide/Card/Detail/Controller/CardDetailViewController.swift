//
//  CardDetailViewController.swift
//  DereGuide
//
//  Created by zzk on 16/6/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import ImageViewer
import SDWebImage

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
    
    fileprivate func createGalleryViewController(startIndex: Int) -> GalleryViewController {
        let config = [
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            GalleryConfigurationItem.closeLayout(.pinLeft(32, 20)),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(true),
            GalleryConfigurationItem.deleteButtonMode(.none),
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            GalleryConfigurationItem.swipeToDismissMode(.vertical)
        ]
        let vc = GalleryViewController(startIndex: startIndex, itemsDataSource: self, itemsDelegate: nil, displacedViewsDataSource: self, configuration: config)
        return vc
    }
    
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
    
    var spreadImageView: SpreadImageView? {
        return (self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CardDetailSpreadImageCell)?.spreadImageView
    }
    
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
        if card.hasSpread {
            rows.append(Row(type: CardDetailSpreadImageCell.self))
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

        // 自定义titleView的文字大小
        let titleView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        titleView.text = card.name
        titleView.font = UIFont.systemFont(ofSize: 12)
        titleView.textAlignment = .center
        titleView.adjustsFontSizeToFitWidth = true
        titleView.baselineAdjustment = .alignCenters
        navigationItem.titleView = titleView
        
        // let rightItem = UIBarButtonItem.init(title: CGSSFavoriteManager.defaultManager.contains(card.id!) ? "取消":"收藏", style: .Plain, target: self, action: #selector(addOrRemoveFavorite))
        let rightItem = UIBarButtonItem.init(image: FavoriteCardsManager.shared.contains(card.id) ? UIImage.init(named: "748-heart-toolbar-selected") : UIImage.init(named: "748-heart-toolbar"), style: .plain, target: self, action: #selector(addOrRemoveFavorite))
        rightItem.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = rightItem
        
        // let leftItem = UIBarButtonItem.init(title: "返回", style: .Plain, target: self, action: #selector(backAction))
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = leftItem
        
        prepareToolbar()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 68
        tableView.tableFooterView = UIView()
    }
    
    private func registerCells() {
        for row in rows {
            tableView
            .register(row.type, forCellReuseIdentifier: row.description)
        }
    }
    
    // 添加当前卡到收藏
    @objc func addOrRemoveFavorite() {
        let manager = FavoriteCardsManager.shared
        if !manager.contains(card.id) {
            manager.add(card)
            self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar-selected")
        } else {
            manager.remove(card.id)
            self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar")
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
//        let item1 = UIBarButtonItem.init(title: NSLocalizedString("3D模型", comment: ""), style: .plain, target: self, action: #selector(show3DModelAction))
//        let spaceItem1 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item2 = UIBarButtonItem.init(title: NSLocalizedString("卡片图", comment: ""), style: .plain, target: self, action: #selector(showCardImageAction))
        let spaceItem2 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item3 = UIBarButtonItem.init(title: NSLocalizedString("签名图", comment: ""), style: .plain, target: self, action: #selector(showSignImageAction))

        if card.signImageURL == nil {
            item3.isEnabled = false
        }
        toolbarItems = [item2, spaceItem2, item3]
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
    
    @objc func showCardImageAction() {
        let vc = createGalleryViewController(startIndex: 0)
        presentImageGallery(vc)
    }
    
    @objc func showSignImageAction() {
        let vc = createGalleryViewController(startIndex: 2)
        presentImageGallery(vc)
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
        case let cell as CardDetailSpreadImageCell:
            cell.delegate = self
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

extension CardDetailViewController: CardDetailSpreadImageCellDelegate {
    func cardDetailSpreadImageCell(_ cardDetailSpreadImageCell: CardDetailSpreadImageCell, longPressAt point: CGPoint) {
        
        guard let image = cardDetailSpreadImageCell.spreadImageView.image else {
            return
        }
        // 作为被分享的内容 不能是可选类型 否则分享项不显示
        let urlArray = [image]
        let activityVC = UIActivityViewController.init(activityItems: urlArray, applicationActivities: nil)
        let excludeActivitys:[UIActivityType] = []
        activityVC.excludedActivityTypes = excludeActivitys
        activityVC.popoverPresentationController?.sourceView = cardDetailSpreadImageCell.spreadImageView
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: point.x, y: point.y, width: 0, height: 0)
        present(activityVC, animated: true, completion: nil)
    }
    
    func tappedCardDetailSpreadImageCell(_ cardDetailSpreadImageCell: CardDetailSpreadImageCell) {
        let vc = createGalleryViewController(startIndex: 1)
        presentImageGallery(vc)
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

extension CardDetailViewController: GalleryDisplacedViewsDataSource {
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        if index == 1 {
            return spreadImageView
        } else {
            return nil
        }
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

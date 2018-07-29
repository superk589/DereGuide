//
//  CDImageViewController.swift
//  DereGuide
//
//  Created by zzk on 2018/5/22.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SDWebImage
import ImageViewer

class CDImageViewController: UITableViewController, CDImageTableViewCellDelegate {
    
    struct Row {
        enum Model {
            case album(String, [URL])
        }
        var type: UITableViewCell.Type
        var data: Model
    }
    
    private func createGalleryItem(_ url: URL?) -> GalleryItem {
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
            return ItemBaseController<UIImageView>(index: index, itemCount: itemCount, fetchImageBlock: myFetchImageBlock, configuration: configuration, isInitialController: isInitialController)
        }
        let galleryItem = GalleryItem.custom(fetchImageBlock: myFetchImageBlock, itemViewControllerBlock: itemViewControllerBlock)
        return galleryItem
    }
    
    var items = [GalleryItem]()
    
    private func createGalleryViewController(startIndex: Int, image: UIImage?) -> GalleryViewController {
        let config = [
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            GalleryConfigurationItem.closeLayout(.pinLeft(32, 20)),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(true),
            GalleryConfigurationItem.spinnerColor(.white),
            GalleryConfigurationItem.deleteButtonMode(.none),
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.activityViewByLongPress(true),
            GalleryConfigurationItem.placeHolderImage(image)
        ]
        let vc = GalleryViewController(startIndex: startIndex, itemsDataSource: self, itemsDelegate: nil, displacedViewsDataSource: self, configuration: config)
        return vc
    }
    
    private var urls = [URL]()
    
    private var staticCells = [UITableViewCell]()
    
    private var rows = [Row]()
    
    func prepareRows(for card: CGSSCard) {

        rows.removeAll()
        
        if let spreadImageURL = card.spreadImageURL {
            rows.append(Row(type: CDImageTableViewCell.self, data: .album(NSLocalizedString("大图", comment: ""), [spreadImageURL])))
        }
        
        if let signImageURL = card.signImageURL {
            rows.append(Row(type: CDImageTableViewCell.self, data: .album(NSLocalizedString("签名", comment: ""), [signImageURL])))
        }
        
        if let cardImageURL = card.cardImageURL {
            rows.append(Row(type: CDImageTableViewCell.self, data: .album(NSLocalizedString("卡片图", comment: ""), [cardImageURL])))
        }
        
        if let spriteImageURL = card.spriteImageURL {
            rows.append(Row(type: CDImageTableViewCell.self, data: .album(NSLocalizedString("Sprite", comment: ""), [spriteImageURL])))
        }
        
        urls = rows.flatMap { (row) -> [URL] in
            if case .album(_, let urls) = row.data {
                return urls
            } else {
                return []
            }
        }
        items = urls.map { createGalleryItem($0) }
        
        staticCells = rows.map {
            let cell = $0.type.init() as! CDImageTableViewCell
            if case .album(let title, let urls) = $0.data {
                cell.configure(for: urls, title: title)
            }
            cell.delegate = self
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staticCells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return staticCells[indexPath.row]
    }
    
    func cdImageTableViewCell(_ cdImageTableViewCell: CDImageTableViewCell, didSelect imageView: UIImageView, url: URL?) {
        if let index = urls.index(where: { $0.absoluteString == String(url?.absoluteString.split(separator: "@").first ?? "") }) {
            let vc = createGalleryViewController(startIndex: index, image: imageView.image)
            presentImageGallery(vc)
        }
    }
    
}

extension CDImageViewController: GalleryItemsDataSource {
    
    func itemCount() -> Int {
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return items[index]
    }
    
}

extension CDImageViewController: GalleryDisplacedViewsDataSource {
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        let url = urls[index]
        var row: Int?
        var item: Int?
        for i in 0..<rows.count {
            if case .album(_, let urls) = rows[i].data {
                if let index = urls.index(where: { $0 == url }) {
                    item = index
                    row = i
                    break
                }
            }
        }
        if let row = row, let item = item {
            let indexPath = IndexPath(row: row, section: 0)
            if let tableViewCell = tableView.cellForRow(at: indexPath) as? CDImageTableViewCell,
                let imageView = tableViewCell.stackView.arrangedSubviews[item] as? CDImageView {
                return imageView
            }
        }
        return nil
    }
    
}

extension UIImageView: DisplaceableView {}

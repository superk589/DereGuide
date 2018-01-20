//
//  SongDetailController.swift
//  DereGuide
//
//  Created by zzk on 04/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

protocol SongDetailControllerDelegate: class {
    func songDetailController(_ songDetailController: SongDetailController, changedCurrentIndexTo index: Int)
}

class SongDetailController: BaseTableViewController, BannerContainer {
    
    var bannerView: BannerView? {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SongDetailCoverFlowCell
        let innerCell = cell?.collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? SongJacketCollectionViewCell
        return innerCell?.jacketImageView
    }
    
    var otherView: UIView? {
        return tableView
    }
    
    weak var delegate: SongDetailControllerDelegate?
    
    var songs = [CGSSSong]()
    
    var currentIndex: Int! {
        didSet {
            if oldValue != currentIndex {
                reload()
                delegate?.songDetailController(self, changedCurrentIndexTo: currentIndex)
            }
        }
    }
    
    var currentSong: CGSSSong {
        return songs[currentIndex]
    }
    
    let titleLabel = UILabel()
    
    private var currentFavoriteImage: UIImage? {
        return FavoriteSongsManager.shared.contains(currentSong.musicID) ? UIImage.init(named: "748-heart-toolbar-selected") : UIImage.init(named: "748-heart-toolbar")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightItem = UIBarButtonItem.init(image: currentFavoriteImage, style: .plain, target: self, action: #selector(addOrRemoveFavorite))
        rightItem.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = rightItem
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.baselineAdjustment = .alignCenters
        navigationItem.titleView = titleLabel

        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(SongDetailCoverFlowCell.self, forCellReuseIdentifier: SongDetailCoverFlowCell.description())
        tableView.register(SongDetailHeaderCell.self, forCellReuseIdentifier: SongDetailHeaderCell.description())
        tableView.register(SongDetailDescriptionCell.self, forCellReuseIdentifier: SongDetailDescriptionCell.description())
        tableView.register(SongDetailPositionCell.self, forCellReuseIdentifier: SongDetailPositionCell.description())
        tableView.register(SongDetailLiveCell.self, forCellReuseIdentifier: SongDetailLiveCell.description())
        
        // fix on iOS 9, after custom transition, tableView may have wrong origin
        if tableView.frame.origin.y != 0 {
            tableView.frame.origin.y = 0
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.userInterfaceIdiom == .pad {
            let index = currentIndex
            coordinator.animate(alongsideTransition: { (context) in
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SongDetailCoverFlowCell
                cell.collectionView.performBatchUpdates({
                    cell.collectionView.contentOffset.x = CGFloat(index ?? 0) * size.width
                    cell.collectionView.performBatchUpdates(nil, completion: nil)
                }, completion: { finished in
                    cell.collectionView.collectionViewLayout.invalidateLayout()
                })
            }, completion: nil)
        }
    }
    
    @objc func addOrRemoveFavorite() {
        let manager = FavoriteSongsManager.shared
        if !manager.contains(currentSong.musicID) {
            manager.add(currentSong)
        } else {
            manager.remove(currentSong.musicID)
        }
        navigationItem.rightBarButtonItem?.image = currentFavoriteImage
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func setup(songs: [CGSSSong], index: Int) {
        self.songs = songs
        self.currentIndex = index
        titleLabel.text = currentSong.name
    }
    
    private func reload() {
        titleLabel.text = currentSong.name
        titleLabel.setNeedsUpdateConstraints()
        tableView.reloadRows(at: [1, 2, 3, 4].map { IndexPath.init(row: $0, section: 0) }, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SongDetailCoverFlowCell.description(), for: indexPath) as! SongDetailCoverFlowCell
            cell.collectionView.register(SongJacketCollectionViewCell.self, forCellWithReuseIdentifier: SongJacketCollectionViewCell.description())
            cell.layoutIfNeeded()
            cell.delegate = self
            cell.index = currentIndex
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SongDetailHeaderCell.description(), for: indexPath) as! SongDetailHeaderCell
            cell.setup(song: currentSong)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: SongDetailDescriptionCell.description(), for: indexPath) as! SongDetailDescriptionCell
            cell.setup(text: currentSong.detail)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: SongDetailPositionCell.description(), for: indexPath) as! SongDetailPositionCell
            cell.setup(song: currentSong)
            cell.delegate = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: SongDetailLiveCell.description(), for: indexPath) as! SongDetailLiveCell
            cell.setup(song: currentSong)
            cell.delegate = self
            return cell
        default:
            fatalError("invalid index")
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 152
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 152
        default:
            return 80
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

extension SongDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongJacketCollectionViewCell.description(), for: indexPath) as! SongJacketCollectionViewCell
        let song = songs[indexPath.item]
        cell.setup(song: song)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            let index = scrollView.contentOffset.x / scrollView.frame.width
            if index == CGFloat(floor(index)) {
                currentIndex = Int(index)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.superview!.frame.width, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension SongDetailController: SongDetailPositionCellDelegate {
    func songDetailPositionCell(_ songDetailPositionCell: SongDetailPositionCell, didClickAt charaID: Int) {
        if let chara = CGSSDAO.shared.findCharById(charaID) {
            let vc = CharDetailViewController()
            vc.chara = chara
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SongDetailController: SongDetailLiveCellDelegate {
    func songDetailLiveCell(_ songDetailLiveCell: SongDetailLiveCell, didSelect liveScene: CGSSLiveScene) {
        let vc = BeatmapViewController()
        vc.setup(with: liveScene)
        navigationController?.pushViewController(vc, animated: true)
    }
}

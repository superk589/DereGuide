//
//  SongViewController.swift
//  DereGuide
//
//  Created by zzk on 04/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class SongViewController: BaseModelCollectionViewController, BannerAnimatorProvider, BannerContainer {
    
    var defaultList: [CGSSSong]!
    var songs = [CGSSSong]()

    var filter: CGSSSongFilter {
        set {
            CGSSSorterFilterManager.default.songFilter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.songFilter
        }
    }
    
    var sorter: CGSSSorter {
        set {
            CGSSSorterFilterManager.default.songSorter = newValue
        }
        get {
            return CGSSSorterFilterManager.default.songSorter
        }
    }
   
    lazy var filterVC: SongFilterSortController = {
        let vc = SongFilterSortController()
        vc.filter = self.filter
        vc.sorter = self.sorter
        vc.delegate = self
        return vc
    }()
    
    lazy var bannerAnimator: BannerAnimator = {
        let animator = BannerAnimator()
        return animator
    }()
    
    var bannerView: BannerView?
    
    var otherView: UIView?
    
    private func reloadLayout() {
        let itemPerRow = floor(Screen.width / 152)
        let interval = (Screen.width - 132 * itemPerRow) / (itemPerRow + 1)
        let size = CGSize(width: 132 + interval, height: 132 + 94)
        layout.itemSize = size
        layout.sectionInset = UIEdgeInsets(top: interval - 10, left: interval / 2, bottom: interval - 10, right: interval / 2)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: SongCollectionViewCell.description())
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        reloadLayout()
        // 初始化导航栏的搜索条
        if #available(iOS 11.0, *) {
            navigationItem.titleView = searchBarWrapper
        } else {
            navigationItem.titleView = searchBar
        }
        searchBar.placeholder = NSLocalizedString("歌曲名/词曲作者/演唱者", comment: "")
        
        let item1 = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = item1
        
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNeedsReloadData), name: .gameResoureceProcessedEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setNeedsReloadData), name: .favoriteCardsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged(notification:)), name: .dataRemoved, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func checkUpdate() {
        check([.master, .beatmap])
    }
    
    override func updateUI() {
        filter.searchText = searchBar.text ?? ""
        songs = filter.filter(defaultList)
        sorter.sortList(&songs)
        collectionView?.reloadData()
    }
    
    override func reloadData() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            CGSSGameResource.shared.master.getMusicInfo(callback: { (songs) in
                self?.defaultList = songs
                DispatchQueue.main.async {
                    CGSSLoadingHUDManager.default.hide()
                    self?.updateUI()
                }
            })
        }
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
   
    @objc func dataChanged(notification: Notification) {
        if let types = notification.userInfo?[CGSSUpdateDataTypesName] as? CGSSUpdateDataTypes {
            if types.contains(.master) {
                self.setNeedsReloadData()
            }
        }
    }
    
    @objc func filterAction() {
        drawerController?.show(.right, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let drawer = drawerController
        drawer?.rightViewController = filterVC
        drawer?.delegate = self
        drawer?.defaultRightWidth = min(view.shortSide - 68, 400)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        drawerController?.rightViewController = nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if drawerController?.rightViewController == filterVC {
            drawerController?.defaultRightWidth = min(size.shortSide - 68, 400)
        }
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.collectionView.performBatchUpdates({
                self?.reloadLayout()
            }, completion: nil)
            //self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: { finished in
            if let selected = self.collectionView.indexPathsForSelectedItems?.first {
                if !self.collectionView.indexPathsForVisibleItems.contains(selected) {
                    self.bannerView = nil
                }
            }
        })
    }
    
    
    // MARK: - CollectionView dataSource and delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongCollectionViewCell.description(), for: indexPath) as! SongCollectionViewCell
        cell.setup(song: songs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SongCollectionViewCell {
            bannerView = cell.jacketImageView
        }
        let vc = SongDetailController()
        vc.delegate = self
        vc.setup(songs: songs, index: indexPath.item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: ZKDrawerControllerDelegate
extension SongViewController: ZKDrawerControllerDelegate {
    
    func drawerController(_ drawerVC: ZKDrawerController, didHide vc: UIViewController) {
        
    }
    
    func drawerController(_ drawerVC: ZKDrawerController, willShow vc: UIViewController) {
        filterVC.filter = self.filter
        filterVC.sorter = self.sorter
        filterVC.reloadData()
    }
    
}

extension SongViewController: SongFilterSortControllerDelegate {
  
    func doneAndReturn(filter: CGSSSongFilter, sorter: CGSSSorter) {
        CGSSSorterFilterManager.default.songFilter = filter
        CGSSSorterFilterManager.default.songSorter = sorter
        CGSSSorterFilterManager.default.saveForSong()
        updateUI()
    }
    
}


extension SongViewController: SongDetailControllerDelegate {
    
    func songDetailController(_ songDetailController: SongDetailController, changedCurrentIndexTo index: Int) {
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SongCollectionViewCell
        bannerView = cell?.jacketImageView
    }
    
}

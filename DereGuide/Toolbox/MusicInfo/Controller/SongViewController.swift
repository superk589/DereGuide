//
//  SongViewController.swift
//  DereGuide
//
//  Created by zzk on 04/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class SongViewController: BaseModelCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var defaultList: [CGSSSong]!
    var songs = [CGSSSong]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .white
        collectionView?.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: SongCollectionViewCell.description())
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        // 初始化导航栏的搜索条
        navigationItem.titleView = searchBar
        searchBar.placeholder = NSLocalizedString("歌曲名/词曲作者/演唱者", comment: "")
        
        let item1 = UIBarButtonItem.init(image: #imageLiteral(resourceName: "798-filter-toolbar"), style: .plain, target: self, action: #selector(filterAction))
        navigationItem.rightBarButtonItem = item1
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNeedsReloadData), name: .gameResoureceProcessedEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setNeedsReloadData), name: .favoriteCardsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged(notification:)), name: .dataRemoved, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func checkUpdate() {
        check(.master)
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
        drawer?.defaultRightWidth = min(Screen.shortSide - 68, 400)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        drawerController?.rightViewController = nil
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


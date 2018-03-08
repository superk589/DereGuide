//
//  RefreshableTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import MJRefresh

protocol Refreshable {
    var refresher: MJRefreshHeader { get set }
    func check(_ types: CGSSUpdateDataTypes)
    func checkUpdate()
}

extension Refreshable where Self: UIViewController {
    
    func check(_ types: CGSSUpdateDataTypes) {
        let updater = CGSSUpdater.default
        let vm = CGSSVersionManager.default
        let dao = CGSSDAO.shared
        let hm = CGSSUpdatingHUDManager.shared
        let gr = CGSSGameResource.shared
        defer {
            refresher.endRefreshing()
        }
        if updater.isWorking || gr.isProcessing { return }
        
        func doUpdating(types: CGSSUpdateDataTypes) {
            DispatchQueue.main.async {
                hm.show()
                hm.cancelAction = {
                    updater.cancelCurrentSession()
                }
                hm.setup(NSLocalizedString("检查更新中", comment: "更新框"), animated: true, cancelable: true)
            }
            updater.checkUpdate(dataTypes: types, complete: { [weak self] (items, errors) in
                if !errors.isEmpty && items.count == 0 {
                    hm.hide(animated: false)
                    var errorStr = ""
                    if let error = errors.first as? CGSSUpdaterError {
                        errorStr.append(error.localizedDescription)
                    } else if let error = errors.first {
                        errorStr.append(error.localizedDescription)
                    }
                    let alert = UIAlertController.init(title: NSLocalizedString("检查更新失败", comment: "更新框")
                        , message: errorStr, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
                    self?.tabBarController?.present(alert, animated: true, completion: nil)
                } else {
                    if items.count == 0 {
                        hm.setup(NSLocalizedString("数据是最新版本", comment: "更新框"), animated: false, cancelable: false)
                        hm.hide(animated: true)
                    } else {
                        hm.show()
                        hm.setup(current: 0, total: items.count, animated: true, cancelable: true)
                        updater.updateItems(items, progress: { processed, total in
                            hm.setup(current: processed, total: total, animated: true, cancelable: true)
                        }) { success, total in
                            hm.show()
                            hm.setup(NSLocalizedString("正在完成更新", comment: "更新框"), animated: true, cancelable: false)
                            DispatchQueue.global(qos: .userInitiated).async {
                                gr.processDownloadedData(types: CGSSUpdateDataTypes(items.map { $0.dataType }), completion: {
                                    let alert = UIAlertController.init(title: NSLocalizedString("更新完成", comment: "弹出框标题"), message: "\(NSLocalizedString("成功", comment: "通用")) \(success), \(NSLocalizedString("失败", comment: "通用")) \(total - success)", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
                                    UIViewController.root?.present(alert, animated: true, completion: nil)
                                    hm.hide(animated: false)
                                })
                            }
                        }
                    }
                }
            })
        }
        
        func confirmToUpdate(reason: String?, newVersion: Version, cancelable: Bool) {
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: NSLocalizedString("数据需要更新", comment: "弹出框标题"), message: reason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: { (alertAction) in
                    vm.dataVersion = newVersion
                    doUpdating(types: types)
                }))
                if cancelable {
                    alert.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: "弹出框按钮"), style: .cancel, handler: nil))
                }
                self?.tabBarController?.present(alert, animated: true, completion: nil)
            }
        }
        
        if types.contains(.card) {
            updater.checkRemoteDataVersion(callback: { payload, error in
                
                // firstly, we check remote data version
                if let payload = payload, let version = Version(string: payload.version) {
                    
                    // if remote data version's major is greater than local version, remove all data then re-download.
                    if vm.dataVersion.major < version.major {
                        dao.removeAllData()
                        let reason: String?
                        if vm.dataVersion == Version(1, 0, 0) || payload.localizedReason == nil {
                            reason = NSLocalizedString("数据主版本过低，请点击确定开始更新", comment: "")
                        } else {
                            reason = payload.localizedReason
                        }
                        confirmToUpdate(reason: reason, newVersion: version, cancelable: false)
                        
                    // else if remote data version's minor is greater than local version, recommend user to update all data
                    } else if vm.dataVersion.minor < version.minor {
                        let reason: String?
                        if vm.dataVersion == Version(1, 0, 0) || payload.localizedReason == nil {
                            reason = NSLocalizedString("数据存在新版本，推荐进行更新，请点击确定开始更新", comment: "")
                        } else {
                            reason = payload.localizedReason
                        }
                        confirmToUpdate(reason: reason, newVersion: version, cancelable: true)
                        
                    // else if remote data version's patch is greater than local version, remove the items only in patch items array, then re-download them.
                    } else if vm.dataVersion.patch < version.patch {
                        for item in payload.items {
                            switch item.type {
                            case .card:
                                dao.cardDict.removeObject(forKey: item.id)
                            case .chara:
                                if let id = Int(item.id) {
                                    let cards = dao.findCardsByCharId(id)
                                    dao.cardDict.removeObjects(forKeys: cards.map { String($0.id) })
                                }
                            default:
                                break
                            }
                        }
                        vm.dataVersion = version
                        doUpdating(types: types)
                        
                    // finally, only check patch items to make sure they are all updated to the newest version
                    } else {
                        for item in payload.items {
                            switch item.type {
                            case .card:
                                if let id = Int(item.id), let card = dao.findCardById(id), card.dataVersion < version {
                                    dao.cardDict.removeObject(forKey: item.id)
                                }
                            case .chara:
                                if let id = Int(item.id) {
                                    let cards = dao.findCardsByCharId(id)
                                    dao.cardDict.removeObjects(forKeys: cards.flatMap {
                                        if $0.dataVersion < version {
                                            return String($0.id)
                                        } else {
                                            return nil
                                        }
                                    })
                                }
                            default:
                                break
                            }
                        }
                        vm.dataVersion = version
                        doUpdating(types: types)
                    }
                    
                // if we can't get remote data version(eg. network error), check the local minimum supported version
                } else {
                    
                    // if local minimum supported version's major is greater than local version, remove all data and re-download
                    if vm.dataVersion.major < vm.minimumSupportedDataVersion.major {
                        dao.removeAllData()
                        let reason = NSLocalizedString("数据主版本过低，请点击确定开始更新", comment: "")
                        confirmToUpdate(reason: reason, newVersion: vm.minimumSupportedDataVersion, cancelable: false)
                        
                    // else if local minimum supported version's minor is greater than local version. recommand user to update
                    } else if vm.dataVersion.minor < vm.minimumSupportedDataVersion.minor {
                        let reason = NSLocalizedString("数据存在新版本，推荐进行更新，请点击确定开始更新", comment: "")
                        confirmToUpdate(reason: reason, newVersion: vm.minimumSupportedDataVersion, cancelable: true)
                    
                    // finally, do normal updating, because local minimum supported version has no patch information.
                    } else {
                        doUpdating(types: types)
                    }
                }
            })
        } else {
            doUpdating(types: types)
        }
    }

}

class RefreshableTableViewController: BaseTableViewController, Refreshable {
    
    var refresher: MJRefreshHeader = CGSSRefreshHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.checkUpdate() }
    }
    
    func checkUpdate() {
        
    }
   
}

class RefreshableCollectionViewController: BaseViewController, Refreshable {
    
    var refresher: MJRefreshHeader = CGSSRefreshHeader()
    
    var layout: UICollectionViewFlowLayout!
    
    var collectionView: UICollectionView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionView.mj_header = refresher
        refresher.refreshingBlock = { [weak self] in self?.checkUpdate() }
    }
    
    func checkUpdate() {
        
    }

}

extension RefreshableCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

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
    func cancelUpdate()
}

extension Refreshable where Self: UIViewController {
    
    func check(_ types: CGSSUpdateDataTypes) {
        let updater = CGSSUpdater.default
        defer {
            refresher.endRefreshing()
        }
        if updater.isWorking { return }
        CGSSUpdatingHUDManager.shared.show()
        CGSSUpdatingHUDManager.shared.cancelAction = { [weak self] in self?.cancelUpdate() }
        CGSSUpdatingHUDManager.shared.setup(NSLocalizedString("检查更新中", comment: "更新框"), animated: true, cancelable: true)
        updater.checkUpdate(dataTypes: types, complete: { [weak self] (items, errors) in
            if !errors.isEmpty && items.count == 0 {
                CGSSUpdatingHUDManager.shared.hide(animated: false)
                var errorStr = ""
                if let error = errors.first as? CGSSUpdaterError {
                    errorStr.append(error.localizedDescription)
                } else if let error = errors.first {
                    errorStr.append(error.localizedDescription)
                }
                let alert = UIAlertController.init(title: NSLocalizedString("检查更新失败", comment: "更新框")
                    , message: errorStr, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
                // 使用tabBarController来展现UIAlertController的原因是, 该方法处于异步子线程中,当执行时可能这个ViewController已经不在前台,会造成不必要的警告(虽然不会崩溃,但是官方不建议这样)
                self?.tabBarController?.present(alert, animated: true, completion: nil)
            } else {
                if items.count == 0 {
                    CGSSUpdatingHUDManager.shared.setup(NSLocalizedString("数据是最新版本", comment: "更新框"), animated: false, cancelable: false)
                    CGSSUpdatingHUDManager.shared.hide(animated: true)
                    CGSSVersionManager.default.setDataVersionToNewest()
                    CGSSVersionManager.default.setApiVersionToNewest()
                } else {
                    CGSSUpdatingHUDManager.shared.setup(current: 0, total: items.count, animated: true, cancelable: true)
                    updater.updateItems(items, progress: { processed, total in
                        CGSSUpdatingHUDManager.shared.setup(current: processed, total: total, animated: true, cancelable: true)
                    }) { success, total in
                        CGSSUpdatingHUDManager.shared.setup(NSLocalizedString("正在完成更新", comment: "更新框"), animated: true, cancelable: false)
                        DispatchQueue.global(qos: .userInitiated).async {
                            CGSSGameResource.shared.processDownloadedData(types: CGSSUpdateDataTypes(items.map { $0.dataType }), completion: {
                                let alert = UIAlertController.init(title: NSLocalizedString("更新完成", comment: "弹出框标题"), message: "\(NSLocalizedString("成功", comment: "通用")) \(success), \(NSLocalizedString("失败", comment: "通用")) \(total - success)", preferredStyle: .alert)
                                alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
                                UIViewController.root?.present(alert, animated: true, completion: nil)
                                CGSSUpdatingHUDManager.shared.hide(animated: false)
                            })
                        }
                    }
                }
            }
        })
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
    
    func cancelUpdate() {
        CGSSUpdater.default.cancelCurrentSession()
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
    
    func cancelUpdate() {
        CGSSUpdater.default.cancelCurrentSession()
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

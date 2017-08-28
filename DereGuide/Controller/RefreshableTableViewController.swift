//
//  RefreshableTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol Refreshable {
    var refresher: UIRefreshControl { get set }
    var updateStatusView: UpdateStatusView { get set }
    func check(_ type: CGSSUpdateDataTypes)
    func checkUpdate()
}

extension Refreshable where Self: UIViewController {
    
    func check(_ types: CGSSUpdateDataTypes) {
        let updater = CGSSUpdater.default
        if updater.isUpdating {
            refresher.endRefreshing()
            return
        }
        self.updateStatusView.setContent(NSLocalizedString("检查更新中", comment: "更新框"), hasProgress: false)
        updater.checkUpdate(dataTypes: types, complete: { [weak self] (items, errors) in
            if !errors.isEmpty && items.count == 0 {
                self?.updateStatusView.isHidden = true
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
                    self?.updateStatusView.setContent(NSLocalizedString("数据是最新版本", comment: "更新框"), hasProgress: false)
                    self?.updateStatusView.loadingView.stopAnimating()
                    UIView.animate(withDuration: 2.5, animations: {
                        self?.updateStatusView.alpha = 0
                    })
                    updater.setVersionToNewest()
                } else {
                    self?.updateStatusView.setContent(NSLocalizedString("更新数据中", comment: "更新框"), total: items.count)
                    updater.updateItems(items, progress: { [weak self] (process, total) in
                        self?.updateStatusView.updateProgress(process, b: total)
                        }, complete: { [weak self] (success, total) in
                            let alert = UIAlertController.init(title: NSLocalizedString("更新完成", comment: "弹出框标题"), message: "\(NSLocalizedString("成功", comment: "通用")) \(success), \(NSLocalizedString("失败", comment: "通用")) \(total-success)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
                            self?.tabBarController?.present(alert, animated: true, completion: nil)
                            self?.updateStatusView.isHidden = true
                    })
                }
            }
        })
        refresher.endRefreshing()
    }
}

class RefreshableTableViewController: BaseTableViewController, UpdateStatusViewDelegate, Refreshable {
    
    var refresher = UIRefreshControl()
    var updateStatusView = UpdateStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString.init(string: NSLocalizedString("下拉检查更新", comment: "下拉刷新文字"))
        refreshControl = refresher
        refresher.addTarget(self, action: #selector(checkUpdate), for: .valueChanged)
        
        updateStatusView = UpdateStatusView()
        updateStatusView.isHidden = true
        updateStatusView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(updateStatusView)
        updateStatusView.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-95)
        }
    }
    
    @objc func checkUpdate() {
        
    }
    
    func cancelUpdate() {
        CGSSUpdater.default.cancelCurrentSession()
    }
    
    // 当该页面作为二级页面被销毁时 仍有未完成的下载任务时 强行终止下载(作为tabbar的一级页面时 永远不会销毁 不会触发此方法)
    deinit {
        if !self.updateStatusView.isHidden {
            updateStatusView.isHidden = true
            cancelUpdate()
        }
    }
}


@available(iOS 10.0, *)
class RefreshableCollectionViewController: UICollectionViewController, UpdateStatusViewDelegate, Refreshable {
    
    var refresher = UIRefreshControl()
    var updateStatusView = UpdateStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString.init(string: NSLocalizedString("下拉检查更新", comment: "下拉刷新文字"))
        
        collectionView?.refreshControl = refresher
        refresher.addTarget(self, action: #selector(checkUpdate), for: .valueChanged)
        
        updateStatusView = UpdateStatusView()
        updateStatusView.isHidden = true
        updateStatusView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(updateStatusView)
        updateStatusView.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-95)
        }
    }
    
    @objc func checkUpdate() {
        
    }
    
    func cancelUpdate() {
        CGSSUpdater.default.cancelCurrentSession()
    }
    
    // 当该页面作为二级页面被销毁时 仍有未完成的下载任务时 强行终止下载(作为tabbar的一级页面时 永远不会销毁 不会触发此方法)
    deinit {
        if !self.updateStatusView.isHidden {
            updateStatusView.isHidden = true
            cancelUpdate()
        }
    }
}

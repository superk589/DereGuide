//
//  BaseModelCollectionViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/6.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class BaseModelCollectionViewController: RefreshableCollectionViewController {

    lazy var searchBar: CGSSSearchBar = {
        let bar = CGSSSearchBar()
        bar.delegate = self
        return bar
    }()
    
    private var needsReloadData = true
    private var isShowing = false
    
    // called after search text changed, must to be overrided
    func updateUI() { }
    
    // called if needsReloadData is true when text changed, must to be overrided
    func reloadData() { }
    
    func setNeedsReloadData() {
        needsReloadData = true
        if isShowing {
            reloadDataIfNeeded()
        }
    }
    
    func reloadDataIfNeeded() {
        if needsReloadData {
            reloadData()
            needsReloadData = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isShowing = true
        reloadDataIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isShowing = false
        searchBar.resignFirstResponder()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 滑动时取消输入框的第一响应者
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

//MARK: UISearchBarDelegate
@available(iOS 10.0, *)
extension BaseModelCollectionViewController: UISearchBarDelegate {
    
    // 文字改变时
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateUI()
    }
    
    //    // 开始编辑时
    //    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    //        return true
    //    }
    //
    // 点击搜索按钮时
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //    // 点击searchbar自带的取消按钮时
    //    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //
    //    }
}

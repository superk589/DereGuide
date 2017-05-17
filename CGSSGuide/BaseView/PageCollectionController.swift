//
//  PageCollectionController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol PageCollectionControllerContainable: class {
    weak var pageCollectionController: PageCollectionController? { get }
}

extension PageCollectionControllerContainable where Self: UIViewController {
    weak var pageCollectionController: PageCollectionController? {
        return self.parent as? PageCollectionController
    }
}

protocol PageCollectionControllerDataSource: class {
    func numberOfPages(_ pageCollectionController: PageCollectionController) -> Int
    func pageCollectionController(_ pageCollectionController: PageCollectionController, viewControllerAt indexPath: IndexPath) -> UIViewController
    func titlesOfPages(_ pageCollectionController: PageCollectionController) -> [String]
}

class PageCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var titleView: PageTitleView!
    var collectionView: PageCollectionView!
    var titleHeight: CGFloat = 30 {
        didSet {
            titleView?.snp.updateConstraints { (update) in
                update.height.equalTo(titleHeight)
            }
        }
    }

    weak var dataSource: PageCollectionControllerDataSource? {
        didSet {
            collectionView.reloadData()
            titleView.titles = dataSource?.titlesOfPages(self) ?? [String]()
            titleView.reloadSubviews()
        }
    }

    var currentIndex: Int {
        set {
            titleView.currentIndex = newValue
            collectionView.contentOffset.x = collectionView.fwidth * CGFloat(newValue)
        }
        get {
            return titleView.currentIndex
        }
    }


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        collectionView = PageCollectionView(frame: view.frame)
        view.addSubview(collectionView)
        
        titleView = PageTitleView()
        view.addSubview(titleView)
        
        titleView.snp.makeConstraints { (make) in
            make.height.equalTo(titleHeight)
            make.top.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func pageTitleView(_ pageTitleView: PageTitleView, didSelectAtIndex index: Int) {
        self.collectionView.contentOffset.x = CGFloat(index) * self.collectionView.fwidth
//        UIView.animate(withDuration: 0.25, animations: {
//            self.collectionView.contentOffset.x = CGFloat(index) * self.collectionView.fwidth - (CGFloat(index) * self.collectionView.fwidth - self.collectionView.contentOffset.x) * 0.001
//        }) { (finished) in
//            self.collectionView.contentOffset.x = CGFloat(index) * self.collectionView.fwidth
//        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfPages(self) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath)
        if let vc = dataSource?.pageCollectionController(self, viewControllerAt: indexPath) {
            cell.contentView.addSubview(vc.view)
            vc.view.snp.remakeConstraints { (remake) in
                remake.edges.equalTo(cell.contentView)
            }
            self.addChildViewController(vc)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.fwidth, height: collectionView.fheight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.fwidth
        titleView.currentIndex = Int(index)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index = offsetX / scrollView.fwidth
        titleView.floatIndex = index
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

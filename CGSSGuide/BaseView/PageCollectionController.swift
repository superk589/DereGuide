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

protocol PageCollectionControllerDelegate: class {
    func pageCollectionController(pageCollectionController: PageCollectionController, willShow viewController: UIViewController)
}

class PageCollectionController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var titleView: PageTitleView = PageTitleView()
    var collectionView: PageCollectionView = PageCollectionView()
    var titleHeight: CGFloat = 30 {
        didSet {
            titleView.snp.updateConstraints { (update) in
                update.height.equalTo(titleHeight)
            }
        }
    }

    weak var delegate: PageCollectionControllerDelegate?
    weak var dataSource: PageCollectionControllerDataSource? {
        didSet {
            collectionView.reloadData()
            titleView.titles = dataSource?.titlesOfPages(self) ?? [String]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PageCell")
        view.addSubview(collectionView)
        view.addSubview(titleView)
        
        titleView.snp.makeConstraints { (make) in
            make.height.equalTo(titleHeight)
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        titleView.delegate = self
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        automaticallyAdjustsScrollViewInsets = false
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
    
//    private var isInTheMiddleOfPage = true
//    private var lastIndex: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index = offsetX / scrollView.fwidth
        titleView.floatIndex = index
        
//        if index == ceil(index) {
//            isInTheMiddleOfPage = true
//        } else {
//            if isInTheMiddleOfPage {
//                let newIndex = lastIndex > index ? floor(index) : ceil(index)
//                let vc = self.childViewControllers[Int(newIndex)]
////                    print("will show \(newIndex)")
//                delegate?.pageCollectionController(pageCollectionController: self, willShow: vc)
//            }
//            isInTheMiddleOfPage = false
//        }
//        
//        lastIndex = index
    }
}

extension PageCollectionController: PageTitleViewDelegate {
    func pageTitleView(_ pageTitleView: PageTitleView, didSelectAtIndex index: Int) {
        self.collectionView.contentOffset.x = CGFloat(index) * self.collectionView.fwidth
//        if let vc = dataSource?.pageCollectionController(self, viewControllerAt: IndexPath(item: index, section: 0)) {
////            print("will show \(index)")
//            delegate?.pageCollectionController(pageCollectionController: self, willShow: vc)
//        }
        //        UIView.animate(withDuration: 0.25, animations: {
        //            self.collectionView.contentOffset.x = CGFloat(index) * self.collectionView.fwidth - (CGFloat(index) * self.collectionView.fwidth - self.collectionView.contentOffset.x) * 0.001
        //        }) { (finished) in
        //            self.collectionView.contentOffset.x = CGFloat(index) * self.collectionView.fwidth
        //        }
    }
}

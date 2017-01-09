//
//  FilterView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol FilterViewDelegate: class {
    func filterView(_ filterView: FilterView, didSelect index:Int)
    func filterView(_ filterView: FilterView, didDeselect index:Int)
}

class FilterView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var cv : UICollectionView!
    var titleLabel: UILabel!
    
    var titles = [String]()
    var colors = [UIColor]()
    
    weak var delegate: FilterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
        }
        titleLabel.font = UIFont.regular(size: 12)
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize.init(width: 40, height: 30)
        cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        addSubview(cv)
        cv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        cv.backgroundColor = UIColor.white
        cv.allowsMultipleSelection = true
        cv.delegate = self
        cv.dataSource = self
        cv.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
    }
    
    func setup(titles: [String], colors: [UIColor]) {
        self.titles = titles
        self.colors = colors
        cv.reloadData()
    }
    
    func setupPresetIndex(index: UInt) {
        for i in 0..<titles.count {
            if (index >> UInt(i)) % 2 == 1 {
                let indexPath = IndexPath.init(item: i, section: 0)
                cv.selectItem(at: indexPath, animated: false, scrollPosition: .left)
                if let cell = cv.cellForItem(at: indexPath) as? FilterCell {
                    cell.customSelected = true
                }
            }
        }
       
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return cv.contentSize
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    var selectedIndexPaths: [IndexPath] {
//        return cv.indexPathsForSelectedItems ?? [IndexPath]()
//    }
    
    // MARK: CollectionViewDelegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assert(titles.count == colors.count, "FilterView titles' count is not equal to colors' count")
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
//        if let dataSource = self.dataSource {
//            cell.setup(title: dataSource.filterView(self, titlesForItem: indexPath.item))
//            cell.selectColor = dataSource.filterView(self, tintColorForItem: indexPath.item)
//        }
        cell.setup(title: titles[indexPath.item])
        if cell.isSelected {
            cell.customSelected = true
        }
        cell.selectColor = colors[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FilterCell
        cell?.customSelected = true
        delegate?.filterView(self, didSelect: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FilterCell
        cell?.customSelected = false
        delegate?.filterView(self, didDeselect: indexPath.item)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

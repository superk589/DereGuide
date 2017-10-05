//
//  SongDetailCoverFlowCell.swift
//  DereGuide
//
//  Created by zzk on 01/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class SongDetailCoverFlowCell: UITableViewCell {

    weak var delegate: (UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout)? {
        didSet {
            collectionView.delegate = delegate
            collectionView.dataSource = delegate
        }
    }
    
    var index: Int = 0 {
        didSet {
            collectionView.contentOffset = CGPoint(x: collectionView.frame.size.width * CGFloat(index), y: 0)
        }
    }
    
    var collectionView: UICollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  PageCollectionView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/8.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class PageCollectionView: UICollectionView {
    
    init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: layout)
    
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        
        backgroundColor = UIColor.white
        isPagingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

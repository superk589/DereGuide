//
//  PageCollectionView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/8.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class PageCollectionView: UICollectionView {
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.init(frame: CGRect.zero, collectionViewLayout: layout)
    
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        
        backgroundColor = UIColor.white
        isPagingEnabled = true
    }
}

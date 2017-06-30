//
//  PageCollectionView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/8.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class PageCollectionView: UICollectionView {
    
    var layout: UICollectionViewFlowLayout {
        return self.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        self.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
    
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        backgroundColor = UIColor.white
        isPagingEnabled = true
    }
}

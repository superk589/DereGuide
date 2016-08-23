//
//  BaseDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BaseDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var currentView: UIView!
    var nextView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        collectionView?.collectionViewLayout = layout
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

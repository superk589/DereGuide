//
//  BirthdayNotificationTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BirthdayNotificationTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var chars = [CGSSChar]()
    var cv: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        
//        let left = UIButton.init(frame: CGRectMake(0, 32, 10, 15))
//        left.setImage(UIImage.init(named: "765-arrow-left-toolbar"), forState: .Normal)
//        let right = UIButton.init(frame: CGRectMake(CGSSGlobal.width - 10, 32, 10, 15))
//        left.setImage(UIImage.init(named: "766-arrow-right-toolbar"), forState: .Normal)
//        contentView.addSubview(left)
//        contentView.addSubview(right)
        
        cv = UICollectionView.init(frame: CGRectMake(0, 0, CGSSGlobal.width - 0, 79), collectionViewLayout: layout)
        cv.backgroundColor = UIColor.whiteColor()
        cv.registerClass(BirthdayCollectionViewCell.self, forCellWithReuseIdentifier: "BirthdayCollectionViewCell")
        cv.showsHorizontalScrollIndicator = false
        contentView.addSubview(cv)
        var inset = self.separatorInset
        inset.left = inset.left - 10
        inset.right = inset.left
        cv.contentInset = inset
        cv.delegate = self
        cv.dataSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWith(models: [CGSSChar]) {
        chars.removeAll()
        chars.appendContentsOf(models)
        if chars.count == 0 {
            cv.frame = CGRectZero
        } else {
            cv.frame = CGRectMake(0, 0, CGSSGlobal.width, 79)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chars.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BirthdayCollectionViewCell", forIndexPath: indexPath) as! BirthdayCollectionViewCell
        cell.initWithChar(chars[indexPath.item])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(68, 79)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

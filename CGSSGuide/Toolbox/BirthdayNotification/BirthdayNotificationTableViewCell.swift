//
//  BirthdayNotificationTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol BirthdayNotificationTableViewCellDelegate:class {
    func charIconClick(_ icon:CGSSCharIconView)
}

class BirthdayNotificationTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var chars = [CGSSChar]()
    var cv: UICollectionView!
    weak var delegate: BirthdayNotificationTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
//        let left = UIButton.init(frame: CGRectMake(0, 32, 10, 15))
//        left.setImage(UIImage.init(named: "765-arrow-left-toolbar"), forState: .Normal)
//        let right = UIButton.init(frame: CGRectMake(CGSSGlobal.width - 10, 32, 10, 15))
//        left.setImage(UIImage.init(named: "766-arrow-right-toolbar"), forState: .Normal)
//        contentView.addSubview(left)
//        contentView.addSubview(right)
        
        cv = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width - 0, height: 79), collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.register(BirthdayCollectionViewCell.self, forCellWithReuseIdentifier: "BirthdayCollectionViewCell")
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
    
    func initWith(_ models: [CGSSChar]) {
        chars.removeAll()
        chars.append(contentsOf: models)
        if chars.count == 0 {
            cv.frame = CGRect.zero
        } else {
            cv.frame = CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 79)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BirthdayCollectionViewCell", for: indexPath) as! BirthdayCollectionViewCell
        cell.initWithChar(chars[(indexPath as NSIndexPath).item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 68, height: 79)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension BirthdayNotificationTableViewCell: BirthdayCollectionViewCellDelegate {
    func charIconClick(_ icon: CGSSCharIconView) {
        delegate?.charIconClick(icon)
    }
}

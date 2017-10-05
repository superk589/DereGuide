//
//  BirthdayNotificationTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 16/8/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import SnapKit

class CharaWithBirthdayView: UIView {
    
    var icon: CGSSCharaIconView!
    var birthdayLabel: UILabel!
    weak var delegate: CGSSIconViewDelegate? {
        didSet {
            icon.delegate = self.delegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        icon = CGSSCharaIconView()
        addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(48)
        }
        icon.isUserInteractionEnabled = false
        
        birthdayLabel = UILabel()
        birthdayLabel.font = UIFont.systemFont(ofSize: 14)
        birthdayLabel.textColor = UIColor.darkGray
        birthdayLabel.textAlignment = .center
        birthdayLabel.adjustsFontSizeToFitWidth = true
        birthdayLabel.baselineAdjustment = .alignCenters
        birthdayLabel.text = " "
        addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(3)
        }
    }
    
    func setup(with chara: CGSSChar) {
        icon.charaID = chara.charaId
        birthdayLabel.text = "\(chara.birthMonth!)-\(chara.birthDay!)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol BirthdayNotificationTableViewCellDelegate:class {
    func charIconClick(_ icon:CGSSCharaIconView)
}

class BirthdayNotificationTableViewCell: UITableViewCell, TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    var charas = [CGSSChar]()
    var leftLabel: UILabel!
    var collectionView: TTGTagCollectionView!
    var charaViews = NSCache<NSNumber, CharaWithBirthdayView>()
    
    weak var delegate: BirthdayNotificationTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel = UILabel()
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
        }
        
        collectionView = TTGTagCollectionView()
        collectionView.contentInset = .zero
        collectionView.verticalSpacing = 10
        collectionView.horizontalSpacing = 10
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with charas: [CGSSChar], title: String) {
        self.charas = charas
        leftLabel.text = title
        collectionView.reload()
    }
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(charas.count)
    }
    
    private func viewFor(index: Int) -> CharaWithBirthdayView {
        if let view = charaViews.object(forKey: NSNumber.init(value: index)) {
            return view
        } else {
            let view = CharaWithBirthdayView()
            charaViews.setObject(view, forKey: NSNumber.init(value: index))
            return view
        }
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        let view = viewFor(index: Int(index))
        view.setup(with: charas[Int(index)])
        return view
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        return CGSize(width: 48, height: 68)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
        delegate?.charIconClick((tagView as! CharaWithBirthdayView).icon)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        layoutIfNeeded()
        collectionView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
}

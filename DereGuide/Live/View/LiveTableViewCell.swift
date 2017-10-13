//
//  LiveTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

protocol LiveTableViewCellDelegate: class {
    func liveTableViewCell(_ liveTableViewCell: LiveTableViewCell, didSelect liveScene: CGSSLiveScene)
}

class LiveTableViewCell: ReadableWidthTableViewCell {
    
    let jacketImageView = BannerView()
    var nameLabel = UILabel()
    var typeIcon = UIImageView()
    
    let collectionView = TTGTagCollectionView()
    var tagViews = [SongDetailLiveDifficultyView]()
    
    private var live: CGSSLive!
    
    weak var delegate: LiveTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        readableContentView.addSubview(jacketImageView)
        jacketImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.width.height.equalTo(66)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
        readableContentView.addSubview(typeIcon)
        typeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(jacketImageView.snp.right).offset(10)
            make.width.height.equalTo(20)
        }
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        readableContentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeIcon.snp.right).offset(5)
            make.right.lessThanOrEqualTo(-10)
            make.centerY.equalTo(typeIcon)
        }
        
        readableContentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(43)
            make.left.equalTo(jacketImageView.snp.right).offset(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alignment = .left
        collectionView.horizontalSpacing = 10
        collectionView.verticalSpacing = 10
        collectionView.contentInset = .zero
        selectionStyle = .none
    }
    
    func setup(live: CGSSLive) {
        self.live = live
        tagViews.removeAll()
        
        if let url = live.jacketURL {
            jacketImageView.sd_setImage(with: url)
        }
        
        typeIcon.image = live.icon
        
        nameLabel.text = live.name
        nameLabel.textColor = live.color
        
        for detail in live.selectedLiveDetails {
            let tag = SongDetailLiveDifficultyView()
            tag.setup(liveDetail: detail, shouldShowText: !UserDefaults.standard.shouldHideDifficultyText)
            tagViews.append(tag)
        }
        
        collectionView.reload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        layoutIfNeeded()
        collectionView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}

extension LiveTableViewCell: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        let tagView = tagViews[Int(index)]
        tagView.sizeToFit()
        return tagView.frame.size
    }
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(tagViews.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        return tagViews[Int(index)]
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
        let detail = live.details[Int(index)]
        let scene = CGSSLiveScene(live: live, difficulty: detail.difficulty)
        delegate?.liveTableViewCell(self, didSelect: scene)
    }
}

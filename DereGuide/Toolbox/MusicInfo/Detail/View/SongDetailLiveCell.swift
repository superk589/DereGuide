//
//  SongDetailLiveCell.swift
//  DereGuide
//
//  Created by zzk on 28/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

protocol SongDetailLiveCellDelegate: class {
    func songDetailLiveCell(_ songDetailLiveCell: SongDetailLiveCell, didSelect liveScene: CGSSLiveScene)
}

class SongDetailLiveCell: ReadableWidthTableViewCell {

    let centerLabel = UILabel()
    let collectionView = TTGTagCollectionView()
    var tagViews = [SongDetailLiveDifficultyView]()
    
    private var song: CGSSSong!
    
    weak var delegate: SongDetailLiveCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        centerLabel.font = UIFont.systemFont(ofSize: 16)
        centerLabel.text = NSLocalizedString("谱面", comment: "")
        readableContentView.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        
        readableContentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(centerLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alignment = .center
        collectionView.horizontalSpacing = 10
        collectionView.verticalSpacing = 10
    }
    
    func setup(song: CGSSSong) {
        self.song = song
        tagViews.removeAll()
        
        guard let live = song.live else {
            return
        }
        
        if let normalLive = song.normalLive {
            live.merge(anotherLive: normalLive)
            song.normalLive = nil
        }
        
        for detail in live.details {
            let tag = SongDetailLiveDifficultyView()
            tag.setup(liveDetail: detail)
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
        // if not call setNeedsUpdateConstraints here, it may lead to layout warnings in xcode.
        setNeedsUpdateConstraints()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}

extension SongDetailLiveCell: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
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
        guard let live = song.live else {
            return
        }
        let detail = live.details[Int(index)]
        let scene = CGSSLiveScene(live: live, difficulty: detail.difficulty)
        delegate?.songDetailLiveCell(self, didSelect: scene)
    }
}

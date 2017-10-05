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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        
        let difficulties = CGSSLiveDifficulty.all
        let stars = live.liveDetails.map { $0.stars }
        for i in 0..<live.validBeatmapCount {
            let tag = SongDetailLiveDifficultyView()
            
            tag.setup(difficulty: difficulties[i], stars: stars[i])
            tagViews.append(tag)
        }
        
        if song.liveID != song.normalLiveID {
            if let _ = song.normalLive?.legacyMasterPlusBeatmap {
                let tag = SongDetailLiveDifficultyView()
                tag.setup(difficulty: .legacyMasterPlus, stars: nil)
                tagViews.append(tag)
            }
        } else {
            
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
        guard let difficulty = (tagView as? SongDetailLiveDifficultyView)?.difficulty else {
            return
        }
        if difficulty == .legacyMasterPlus, let live = song.normalLive {
            let scene = CGSSLiveScene(live: live, difficulty: difficulty)
            delegate?.songDetailLiveCell(self, didSelect: scene)
        } else if let live = song.live {
            let scene = CGSSLiveScene(live: live, difficulty: difficulty)
            delegate?.songDetailLiveCell(self, didSelect: scene)
        }
    }
}

//
//  GachaCardWithOddsListView.swift
//  DereGuide
//
//  Created by zzk on 2017/7/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class GachaCardWithOddsListView: UIView {

    var collectionView: TTGTagCollectionView!
    
    var tagViews = NSCache<NSNumber, GachaCardView>()
    
    weak var delegate: CGSSIconViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView = TTGTagCollectionView()
        collectionView.contentInset = .zero
        collectionView.verticalSpacing = 5
        collectionView.horizontalSpacing = 5
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.scrollView.isScrollEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(cards: [CGSSCard], odds: [Int?]) {
        self.cards = cards
        self.odds = odds
        collectionView.reload()
        self.isHidden = cards.count == 0
    }
    
    var cards = [CGSSCard]()
    var odds = [Int?]()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        layoutIfNeeded()
        collectionView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
}

extension GachaCardWithOddsListView: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(cards.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        let gachaCardView: GachaCardView
        if let view = tagViews.object(forKey: NSNumber.init(value: index)) {
            gachaCardView = view
        } else {
            gachaCardView = GachaCardView()
            gachaCardView.icon.isUserInteractionEnabled = false
            tagViews.setObject(gachaCardView, forKey: NSNumber.init(value: index))
        }
        gachaCardView.setupWith(card: cards[Int(index)], odds: odds[Int(index)])
        return gachaCardView
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        return CGSize(width: 48, height: 62.5)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
        let cardView = tagView as! GachaCardView
        delegate?.iconClick(cardView.icon)
    }
    
}

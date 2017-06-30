//
//  CardDetailRelatedCardsCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

protocol CardDetailRelatedCardsCellDelegate: class {
    func checkCharaInfo(_ cardDetailRelatedCardsCell: CardDetailRelatedCardsCell)
}

class CardDetailRelatedCardsCell: UITableViewCell {
    var leftLabel: UILabel!
    var rightLabel: UILabel!
    var collectionView: TTGTagCollectionView!
    
    var tagViews = NSCache<NSNumber, CGSSCardIconView>()
    
    weak var delegate: (CardDetailRelatedCardsCellDelegate & CGSSIconViewDelegate)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel = UILabel()
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("角色所有卡片", comment: "卡片详情页")
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        rightLabel = UILabel()
        rightLabel.text = NSLocalizedString("查看角色详情", comment: "卡片详情页") + " >"
        rightLabel.font = UIFont.systemFont(ofSize: 16)
        rightLabel.textColor = UIColor.lightGray
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(_:)))
        rightLabel.addGestureRecognizer(tap)
        rightLabel.isUserInteractionEnabled = true
        contentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
        }
        
        collectionView = TTGTagCollectionView()
        collectionView.contentInset = .zero
        collectionView.verticalSpacing = 5
        collectionView.horizontalSpacing = 5
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(rightLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        selectionStyle = .none

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTapGesture(_ tap: UITapGestureRecognizer) {
        delegate?.checkCharaInfo(self)
    }
    
    var cards = [CGSSCard]()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        layoutIfNeeded()
        collectionView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}

extension CardDetailRelatedCardsCell: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(cards.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        let icon: CGSSCardIconView
        if let view = tagViews.object(forKey: NSNumber.init(value: index)) {
            icon = view
        } else {
            icon = CGSSCardIconView()
            icon.isUserInteractionEnabled = false
            tagViews.setObject(icon, forKey: NSNumber.init(value: index))
        }
        icon.cardId = cards[Int(index)].id
        return icon
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
        let icon = tagView as! CGSSCardIconView
        delegate?.iconClick(icon)
    }
}

extension CardDetailRelatedCardsCell: CardDetailSetable {
    func setup(with card: CGSSCard) {
        self.cards = CGSSDAO.shared.findCardsByCharId(card.charaId)
        collectionView.reload()
//        collectionView.sizeToFit()
    }
}

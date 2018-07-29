//
//  CardDetailRelatedCardsCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

protocol CardDetailRelatedCardsCellDelegate: class {
    func didClickRightDetail(_ cardDetailRelatedCardsCell: CardDetailRelatedCardsCell)
}

class CardDetailRelatedCardsCell: UITableViewCell {
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    let collectionView = TTGTagCollectionView()
    
    var tagViews = [Int: CGSSCardIconView]()
    
    weak var delegate: (CardDetailRelatedCardsCellDelegate & CGSSIconViewDelegate)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.font = .systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("角色所有卡片", comment: "卡片详情页")
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        rightLabel.text = NSLocalizedString("查看角色详情", comment: "卡片详情页") + " >"
        rightLabel.font = .systemFont(ofSize: 16)
        rightLabel.textColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        rightLabel.addGestureRecognizer(tap)
        rightLabel.isUserInteractionEnabled = true
        contentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(readableContentGuide)
        }
        
        collectionView.contentInset = .zero
        collectionView.verticalSpacing = 5
        collectionView.horizontalSpacing = 5
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
            make.top.equalTo(rightLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        selectionStyle = .none

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTapGesture(_ tap: UITapGestureRecognizer) {
        delegate?.didClickRightDetail(self)
    }
    
    var cards = [CGSSCard]() {
        didSet {
            collectionView.reload()
        }
    }
    
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
        if let view = tagViews[Int(index)] {
            icon = view
        } else {
            icon = CGSSCardIconView()
            icon.isUserInteractionEnabled = false
            tagViews[Int(index)] = icon
        }
        icon.cardID = cards[Int(index)].id
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
        cards = CGSSDAO.shared.findCardsByCharId(card.charaId).sorted { $0.albumId > $1.albumId }
    }
    
}

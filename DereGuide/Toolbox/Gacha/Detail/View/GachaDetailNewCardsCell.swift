//
//  GachaDetailNewCardsCell.swift
//  DereGuide
//
//  Created by zzk on 18/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

protocol GachaDetailNewCardsCellDelegate: class {
    func navigateToFullAvailableList(gachaDetailNewCardsCell: GachaDetailNewCardsCell)
}

class GachaDetailNewCardsCell: UITableViewCell {
    
    let titleLabel = UILabel()
    
    let fullAvailableListLabel = UILabel()
    
    let collectionView = TTGTagCollectionView()
    
    var tagViews = [Int: GachaCardView]()
    
    weak var delegate: (GachaDetailNewCardsCellDelegate & CGSSIconViewDelegate)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = NSLocalizedString("新增卡片", comment: "模拟抽卡页面")
        titleLabel.textColor = .black
        
        contentView.addSubview(fullAvailableListLabel)
        fullAvailableListLabel.snp.makeConstraints { (make) in
            make.right.equalTo(readableContentGuide)
            make.top.equalTo(titleLabel)
        }
        fullAvailableListLabel.text = NSLocalizedString("查看完整卡池", comment: "模拟抽卡页面") + " >"
        fullAvailableListLabel.font = UIFont.systemFont(ofSize: 16)
        fullAvailableListLabel.textColor = .lightGray
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickFullAvailableList))
        fullAvailableListLabel.addGestureRecognizer(tap)
        fullAvailableListLabel.textAlignment = .right
        fullAvailableListLabel.isUserInteractionEnabled = true
    
        collectionView.contentInset = .zero
        collectionView.verticalSpacing = 5
        collectionView.horizontalSpacing = 5
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        collectionView.scrollView.isScrollEnabled = false
        
        selectionStyle = .none
    }
    
    @objc private func clickFullAvailableList() {
        delegate?.navigateToFullAvailableList(gachaDetailNewCardsCell: self)
    }
    
    func setup(cardsWithOdds: [CardWithOdds]) {
        self.cardsWithOdds = cardsWithOdds
        collectionView.reload()
    }
    
    private var cardsWithOdds = [CardWithOdds]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        layoutIfNeeded()
        collectionView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
    
}

extension GachaDetailNewCardsCell: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(cardsWithOdds.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        let gachaCardView: GachaCardView
        if let view = tagViews[Int(index)] {
            gachaCardView = view
        } else {
            gachaCardView = GachaCardView()
            gachaCardView.icon.isUserInteractionEnabled = false
            tagViews[Int(index)] = gachaCardView
        }
        gachaCardView.setupWith(card: cardsWithOdds[Int(index)].card, odds: cardsWithOdds[Int(index)].odds)
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

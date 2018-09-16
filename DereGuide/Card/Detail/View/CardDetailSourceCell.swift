//
//  CardDetailSourceCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class CardDetailSourceCell: UITableViewCell {
    
    var types: [CGSSAvailableTypes] = [CGSSAvailableTypes.event, .normal, .limit, .fes]
    var titles: [String] {
        return types.map { $0.description }
    }
    let collectionView = TTGTagCollectionView()
    var tagViews = [CheckBox]()
    let leftLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.font = .systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("获得途径", comment: "卡片详情页")
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        for i in 0..<types.count {
            let checkBox = CheckBox()
            checkBox.tintColor = .parade
            checkBox.label.textColor = .darkGray
            checkBox.label.text = titles[i]
            checkBox.isChecked = false
            tagViews.append(checkBox)
        }
        
        collectionView.contentInset = .zero
        collectionView.verticalSpacing = 5
        collectionView.horizontalSpacing = 15
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
            make.bottom.equalTo(-10)
        }
        selectionStyle = .none
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


extension CardDetailSourceCell: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(types.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        return tagViews[Int(index)]
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        let tagView = tagViews[Int(index)]
        return tagView.intrinsicContentSize
    }
}

extension CardDetailSourceCell: CardDetailSetable {
    func setup(with card: CGSSCard) {
        var types: CGSSAvailableTypes = .free
        if card.evolutionId == 0 {
            leftLabel.text = NSLocalizedString("获得途径(进化前)", comment: "卡片详情页")
            if let cardFrom = CGSSDAO.shared.findCardById(card.id - 1) {
                types = cardFrom.gachaType
            }
        } else {
            leftLabel.text = NSLocalizedString("获得途径", comment: "卡片详情页")
            types = card.gachaType
        }
        
        for i in 0..<self.types.count {
            let view = tagViews[i]
            view.isChecked = types.contains(self.types[i])
        }
        collectionView.reload()
    }
}

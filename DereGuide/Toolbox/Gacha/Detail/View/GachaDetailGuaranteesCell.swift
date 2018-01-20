//
//  GachaDetailGuaranteesCell.swift
//  DereGuide
//
//  Created by zzk on 19/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class GachaDetailGuaranteesCell: ReadableWidthTableViewCell {
    
    let guaranteesView = CardDetailRelatedCardsCell()
    
    weak var delegate: (CGSSIconViewDelegate & CardDetailRelatedCardsCellDelegate)? {
        didSet {
            guaranteesView.delegate = delegate
        }
    }

    override var maxReadableWidth: CGFloat {
        return 824
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        guaranteesView.rightLabel.isHidden = true
        guaranteesView.leftLabel.text = NSLocalizedString("天井", comment: "模拟抽卡页面")
        readableContentView.addSubview(guaranteesView.contentView)
        guaranteesView.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        guaranteesView.delegate = self
        
        selectionStyle = .none
    }
    
    func setup(cards: [CGSSCard]) {
        guaranteesView.cards = cards
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        layoutIfNeeded()
        guaranteesView.collectionView.invalidateIntrinsicContentSize()
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}

extension GachaDetailGuaranteesCell: CardDetailRelatedCardsCellDelegate, CGSSIconViewDelegate {
    
    func didClickRightDetail(_ cardDetailRelatedCardsCell: CardDetailRelatedCardsCell) {
        
    }
    
    func iconClick(_ iv: CGSSIconView) {
        delegate?.iconClick(iv)
    }
    
}

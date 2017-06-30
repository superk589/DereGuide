
//
//  CardDetailSpreadImageCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol CardDetailSetable {
    func setup(with card: CGSSCard)
}

protocol CardDetailSpreadImageCellDelegate: class {
    func cardDetailSpreadImageCell(_ cardDetailSpreadImageCell: CardDetailSpreadImageCell, longPressAt point: CGPoint)
    func tappedCardDetailSpreadImageCell(_ cardDetailSpreadImageCell: CardDetailSpreadImageCell)
}

class CardDetailSpreadImageCell: UITableViewCell {
    
    var spreadImageView: SpreadImageView!
    weak var delegate: CardDetailSpreadImageCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        spreadImageView = SpreadImageView()
        spreadImageView.isUserInteractionEnabled = true
        spreadImageView.contentMode = .scaleAspectFill
        contentView.addSubview(spreadImageView)
        spreadImageView.snp.makeConstraints({ (make) in
            make.left.width.equalToSuperview()
            make.height.equalTo(spreadImageView.snp.width).multipliedBy(824.0 / 1280.0)
            make.bottom.lessThanOrEqualToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        })
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        spreadImageView.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        contentView.addGestureRecognizer(tap)
        
        selectionStyle = .none
    }
    
    func handleTapGesture(_ tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            delegate?.tappedCardDetailSpreadImageCell(self)
        }
    }
    
    func handleLongPressGesture(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            if let _ = spreadImageView.image {
                delegate?.cardDetailSpreadImageCell(self, longPressAt: longPress.location(in: spreadImageView))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardDetailSpreadImageCell: CardDetailSetable {
    func setup(with card: CGSSCard) {
        if let url = card.spreadImageURL {
            spreadImageView.setImage(with: url)
        }
    }
}

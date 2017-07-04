//
//  CharDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

protocol CharDetailViewDelegate: class {
    func cardIconClick(_ icon: CGSSCardIconView)
}

class CharDetailView: UIView, CardDetailRelatedCardsCellDelegate, CGSSIconViewDelegate {
    
    weak var delegate: CharDetailViewDelegate?
    
    var iconView: CGSSCharIconView!
    var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    // var basicView: UIView!
    var detailView: UIView!
    var relatedView: CardDetailRelatedCardsCell!
    
    var profileView: CharProfileView!
    
    fileprivate func prepare() {
        iconView = CGSSCharIconView()
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.height.width.equalTo(48)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.centerY.equalTo(iconView)
            make.right.lessThanOrEqualTo(-10)
        }
        
        profileView = CharProfileView()
        addSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(iconView.snp.bottom).offset(20)
        }
        
        let line = LineView()
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(profileView.snp.bottom).offset(10)
        }
        
        relatedView = CardDetailRelatedCardsCell()
        addSubview(relatedView.contentView)
        relatedView.contentView.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview()
            make.top.equalTo(line.snp.bottom)
            make.bottom.equalToSuperview()
        }
        relatedView.rightLabel.isHidden = true
        relatedView.delegate = self
    }
    
    func setup(_ char: CGSSChar) {
        nameLabel.text = "\(char.kanjiSpaced!)  \(char.conventional!)"
        iconView.charId = char.charaId
        profileView.setup(char)
        var cards = CGSSDAO.shared.findCardsByCharId(char.charaId)
        let sorter = CGSSSorter.init(property: "sAlbumId")
        sorter.sortList(&cards)
        relatedView.cards = cards
    }
    
    func checkCharaInfo(_ cardDetailRelatedCardsCell: CardDetailRelatedCardsCell) {
        
    }
    
    func iconClick(_ iv: CGSSIconView) {
        if let cardIcon = iv as? CGSSCardIconView {
            delegate?.cardIconClick(cardIcon)
        }
    }
}

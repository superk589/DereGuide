//
//  CenterWantedItemView.swift
//  DereGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CenterWantedItemView: UIView {

    private var cardView: CenterWantedCardView!
    private var placeholderImageView: UIImageView!
    private var cardPlaceholder: UIView!
    private var typeIcon: UIImageView!
    
    private(set) var cardID: Int!
    private(set) var minLevel: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardView = CenterWantedCardView()
        cardView.icon.isUserInteractionEnabled = false
        addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cardView.snp.width).offset(14.5)
        }
        
        typeIcon = UIImageView()
        addSubview(typeIcon)
        typeIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.top.equalTo(cardView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        cardPlaceholder = UIView()
        addSubview(cardPlaceholder)
        cardPlaceholder.snp.makeConstraints { (make) in
            make.edges.equalTo(cardView.icon.snp.edges)
        }
        cardPlaceholder.layer.masksToBounds = true
        cardPlaceholder.layer.cornerRadius = 4
        cardPlaceholder.layer.borderWidth = 1 / Screen.scale
        cardPlaceholder.layer.borderColor = UIColor.border.cgColor
        
        placeholderImageView = UIImageView(image: #imageLiteral(resourceName: "436-plus").withRenderingMode(.alwaysTemplate))
        cardPlaceholder.addSubview(placeholderImageView)
        placeholderImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview().dividedBy(3)
        }
        placeholderImageView.tintColor = .lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with liveType: CGSSLiveTypes) {
        typeIcon.image = liveType.icon
    }
    
    func setupWith(cardID: Int, minLevel: Int = 0) {
        self.cardID = cardID
        self.minLevel = minLevel
        if cardID != 0 {
            showsPlaceholder = false
            cardView.setupWith(cardID: cardID, minLevel: minLevel)
        } else {
            showsPlaceholder = true
        }
    }
    
    var showsPlaceholder: Bool = true {
        didSet {
            cardPlaceholder.isHidden = !showsPlaceholder
            cardView.isHidden = showsPlaceholder
            bringSubview(toFront: showsPlaceholder ? cardPlaceholder : cardView)
        }
    }

}

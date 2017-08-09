//
//  CenterWantedItemView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class CenterWantedItemView: UIView {

    private var cardView: CenterWantedCardView!
    private var placeholderImageView: UIImageView!
    private var cardPlaceholder: UIView!
    private var typeIcon: UIImageView!
    
    private(set) var cardID: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardView = CenterWantedCardView()
        cardView.icon.isUserInteractionEnabled = false
        addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.left.equalTo(4)
            make.right.equalTo(-4)
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
            make.edges.equalTo(cardView.snp.edges)
        }
        cardPlaceholder.layer.masksToBounds = true
        cardPlaceholder.layer.cornerRadius = 4
        cardPlaceholder.layer.borderWidth = 1 / Screen.scale
        cardPlaceholder.layer.borderColor = UIColor.lightSeparator.cgColor
        
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
    
    func setupWith(cardID: Int) {
        self.cardID = cardID
        
        if cardID != 0 {
            cardPlaceholder.isHidden = true
            cardView.isHidden = false
            cardView.setupWith(cardID: cardID)
            bringSubview(toFront: cardView)
        } else {
            cardPlaceholder.isHidden = false
            cardView.isHidden = true
            bringSubview(toFront: cardPlaceholder)
        }
    }

}

//
//  FreeCardItemView.swift
//  DereGuide
//
//  Created by zzk on 2019/4/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit
import SnapKit

class FreeCardItemView: UIView {
    
    private(set) var cardView: CGSSCardIconView!
    private var cardPlaceholder: UIView!
    
    private(set) var cardID: Int!
    private(set) var potential: Potential!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cardView = CGSSCardIconView()
        addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(cardView.snp.width)
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
        cardPlaceholder.layer.borderColor = UIColor.border.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(cardID: Int) {
        self.cardID = cardID
        if cardID != 0 {
            showsPlaceholder = false
            cardView.cardID = cardID
        } else {
            showsPlaceholder = true
        }
    }
    
    var showsPlaceholder: Bool = true {
        didSet {
            cardPlaceholder.isHidden = !showsPlaceholder
            cardView.isHidden = showsPlaceholder
            bringSubviewToFront(showsPlaceholder ? cardPlaceholder : cardView)
        }
    }
}

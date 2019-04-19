//
//  FreeCardGroupView.swift
//  DereGuide
//
//  Created by zzk on 2019/4/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

class FreeCardGroupView: UIView {
    
    let descLabel = UILabel()
    
    var stackView: UIStackView!
    
    var editableItemViews = [FreeCardItemView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        for _ in 0..<5 {
            let view = FreeCardItemView()
            editableItemViews.append(view)
        }
        stackView = UIStackView(arrangedSubviews: editableItemViews)
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        
        stackView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.greaterThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-10)
            // make the view as wide as possible
            make.right.equalTo(-10).priority(900)
            make.left.equalTo(10).priority(900)
            //
            make.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(96 * 5 + 6 * 5)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func setupWith(cardID: Int, at index: Int, hidesIfNeeded: Bool = false) {
        editableItemViews[index].setupWith(cardID: cardID)
        if cardID == 0 && hidesIfNeeded {
            editableItemViews[index].isHidden = true
        } else {
            editableItemViews[index].isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


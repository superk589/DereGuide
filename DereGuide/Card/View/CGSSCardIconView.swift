//
//  CGSSCardIconView.swift
//  DereGuide
//
//  Created by zzk on 16/7/10.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

fileprivate extension CGSSCard {
    var placeholderImage: UIImage {
        return cardType.placeholder
    }
}

class CGSSCardIconView: CGSSIconView {
    
    var cardID: Int? {
        didSet {
            if let id = cardID {
                let url = URL.images.appendingPathComponent("/icon_card/\(id).png")
                self.sd_setImage(with: url, placeholderImage: CGSSDAO.shared.findCardById(id)?.placeholderImage)
            } else {
                sd_setImage(with: nil, placeholderImage: nil, options: [], completed: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setWithCardId(_ id: Int, target: AnyObject, action: Selector) {
        self.cardID = id
        self.setAction(target, action: action)
    }
    
}

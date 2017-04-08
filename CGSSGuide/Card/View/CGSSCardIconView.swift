//
//  CGSSCardIconView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/10.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

fileprivate extension CGSSCard {
    var placeholderImage: UIImage {
        return cardType.placeholder
    }
}

class CGSSCardIconView: CGSSIconView {
    
    var cardId: Int? {
        didSet {
            if let id = cardId, let url = URL.init(string: DataURL.Images + "/icon_card/\(id).png") {
                self.sd_setImage(with: url, placeholderImage: CGSSDAO.shared.findCardById(id)?.placeholderImage)
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
        self.cardId = id
        self.setAction(target, action: action)
    }
    
}

//
//  CGSSCharaIconView.swift
//  DereGuide
//
//  Created by zzk on 16/8/14.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

extension CGSSCharTypes {
    var placeholder: UIImage {
        switch self {
        case CGSSCharTypes.cute:
            return #imageLiteral(resourceName: "cute-placeholder")
        case CGSSCharTypes.cool:
            return #imageLiteral(resourceName: "cool-placeholder")
        case CGSSCharTypes.passion:
            return #imageLiteral(resourceName: "passtion-placeholder")
        default:
            return UIImage()
        }
    }
}

fileprivate extension CGSSChar {
    var placeholderImage: UIImage {
        return charType.placeholder
    }
}

class CGSSCharaIconView: CGSSIconView {
    
    var charaID: Int? {
        didSet {
            if let id = charaID {
                let url = URL.images.appendingPathComponent("/icon_char/\(id).png")
                self.sd_setImage(with: url, placeholderImage: CGSSDAO.shared.findCharById(id)?.placeholderImage)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setWithCharId(_ id: Int, target: AnyObject, action: Selector) {
        self.charaID = id
        self.setAction(target, action: action)
    }
}

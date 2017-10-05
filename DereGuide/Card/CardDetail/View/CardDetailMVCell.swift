//
//  CardDetailMVCell.swift
//  DereGuide
//
//  Created by zzk on 29/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CardDetailMVCell: UITableViewCell {

    let leftLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("出演MV", comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

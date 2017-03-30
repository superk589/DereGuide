//
//  CardTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardTableViewCell: UITableViewCell {
    
    var cardView: CardView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func prepare() {
        
        cardView = CardView()
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepare()
    }
    
    func setup(with card: CGSSCard) {
        cardView.setup(with: card)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

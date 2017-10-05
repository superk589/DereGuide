//
//  CardDetailMVCell.swift
//  DereGuide
//
//  Created by zzk on 29/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

protocol CardDetailMVCellDelegate: class {
    func cardDetailMVCell(_ cardDetailMVCell: CardDetailMVCell, didClickAt charaID: Int)
}

class CardDetailMVCell: UITableViewCell {

    let leftLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftLabel)
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("出演MV", comment: "")
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.axis = .horizontal
        readableContentView.addSubview(stackView)
        for _ in 0..<5 {
            let item = SongDetailPositionCharaItemView()
            charaItems.append(item)
            item.charaIcon.delegate = self
            stackView.addArrangedSubview(item)
        }
        stackView.snp.remakeConstraints { (make) in
            make.top.equalTo(centerLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
            make.width.lessThanOrEqualTo(48 * 5 + 20)
            make.centerX.equalToSuperview()
        }
    }
    
    func setup(song: CGSSSong) {
        charaItems[0].setupWith(charaID: song.charaPosition4)
        charaItems[1].setupWith(charaID: song.charaPosition2)
        charaItems[2].setupWith(charaID: song.charaPosition1)
        charaItems[3].setupWith(charaID: song.charaPosition3)
        charaItems[4].setupWith(charaID: song.charaPosition5)
    }
    
}

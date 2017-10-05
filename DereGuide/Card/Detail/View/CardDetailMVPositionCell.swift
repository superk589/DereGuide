//
//  CardDetailMVPositionCell.swift
//  DereGuide
//
//  Created by zzk on 29/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

protocol CardDetailMVCellDelegate: class {
    func cardDetailMVPositionCell(_ cardDetailMVPositionCell: CardDetailMVPositionCell, didClickAt charaID: Int)
}

class CardDetailMVPositionCell: UITableViewCell {
    
    let leftLabel = UILabel()
    
    let stackView = UIStackView()
    
    var charaItems = [SongDetailPositionCharaItemView]()
    
    weak var delegate: CardDetailMVPositionCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(centerLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("出演MV", comment: "")
        
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
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SongDetailPositionCell: CGSSIconViewDelegate {
    
    func iconClick(_ iv: CGSSIconView) {
        if let charaIcon = iv as? CGSSCharaIconView, let charaID = charaIcon.charaID {
            delegate?.songDetailPositionCell(self, didClickAt: charaID)
        }
    }
    
}

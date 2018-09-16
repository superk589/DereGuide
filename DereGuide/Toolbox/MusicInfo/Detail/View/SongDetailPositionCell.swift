//
//  SongDetailPositionCell.swift
//  DereGuide
//
//  Created by zzk on 28/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

protocol SongDetailPositionCellDelegate: class {
    func songDetailPositionCell(_ songDetailPositionCell: SongDetailPositionCell, didClickAt charaID: Int)
}

class SongDetailPositionCell: ReadableWidthTableViewCell {
    
    let centerLabel = UILabel()
    
    let stackView = UIStackView()
    
    var charaItems = [SongDetailPositionCharaItemView]()
    
    weak var delegate: SongDetailPositionCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        readableContentView.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        centerLabel.font = UIFont.systemFont(ofSize: 16)
        centerLabel.text = NSLocalizedString("MV站位", comment: "")
        
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

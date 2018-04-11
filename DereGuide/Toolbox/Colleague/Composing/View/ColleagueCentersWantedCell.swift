//
//  ColleagueCentersWantedCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class ColleagueCentersWantedCell: ColleagueBaseCell {

    weak var delegate: CenterWantedGroupViewDelegate? {
        didSet {
            editableView.delegate = self.delegate
        }
    }
    
    var editableView = CenterWantedGroupView()
    var infoButton = UIButton(type: .infoLight)
    
    var centers: [(Int, Int)] {
        return editableView.result
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(editableView)
        editableView.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(infoButton)
        infoButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftLabel)
            make.left.equalTo(leftLabel.snp.right).offset(10)
        }
    }
    
    func setup(_ profile: Profile) {
        editableView.setupWith(cardID: Int(profile.guestCuteCardID), minLevel: Int(profile.guestCuteMinLevel), at: 0)
        editableView.setupWith(cardID: Int(profile.guestCoolCardID), minLevel: Int(profile.guestCoolMinLevel), at: 1)
        editableView.setupWith(cardID: Int(profile.guestPassionCardID), minLevel: Int(profile.guestPassionMinLevel), at: 2)
        editableView.setupWith(cardID: Int(profile.guestAllTypeCardID), minLevel: Int(profile.guestAllTypeMinLevel), at: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

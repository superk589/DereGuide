//
//  ColleagueMyFreeCardsCell.swift
//  DereGuide
//
//  Created by zzk on 2019/4/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

class ColleagueMyFreeCardsCell: ColleagueBaseCell {
    
    var editableView = FreeCardGroupView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(editableView)
        editableView.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
    }
    
    func setup(_ profile: Profile) {
        editableView.setupWith(cardID: Int(profile.freeCharaID1), at: 0)
        editableView.setupWith(cardID: Int(profile.freeCharaID2), at: 1)
        editableView.setupWith(cardID: Int(profile.freeCharaID3), at: 2)
        editableView.setupWith(cardID: Int(profile.freeCharaID4), at: 3)
        editableView.setupWith(cardID: Int(profile.freeCharaID5), at: 4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

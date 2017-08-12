//
//  ColleagueMyCentersCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ColleagueMyCentersCell: ColleagueBaseCell {

    weak var delegate: MyCenterGroupViewDelegate? {
        didSet {
            editableView.delegate = self.delegate
        }
    }
    
    var infoButton = UIButton(type: .infoLight)
    var editableView = MyCenterGroupView()
    
    var centers: [(Int, CGSSPotential)] {
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
        editableView.setupWith(cardID: Int(profile.cuteCardID), potential: profile.cutePotential, at: 0)
        editableView.setupWith(cardID: Int(profile.coolCardID), potential: profile.coolPotential, at: 1)
        editableView.setupWith(cardID: Int(profile.passionCardID), potential: profile.passionPotential, at: 2)
        editableView.setupWith(cardID: Int(profile.allTypeCardID), potential: profile.allTypePotential, at: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

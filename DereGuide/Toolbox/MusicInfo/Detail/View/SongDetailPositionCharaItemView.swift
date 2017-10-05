//
//  SongDetailPositionCharaItemView.swift
//  DereGuide
//
//  Created by zzk on 04/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class SongDetailPositionCharaItemView: UIView {

    let charaIcon = CGSSCharaIconView()
    let charaPlaceholder = UIView()
    
    private(set) var charaID: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(charaIcon)
        charaIcon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(charaPlaceholder)
        charaPlaceholder.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        charaPlaceholder.layer.masksToBounds = true
        charaPlaceholder.layer.cornerRadius = 4
        charaPlaceholder.layer.borderWidth = 1 / Screen.scale
        charaPlaceholder.layer.borderColor = UIColor.lightSeparator.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWith(charaID: Int) {
        self.charaID = charaID
        
        if charaID != 0 {
            showsPlaceholder = false
            charaIcon.charaID = charaID
        } else {
            showsPlaceholder = true
            charaIcon.charaID = nil
        }
    }
    
    var showsPlaceholder: Bool = true {
        didSet {
            charaPlaceholder.isHidden = !showsPlaceholder
            charaIcon.isHidden = showsPlaceholder
            bringSubview(toFront: showsPlaceholder ? charaPlaceholder : charaIcon)
        }
    }
}

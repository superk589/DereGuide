//
//  TeamRecentUsedCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class TeamRecentUsedCell: UICollectionViewCell {
    var cardView: TeamSimulationCardView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardView = TeamSimulationCardView()
        contentView.addSubview(cardView)
        cardView.icon.isUserInteractionEnabled = false

        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(with member: CGSSTeamMember) {
        cardView.setup(with: member)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  RecentUsedMemberCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/18.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol RecentUsedMemberCellDelegate: class {
    func didLongPressAt(_ recentUsedMemberCell: RecentUsedMemberCell)
}

class RecentUsedMemberCell: UICollectionViewCell {
    
    var cardView: UnitSimulationCardView!
    
    weak var delegate: RecentUsedMemberCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardView = UnitSimulationCardView()
        contentView.addSubview(cardView)
        cardView.icon.isUserInteractionEnabled = false
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        addGestureRecognizer(press)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.didLongPressAt(self)
        }
    }
    
    func setup(with member: Member) {
        cardView.setup(with: member)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

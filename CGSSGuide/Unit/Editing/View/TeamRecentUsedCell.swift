//
//  TeamRecentUsedCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/18.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol TeamRecentUsedCellDelegate: class {
    func didLongPressAt(_ teamRecentUsedCell: TeamRecentUsedCell)
}

class TeamRecentUsedCell: UICollectionViewCell {
    
    var cardView: TeamSimulationCardView!
    
    weak var delegate: TeamRecentUsedCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardView = TeamSimulationCardView()
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

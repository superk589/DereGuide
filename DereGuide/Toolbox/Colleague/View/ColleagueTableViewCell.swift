//
//  ColleagueTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/15.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol ColleagueTableViewCellDelegate: class {
    func colleagueTableViewCell(_ cell: ColleagueTableViewCell, didTap gameID: String)
    func colleagueTableViewCell(_ cell: ColleagueTableViewCell, didTap cardIcon: CGSSCardIconView)
}

class ColleagueTableViewCell: ReadableWidthTableViewCell {
    
    weak var delegate: ColleagueTableViewCellDelegate?
    
    let gameIDView = UIView()
    let gameIDCopyIcon = UIImageView()
    let gameIDLabel = UILabel()
    
    let nameLabel = UILabel()
    let createdDateLabel = UILabel()
    let messageLabel = UILabel()
    
    let myCenterLabel = UILabel()
    let myCenterGroupView = MyCenterGroupView()
    
    let centerWantedLabel = UILabel()
    let centerWantedGroupView = CenterWantedGroupView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        readableContentView.addSubview(gameIDView)
        gameIDView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.height.equalTo(26)
        }
        gameIDView.backgroundColor = .parade
        gameIDView.layer.cornerRadius = 3
        gameIDView.layer.masksToBounds = true
        
        gameIDCopyIcon.image = #imageLiteral(resourceName: "511-copy-documents").withRenderingMode(.alwaysTemplate)
        gameIDCopyIcon.tintColor = .white
        gameIDView.addSubview(gameIDCopyIcon)
        gameIDCopyIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(5)
            make.height.width.equalTo(18)
        }
        
        gameIDView.addSubview(gameIDLabel)
        gameIDLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 27, bottom: 3, right: 3))
        }
        gameIDLabel.textColor = .white
        gameIDLabel.font = .boldSystemFont(ofSize: 16)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        gameIDView.addGestureRecognizer(tap)
        gameIDView.isUserInteractionEnabled = true
        
        readableContentView.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(gameIDView.snp.right).offset(5)
            make.lastBaseline.equalTo(gameIDLabel)
        }
        
        readableContentView.addSubview(createdDateLabel)
        createdDateLabel.font = .systemFont(ofSize: 14)
        createdDateLabel.textColor = .lightGray
        createdDateLabel.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(gameIDLabel.snp.right).offset(5)
            make.right.equalTo(-10)
            make.lastBaseline.equalTo(nameLabel)
        }
        
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        gameIDView.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        createdDateLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        readableContentView.addSubview(messageLabel)
        messageLabel.numberOfLines = 7
        messageLabel.font = .systemFont(ofSize: 11)
        messageLabel.textColor = .darkGray
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(gameIDView.snp.bottom).offset(5)
            make.right.equalTo(-10)
        }
        
        readableContentView.addSubview(myCenterGroupView)
        myCenterGroupView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(messageLabel.snp.bottom).offset(5)
            make.height.lessThanOrEqualTo(103)
            make.bottom.equalTo(-10)
        }
        myCenterGroupView.delegate = self
        
        selectionStyle = .none
    }
    
    @objc func handleTapGesture(_ tap: UITapGestureRecognizer) {
        delegate?.colleagueTableViewCell(self, didTap: gameIDLabel.text ?? "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ profile: Profile) {
        gameIDLabel.text = profile.gameID
        nameLabel.text = profile.nickName
        messageLabel.text = profile.message
        createdDateLabel.text = profile.remoteCreatedAt?.getElapsedInterval()
        for (index, center) in profile.myCenters.enumerated() {
            myCenterGroupView.setupWith(cardID: center.0, potential: center.1, at: index, hidesIfNeeded: true)
        }
    }
    
}

extension ColleagueTableViewCell: MyCenterGroupViewDelegate {
    
    func profileMemberEditableView(_ profileMemberEditableView: MyCenterGroupView, didLongPressAt item: MyCenterItemView) {
        
    }
    
    func profileMemberEditableView(_ profileMemberEditableView: MyCenterGroupView, didDoubleTap item: MyCenterItemView) {
        
    }
    
    func profileMemberEditableView(_ profileMemberEditableView: MyCenterGroupView, didTap item: MyCenterItemView) {
        delegate?.colleagueTableViewCell(self, didTap: item.cardView.icon)
    }
    
}

//
//  ColleagueTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol ColleagueTableViewCellDelegate: class {
    func colleagueTableViewCell(_ cell: ColleagueTableViewCell, didTap gameID: String)
    func colleagueTableViewCell(_ cell: ColleagueTableViewCell, didTap cardIcon: CGSSCardIconView)
}

class ColleagueTableViewCell: ReadableWidthTableViewCell {
    
    weak var delegate: ColleagueTableViewCellDelegate?
    
    var gameIDView: UIView!
    var gameIDCopyIcon: UIImageView!
    var gameIDLabel: UILabel!
    
    var nameLabel: UILabel!
    var createdDateLabel: UILabel!
    var messageLabel: UILabel!
    
    var myCenterLabel: UILabel!
    var myCenterGroupView: MyCenterGroupView!
    
    var centerWantedLabel: UILabel!
    var centerWantedGroupView: CenterWantedGroupView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        gameIDView = UIView()
        readableContentView.addSubview(gameIDView)
        gameIDView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.height.equalTo(26)
        }
        gameIDView.backgroundColor = Color.parade
        gameIDView.layer.cornerRadius = 3
        gameIDView.layer.masksToBounds = true
        
        gameIDCopyIcon = UIImageView()
        gameIDCopyIcon.image = #imageLiteral(resourceName: "511-copy-documents").withRenderingMode(.alwaysTemplate)
        gameIDCopyIcon.tintColor = UIColor.white
        gameIDView.addSubview(gameIDCopyIcon)
        gameIDCopyIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(5)
            make.height.width.equalTo(18)
        }
        
        gameIDLabel = UILabel()
        gameIDView.addSubview(gameIDLabel)
        gameIDLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 3, left: 27, bottom: 3, right: 3))
        }
        gameIDLabel.textColor = UIColor.white
        gameIDLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        gameIDView.addGestureRecognizer(tap)
        gameIDView.isUserInteractionEnabled = true
        
        nameLabel = UILabel()
        readableContentView.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(gameIDView.snp.right).offset(5)
            make.lastBaseline.equalTo(gameIDLabel)
        }
        
        createdDateLabel = UILabel()
        readableContentView.addSubview(createdDateLabel)
        createdDateLabel.font = UIFont.systemFont(ofSize: 14)
        createdDateLabel.textColor = UIColor.lightGray
        createdDateLabel.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(gameIDLabel.snp.right).offset(5)
            make.right.equalTo(-10)
            make.lastBaseline.equalTo(nameLabel)
        }
        
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        gameIDView.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        createdDateLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        messageLabel = UILabel()
        readableContentView.addSubview(messageLabel)
        messageLabel.numberOfLines = 7
        messageLabel.font = UIFont.systemFont(ofSize: 11)
        messageLabel.textColor = UIColor.darkGray
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(gameIDView.snp.bottom).offset(5)
            make.right.equalTo(-10)
        }
        
        myCenterGroupView = MyCenterGroupView()
        readableContentView.addSubview(myCenterGroupView)
        myCenterGroupView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(messageLabel.snp.bottom).offset(5)
            make.height.lessThanOrEqualTo(89.5)
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
        
//        for (index, center) in profile.centersWanted.enumerated() {
//            centerWantedGroupView.setupWith(cardID: center.0, minLevel: center.1, at: index, hidesIfNeeded: true)
//        }
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        if selected {
//            readableContentView.addSubview(centerWantedLabel)
//            centerWantedLabel.snp.makeConstraints { (make) in
//                make.left.equalTo(10)
//                make.top.equalTo(myCenterGroupView.snp.bottom).offset(10)
//            }
//            readableContentView.addSubview(centerWantedGroupView)
//            centerWantedGroupView.snp.makeConstraints { (make) in
//                make.left.equalToSuperview()
//                make.top.equalTo(centerWantedLabel.snp.bottom).offset(5)
//                make.height.lessThanOrEqualTo(89.5)
//                make.bottom.equalTo(-10)
//            }
//        } else {
//            centerWantedGroupView.removeFromSuperview()
//            centerWantedLabel.removeFromSuperview()
//        }
//        layoutIfNeeded()
//        
//    }
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

//
//  ColleagueTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol ColleagueTableViewCellDelegate: class {
    func colleagueTableViewCell(_ cell: ColleagueTableViewCell, didTap gameID: String)
}

class ColleagueTableViewCell: ReadableWidthTableViewCell {
    
    weak var delegate: ColleagueTableViewCellDelegate?
    
    var nameLabel: UILabel!
    var createdDateLabel: UILabel!
    var gameIDLabel: UILabel!
    var messageLabel: UILabel!
    
    var myCenterLabel: UILabel!
    var myCenterGroupView: MyCenterGroupView!
    
    var centerWantedLabel: UILabel!
    var centerWantedGroupView: CenterWantedGroupView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel()
        readableContentView.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        gameIDLabel = UILabel()
        readableContentView.addSubview(gameIDLabel)
        gameIDLabel.font = UIFont.systemFont(ofSize: 16)
        gameIDLabel.textColor = Color.parade
        gameIDLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.lastBaseline.equalTo(nameLabel)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        gameIDLabel.addGestureRecognizer(tap)
        gameIDLabel.isUserInteractionEnabled = true
        
        createdDateLabel = UILabel()
        readableContentView.addSubview(createdDateLabel)
        createdDateLabel.font = UIFont.systemFont(ofSize: 14)
        createdDateLabel.textColor = UIColor.lightGray
        createdDateLabel.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(gameIDLabel.snp.right).offset(5)
            make.right.equalTo(-10)
            make.lastBaseline.equalTo(nameLabel)
        }
        
        nameLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        gameIDLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        createdDateLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        
        messageLabel = UILabel()
        readableContentView.addSubview(messageLabel)
        messageLabel.numberOfLines = 4
        messageLabel.font = UIFont.systemFont(ofSize: 11)
        messageLabel.textColor = UIColor.darkGray
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(gameIDLabel.snp.bottom).offset(5)
            make.right.equalTo(-10)
        }
        
        myCenterGroupView = MyCenterGroupView()
        readableContentView.addSubview(myCenterGroupView)
        myCenterGroupView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(messageLabel.snp.bottom).offset(5)
            make.height.lessThanOrEqualTo(89.5)
            make.bottom.equalTo(-10).priority(900)
        }
        
        selectionStyle = .none
    }
    
    func handleTapGesture(_ tap: UITapGestureRecognizer) {
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

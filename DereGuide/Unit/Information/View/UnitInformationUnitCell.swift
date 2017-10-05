//
//  UnitInformationUnitCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/20.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol UnitInformationUnitCellDelegate: class  {
    func unitInformationUnitCell(_ unitInformationUnitCell: UnitInformationUnitCell, didClick cardIcon: CGSSCardIconView)
}

class UnitInformationUnitCell: UITableViewCell, CGSSIconViewDelegate {

    var selfLeaderSkillLabel: UnitLeaderSkillView!
    
    var friendLeaderSkillLabel: UnitLeaderSkillView!
    
    var iconStackView: UIStackView!
    
    weak var delegate: UnitInformationUnitCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selfLeaderSkillLabel = UnitLeaderSkillView()
        contentView.addSubview(selfLeaderSkillLabel)
        selfLeaderSkillLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        selfLeaderSkillLabel.arrowDirection = .down

        var icons = [UIView]()
        for _ in 0...5 {
            let icon = CGSSCardIconView()
            icon.delegate = self
            icons.append(icon)
            icon.snp.makeConstraints({ (make) in
                make.height.equalTo(icon.snp.width)
            })
        }
        iconStackView = UIStackView(arrangedSubviews: icons)
        iconStackView.spacing = 5
        iconStackView.distribution = .fillEqually
        
        contentView.addSubview(iconStackView)
        
        iconStackView.snp.makeConstraints { (make) in
            make.top.equalTo(selfLeaderSkillLabel.snp.bottom).offset(3)
            make.left.greaterThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-10)
            // make the view as wide as possible
            make.right.equalTo(-10).priority(900)
            make.left.equalTo(10).priority(900)
            //
            make.width.lessThanOrEqualTo(96 * 6 + 25)
            make.centerX.equalToSuperview()
        }
        
        friendLeaderSkillLabel = UnitLeaderSkillView()
        contentView.addSubview(friendLeaderSkillLabel)
        friendLeaderSkillLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconStackView.snp.bottom).offset(3)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        friendLeaderSkillLabel.arrowDirection = .up
        friendLeaderSkillLabel.descLabel.textAlignment = .right
        
        selfLeaderSkillLabel.sourceView = icons[0]
        friendLeaderSkillLabel.sourceView = icons[5]
        
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with unit: Unit) {
        for i in 0...5 {
            let member = unit[i]
            if let card = member.card, let view = iconStackView.arrangedSubviews[i] as? CGSSCardIconView {
                view.cardID = card.id
            }
        }

        if let selfLeaderRef = unit.leader.card {
            selfLeaderSkillLabel.setupWith(text: "\(NSLocalizedString("队长技能", comment: "队伍详情页面")): \(selfLeaderRef.leaderSkill?.name ?? NSLocalizedString("无", comment: ""))\n\(selfLeaderRef.leaderSkill?.localizedExplain ?? "")", backgroundColor: selfLeaderRef.attColor.mixed(withColor: .white))
        } else {
            selfLeaderSkillLabel.setupWith(text: "", backgroundColor: Color.allType.mixed(withColor: .white))
        }
        if let friendLeaderRef = unit.friendLeader.card {
            friendLeaderSkillLabel.setupWith(text: "\(NSLocalizedString("好友技能", comment: "队伍详情页面")): \(friendLeaderRef.leaderSkill?.name ?? "无")\n\(friendLeaderRef.leaderSkill?.localizedExplain ?? "")", backgroundColor: friendLeaderRef.attColor.mixed(withColor: .white))
        } else {
            friendLeaderSkillLabel.setupWith(text: "", backgroundColor: Color.allType.mixed(withColor: .white))
        }
    }

    func iconClick(_ iv: CGSSIconView) {
        delegate?.unitInformationUnitCell(self, didClick: iv as! CGSSCardIconView)
    }
}

//
//  TeamMemberCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol TeamMemberCellDelegate: class {
    func beginEditingPotentialAndSkillLevel(_ cell: TeamMemberCell)
    func endEditingPotentialAndSkillLevel(_ cell: TeamMemberCell)
    func selectMemberUsingRecentUsedIdols(_ cell: TeamMemberCell)
    func selectMemberUsingCardList(_ cell: TeamMemberCell)
}

class TeamMemberCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: TeamMemberCellDelegate?
    
    var titleLabel: UILabel!
    var nameLabel: UILabel!
    var cardView: TeamSimulationCardView!
    var skillLabel: UILabel!
    var leaderSkillLabel: UILabel!
    var editButton: UIButton!
    var recentUsedButton: UIButton!
    var fullListButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.textAlignment = .center
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.width.equalTo(48)
        }
        
        cardView = TeamSimulationCardView()
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.width.equalTo(48)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cardView.snp.right).offset(10)
            make.top.equalTo(10)
        }
        
        skillLabel = UILabel()
        skillLabel.font = UIFont.systemFont(ofSize: 12)
        skillLabel.textColor = UIColor.darkGray
        skillLabel.numberOfLines = 0
        contentView.addSubview(skillLabel)
        skillLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cardView)
            make.left.equalTo(nameLabel)
            make.right.lessThanOrEqualTo(-10)
        }
        
        leaderSkillLabel = UILabel()
        leaderSkillLabel.font = UIFont.systemFont(ofSize: 12)
        leaderSkillLabel.textColor = UIColor.darkGray
        leaderSkillLabel.numberOfLines = 0
        contentView.addSubview(leaderSkillLabel)
        leaderSkillLabel.snp.makeConstraints { (make) in
            make.top.equalTo(skillLabel.snp.bottom)
            make.left.equalTo(nameLabel)
            make.right.lessThanOrEqualTo(-10)
        }
        
        editButton = UIButton()
        editButton.setTitle(NSLocalizedString("编辑", comment: ""), for: .normal)
        editButton.setTitleColor(Color.parade, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        editButton.addTarget(self, action: #selector(handleEditButton(_:)), for: .touchUpInside)
        
        recentUsedButton = UIButton()
        recentUsedButton.setTitle(NSLocalizedString("最近使用", comment: ""), for: .normal)
        recentUsedButton.setTitleColor(Color.parade, for: .normal)
        recentUsedButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        recentUsedButton.addTarget(self, action: #selector(handleRecentUsedButton(_:)), for: .touchUpInside)
        
        fullListButton = UIButton()
        fullListButton.setTitle(NSLocalizedString("全部偶像", comment: ""), for: .normal)
        fullListButton.setTitleColor(Color.parade, for: .normal)
        fullListButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        fullListButton.addTarget(self, action: #selector(handleFullListButton(_:)), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [editButton, recentUsedButton, fullListButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(68)
            make.right.equalTo(-10)
            make.top.greaterThanOrEqualTo(leaderSkillLabel.snp.bottom)
            make.bottom.equalTo(-3)
        }
    }
    
    @objc func handleEditButton(_ sender: UIButton) {
        delegate?.beginEditingPotentialAndSkillLevel(self)
    }
    
    @objc func handleRecentUsedButton(_ sender: UIButton) {
        delegate?.selectMemberUsingRecentUsedIdols(self)
    }
    
    @objc func handleFullListButton(_ sender: UIButton) {
        delegate?.selectMemberUsingCardList(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSkillLabelWith(_ skill: CGSSSkill?, skillLevel: Int?) {
        let prefix = NSLocalizedString("特技", comment: "") + ": "
        if let skill = skill, let skillLevel = skillLevel {
            skillLabel.text = prefix + skill.getExplainByLevel(skillLevel, languageType: CGSSGlobal.languageType)
        } else {
            skillLabel.text = prefix + NSLocalizedString("无", comment: "空字符串说明文字")
        }
    }
    
    func setupSkillLabelNotAvailable() {
        skillLabel.text = ""
    }
    
    func setupLeaderSkillLabel(with leaderSkill: CGSSLeaderSkill?) {
        let prefix = NSLocalizedString("队长技能", comment: "") + ": "
        if let leaderSkill = leaderSkill {
            leaderSkillLabel.text = prefix + leaderSkill.getLocalizedExplain(languageType: CGSSGlobal.languageType)
        } else {
            leaderSkillLabel.text = prefix + NSLocalizedString("无", comment: "空字符串说明文字")
        }
    }
    
    func setupLeaderSkillLabelNotAvailabel() {
        leaderSkillLabel.text = ""
    }
    
    func setupWith(member: CGSSTeamMember, type: CGSSTeamMemberType) {
        if let card = member.cardRef {
            nameLabel.text = card.chara?.name
            titleLabel.text = type.description
            switch type {
            case .leader:
                setupSkillLabelWith(card.skill, skillLevel: member.skillLevel)
                setupLeaderSkillLabel(with: card.leaderSkill)
                cardView.setupWith(card: card, potential: member.potential, skillLevel: member.skillLevel)
            case .sub:
                setupSkillLabelWith(card.skill, skillLevel: member.skillLevel)
                cardView.setupWith(card: card, potential: member.potential, skillLevel: member.skillLevel)
                setupLeaderSkillLabelNotAvailabel()
            case .friend:
                setupLeaderSkillLabel(with: card.leaderSkill)
                setupSkillLabelNotAvailable()
                cardView.setupWith(card: card, potential: member.potential, skillLevel: nil)
            }
        }
    }
}

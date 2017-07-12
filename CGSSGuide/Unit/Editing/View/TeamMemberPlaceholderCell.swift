//
//  TeamMemberPlaceholderCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol TeamMemberPlaceholderCellDelegate: class {
    func selectFromRecentUsed(_ teamMemberPlaceholderCell: TeamMemberPlaceholderCell)
    func selectFromFullList(_ teamMemberPlaceholderCell: TeamMemberPlaceholderCell)
}

class TeamMemberPlaceholderCell: UITableViewCell {
    
    weak var delegate: TeamMemberPlaceholderCellDelegate?
    
    var titleLabel: UILabel!
    
    var recentUsedButton: UIButton!
    
    var fullListButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.textAlignment = .left
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        recentUsedButton = UIButton()
        recentUsedButton.setTitle(NSLocalizedString("最近使用", comment: ""), for: .normal)
        recentUsedButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        recentUsedButton.setTitleColor(UIColor.lightGray, for: .normal)
        recentUsedButton.addTarget(self, action: #selector(handleRecentUsedButton(_:)), for: .touchUpInside)
        contentView.addSubview(recentUsedButton)
        
        let estimatedHeight = (Screen.height - 106 - 6 / Screen.scale) / 6
        recentUsedButton.snp.makeConstraints { (make) in
            make.left.equalTo(68)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-34).dividedBy(2)
            make.height.equalTo(estimatedHeight)
        }
        
        let line = LineView()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(recentUsedButton.snp.right)
            make.height.equalTo(30)
            make.width.equalTo(1 / Screen.scale)
            make.centerY.equalTo(recentUsedButton.snp.centerY)
        }
        
        fullListButton = UIButton()
        fullListButton.setTitle(NSLocalizedString("全部偶像", comment: ""), for: .normal)
        fullListButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        fullListButton.setTitleColor(UIColor.lightGray, for: .normal)
        fullListButton.addTarget(self, action: #selector(handleFullListButton(_:)), for: .touchUpInside)
        contentView.addSubview(fullListButton)
        fullListButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-34).dividedBy(2)
            make.height.equalTo(estimatedHeight)
        }
    }
    
    func handleFullListButton(_ sender: UIButton) {
        delegate?.selectFromFullList(self)
    }
    
    func handleRecentUsedButton(_ sender: UIButton) {
        delegate?.selectFromRecentUsed(self)
    }
    
    func setup(type: CGSSTeamMemberType) {
        titleLabel.text = type.description
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

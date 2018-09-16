//
//  CardDetailLeaderSkillCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/26.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CardDetailLeaderSkillCell: UITableViewCell {
    
    let leftLabel = UILabel()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.textColor = .black
        leftLabel.font = .systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("队长技能", comment: "通用")
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(10)
            make.top.equalTo(leftLabel)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        selectionStyle = .none

        leftLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        leftLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        leftLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CardDetailLeaderSkillCell: CardDetailSetable {
    
    func setup(with card: CGSSCard) {
        guard let leaderSkill = card.leaderSkill else {
            return
        }
        nameLabel.text = leaderSkill.name
        
        descriptionLabel.text = leaderSkill.localizedExplain
    }
    
}

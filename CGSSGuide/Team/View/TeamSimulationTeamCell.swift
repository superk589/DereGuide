//
//  TeamSimulationTeamCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class PotentialLabel: UILabel {
    
    func setup(with potential: CGSSPotential) {
        let vocal = NSAttributedString.init(string: String(potential.vocalLevel), attributes: [NSForegroundColorAttributeName: Color.vocal, NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
        let dance = NSAttributedString.init(string: String(potential.danceLevel), attributes: [NSForegroundColorAttributeName: Color.dance, NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
        let visual = NSAttributedString.init(string: String(potential.visualLevel), attributes: [NSForegroundColorAttributeName: Color.visual, NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
        let separator = NSAttributedString.init(string: "/", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
        let plus = NSAttributedString.init(string: "+", attributes: [NSForegroundColorAttributeName: Color.allType, NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
        
        self.attributedText = plus + vocal + separator + dance + separator + visual
    }
    
}

class TeamSimulationCardView: UIView {
    
    var icon: CGSSCardIconView
    var skillLabel: UILabel
    var potentialLabel: PotentialLabel
    
    override init(frame: CGRect) {
        potentialLabel = PotentialLabel()
        potentialLabel.adjustsFontSizeToFitWidth = true
        
        icon = CGSSCardIconView()
        skillLabel = UILabel()
        skillLabel.adjustsFontSizeToFitWidth = true
        skillLabel.font = UIFont.systemFont(ofSize: 12)
        skillLabel.textColor = UIColor.darkGray
        
        super.init(frame: frame)
        addSubview(skillLabel)
        addSubview(icon)
        addSubview(potentialLabel)
        
        skillLabel.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        potentialLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(potentialLabel.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(snp.width)
            make.bottom.equalTo(skillLabel.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol TeamSimulationTeamCellDelegate: class {
    func teamSimulationTeamCell(_ teamSimulationTeamCell: TeamSimulationTeamCell, didClick cardIcon: CGSSCardIconView)
}

class TeamSimulationTeamCell: UITableViewCell, CGSSIconViewDelegate {
    
    var iconStackView: UIStackView!
    
    weak var delegate: TeamSimulationTeamCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var views = [UIView]()
        for _ in 0...5 {
            let view = TeamSimulationCardView()
            view.icon.delegate = self
            views.append(view)
        }
        iconStackView = UIStackView(arrangedSubviews: views)
        iconStackView.spacing = 5
        iconStackView.distribution = .fillEqually
        
        contentView.addSubview(iconStackView)
        
        iconStackView.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
        }

        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with team: CGSSTeam) {
        for i in 0...5 {
            if let teamMember = team[i], let card = teamMember.cardRef, let view = iconStackView.arrangedSubviews[i] as? TeamSimulationCardView {
                view.icon.cardId = card.id
                if i == 5 || card.skill == nil {
                    view.skillLabel.text = "n/a"
                } else {
                    if let skillLevel = teamMember.skillLevel {
                        view.skillLabel.text = "SLv.\(skillLevel)"
                    }
                }
                view.potentialLabel.setup(with: teamMember.potential)
            }
        }
        
    }

    func iconClick(_ iv: CGSSIconView) {
        delegate?.teamSimulationTeamCell(self, didClick: iv as! CGSSCardIconView)
    }
}

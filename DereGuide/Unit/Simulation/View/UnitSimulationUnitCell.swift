//
//  UnitSimulationUnitCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class PotentialLabel: UILabel {
    
    func setup(with potential: CGSSPotential) {
        let vocal = NSAttributedString.init(string: String(potential.vocalLevel), attributes: [NSAttributedStringKey.foregroundColor: Color.vocal, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        let dance = NSAttributedString.init(string: String(potential.danceLevel), attributes: [NSAttributedStringKey.foregroundColor: Color.dance, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        let visual = NSAttributedString.init(string: String(potential.visualLevel), attributes: [NSAttributedStringKey.foregroundColor: Color.visual, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        let life = NSAttributedString.init(string: String(potential.lifeLevel), attributes: [NSAttributedStringKey.foregroundColor: Color.life, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        let separator = NSAttributedString.init(string: "/", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
//        let plus = NSAttributedString.init(string: "+", attributes: [NSAttributedStringKey.foregroundColor: Color.allType, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        
        self.attributedText = vocal + separator + dance + separator + visual + separator + life
    }
    
}

class UnitSimulationCardView: UIView {
    
    let icon = CGSSCardIconView()
    let skillLabel = UILabel()
    let potentialLabel = PotentialLabel()

    override init(frame: CGRect) {
        potentialLabel.adjustsFontSizeToFitWidth = true
        
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
            make.bottom.equalToSuperview()
        }
        
        potentialLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(skillLabel)
        }
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(potentialLabel.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(snp.width)
            make.bottom.equalTo(skillLabel.snp.top)
        }
        
//        skillLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
//        potentialLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
//        skillLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
//        potentialLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        
    }
    
    func setupWith(card: CGSSCard, potential: CGSSPotential, skillLevel: Int?) {
        icon.cardID = card.id
        potentialLabel.setup(with: potential)
        if let level = skillLevel {
            skillLabel.text = "SLv.\(level)"
        } else {
            skillLabel.text = "n/a"
        }
    }
    
    func setup(with member: Member) {
        guard let card = member.card else {
            return
        }
        setupWith(card: card, potential: member.potential, skillLevel: Int(member.skillLevel))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol UnitSimulationUnitCellDelegate: class {
    func unitSimulationUnitCell(_ unitSimulationUnitCell: UnitSimulationUnitCell, didClick cardIcon: CGSSCardIconView)
}

class UnitSimulationUnitCell: UITableViewCell, CGSSIconViewDelegate {
    
    var iconStackView: UIStackView!
    
    weak var delegate: UnitSimulationUnitCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var views = [UIView]()
        for _ in 0...5 {
            let view = UnitSimulationCardView()
            view.icon.delegate = self
            views.append(view)
        }
        iconStackView = UIStackView(arrangedSubviews: views)
        iconStackView.spacing = 5
        iconStackView.distribution = .fillEqually
        
        contentView.addSubview(iconStackView)
        
        iconStackView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.greaterThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-10)
            // make the view as wide as possible
            make.right.equalTo(-10).priority(900)
            make.left.equalTo(10).priority(900)
            //
            make.bottom.equalTo(-10)
            make.width.lessThanOrEqualTo(96 * 6 + 25)
            make.centerX.equalToSuperview()
        }

        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with unit: Unit) {
        for i in 0...5 {
            let member = unit[i]
            if let card = member.card, let view = iconStackView.arrangedSubviews[i] as? UnitSimulationCardView {
                if i == 5 || card.skill == nil {
                    view.setupWith(card: card, potential: member.potential, skillLevel: nil)
                } else {
                    let skillLevel = member.skillLevel
                    view.setupWith(card: card, potential: member.potential, skillLevel: Int(skillLevel))
                }
            }
        }
    }

    func iconClick(_ iv: CGSSIconView) {
        delegate?.unitSimulationUnitCell(self, didClick: iv as! CGSSCardIconView)
    }
}

//
//  TeamTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class TeamTableViewCell: UITableViewCell {
    
    var iconStackView: UIStackView!
    var cardIcons: [CGSSCardIconView] {
        return iconStackView.arrangedSubviews.flatMap{ ($0 as? TeamSimulationCardView)?.icon }
    }
    
//    var appealStackView: UIStackView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
    }
    
    private func prepareUI() {
        var views = [UIView]()
        for _ in 0...5 {
            let view = TeamSimulationCardView()
            views.append(view)
        }
        iconStackView = UIStackView(arrangedSubviews: views)
        iconStackView.spacing = 5
        iconStackView.distribution = .fillEqually
        iconStackView.isUserInteractionEnabled = false
        contentView.addSubview(iconStackView)
        
//        var labels = [UILabel]()
//        let colors = [Color.life, Color.vocal, Color.dance, Color.visual, UIColor.darkGray]
//        for i in 0...4 {
//            let label = UILabel()
//            label.font = UIFont.init(name: "menlo", size: 12)
//            label.textColor = colors[i]
//            labels.append(label)
//        }
//        
//        appealStackView = UIStackView(arrangedSubviews: labels)
//        appealStackView.spacing = 5
//        appealStackView.distribution = .equalCentering
//        contentView.addSubview(appealStackView)
        
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
        
//        appealStackView.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.top.equalTo(iconStackView.snp.bottom)
//            make.bottom.equalTo(-5)
//        }
        accessoryType = .disclosureIndicator
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareUI()
    }
    
    func setup(with unit: Unit) {
        for i in 0...5 {
            let member = unit[i]
            if let card = member.card, let view = iconStackView.arrangedSubviews[i] as? TeamSimulationCardView {
                view.icon.cardId = card.id
                if i != 5 {
                    if card.skill != nil {
                        view.skillLabel.text = "SLv.\((member.skillLevel))"
                    } else {
                        view.skillLabel.text = "n/a"
                    }
                } else {
                    view.skillLabel.text = "n/a"
                }
                view.potentialLabel.setup(with: member.potential)
            }
        }
    }
    
}

//
//  UnitSimulationCommonCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/1.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitSimulationCommonCell: UITableViewCell {

    let leftLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        leftLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        accessoryType = .disclosureIndicator
    }
    
    func setup(with title: String) {
        leftLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

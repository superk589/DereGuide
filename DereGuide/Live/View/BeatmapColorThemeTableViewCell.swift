//
//  BeatmapColorThemeTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 16/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class BeatmapColorThemeTableViewCell: UITableViewCell {
    
    let leftLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
        }
        selectionStyle = .none
    }
    
    func setup(_ type: BeatmapAdvanceOptionsViewController.Setting.ColorTheme) {
        leftLabel.text = type.description
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var customSelected: Bool = false {
        didSet {
            accessoryType = customSelected ? .checkmark : .none
        }
    }

}

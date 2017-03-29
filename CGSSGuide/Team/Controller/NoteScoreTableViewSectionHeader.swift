//
//  NoteScoreTableViewSectionHeader.swift
//  CGSSGuide
//
//  Created by zzk on 2017/3/29.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class NoteScoreTableViewSectionHeader: UITableViewHeaderFooterView {

    var labelTitles = [
        NSLocalizedString("Combo", comment: ""),
        NSLocalizedString("P↑", comment: ""),
        NSLocalizedString("C↑", comment: ""),
        NSLocalizedString("SB↑", comment: ""),
        NSLocalizedString("得分", comment: ""),
        NSLocalizedString("累计", comment: "")
    ]
    
    var labels = [UILabel]()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        for title in labelTitles {
            let label = UILabel()
            label.adjustsFontSizeToFitWidth = true
            label.text = title
            label.textAlignment = .center
            label.baselineAdjustment = .alignCenters
            contentView.addSubview(label)
            labels.append(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 5
        for i in 0..<labels.count {
            let label = labels[i]
            let width = (bounds.size.width - CGFloat(labels.count + 1) * space) / CGFloat(labels.count)
            let height = bounds.size.height
            label.frame = CGRect.init(x: CGFloat(i) * width + CGFloat(i + 1) * space, y: 0, width: width, height: height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  NoteScoreTableViewSectionHeader.swift
//  DereGuide
//
//  Created by zzk on 2017/3/29.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class NoteScoreTableViewSectionHeader: UITableViewHeaderFooterView {

    enum Title {
        case text(String)
        case icon(UIImage)
    }
    
    var labelTitles: [Title] = [
        .text(NSLocalizedString("Combo", comment: "")),
        .icon(#imageLiteral(resourceName: "score-bonus")),
        .icon(#imageLiteral(resourceName: "combo-bonus")),
        .icon(#imageLiteral(resourceName: "skill-boost")),
        .text(NSLocalizedString("得分", comment: "")),
        .text(NSLocalizedString("累计", comment: ""))
    ]
    
    var titleViews = [UIView]()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        for title in labelTitles {
            switch title {
            case .icon(let image):
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                contentView.addSubview(imageView)
                titleViews.append(imageView)
            case .text(let text):
                let label = UILabel()
                label.adjustsFontSizeToFitWidth = true
                label.text = text
                label.textAlignment = .center
                label.baselineAdjustment = .alignCenters
                contentView.addSubview(label)
                titleViews.append(label)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let space: CGFloat = 5
        for i in 0..<titleViews.count {
            let view = titleViews[i]
            let width = (bounds.size.width - CGFloat(titleViews.count + 1) * space) / CGFloat(titleViews.count)
            let height = bounds.size.height
            view.frame = CGRect.init(x: CGFloat(i) * width + CGFloat(i + 1) * space, y: 0, width: width, height: height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

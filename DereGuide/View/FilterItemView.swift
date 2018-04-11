//
//  FilterItemView.swift
//  DereGuide
//
//  Created by zzk on 2017/1/12.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit
import ZKCornerRadiusView

class FilterItemView: UIView {

    let iv = ZKCornerRadiusView()
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iv)

        iv.zk.cornerRadius = 3
        iv.zk.backgroundColor = .parade
        
        addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center

    }
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                iv.isHidden = false
                label.textColor = .white
            } else {
                iv.isHidden = true
                label.textColor = .parade
            }
        }
    }
    
    func setSelected(selected: Bool) {
        isSelected = selected
    }
    
    func setTitle(title: String) {
        self.label.text = title
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        label.sizeToFit()
        var frame = label.bounds
        frame.size.width += 12
        frame.size.height += 12
        return frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iv.frame = bounds
        iv.render()
        label.sizeToFit()
        label.frame.origin = CGPoint.init(x: 6, y: 6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

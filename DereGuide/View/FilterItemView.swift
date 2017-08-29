//
//  FilterItemView.swift
//  DereGuide
//
//  Created by zzk on 2017/1/12.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import ZKCornerRadiusView

class FilterItemView: UIView {

    var iv: ZKCornerRadiusView!
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iv = ZKCornerRadiusView()
        addSubview(iv)

        iv.zk.cornerRadius = 3
        iv.zk.backgroundColor = Color.dance
        
        label = UILabel()
        addSubview(label)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center

    }
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                iv.isHidden = false
                label.textColor = UIColor.white
            } else {
                iv.isHidden = true
                label.textColor = Color.dance
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
        iv.frame = self.bounds
        iv.render()
        label.sizeToFit()
        label.frame.origin = CGPoint.init(x: 6, y: 6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  CheckBox.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CheckBox: UIView {
        
    var icon: UIImageView!
    var label: UILabel!
    var isChecked = false {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if isChecked {
            icon.image = #imageLiteral(resourceName: "888-checkmark-toolbar-selected").withRenderingMode(.alwaysTemplate)
        } else {
            icon.image = #imageLiteral(resourceName: "888-checkmark-toolbar").withRenderingMode(.alwaysTemplate)
        }
    }
    
    func setChecked(_ checked: Bool) {
        isChecked = checked
    }
    
    override var intrinsicContentSize: CGSize {
        var size = label.intrinsicContentSize
        size.width += size.height + 5
        return size
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        icon = UIImageView()
        addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(self.snp.height)
        }
        label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

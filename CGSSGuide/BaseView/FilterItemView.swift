//
//  FilterItemView.swift
//  CGSSGuide
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
        iv.zk_cornerRadius = 3
        iv.tintColor = Color.parade
        iv.image = #imageLiteral(resourceName: "icon_placeholder").withRenderingMode(.alwaysTemplate)
        
        label = UILabel()
        addSubview(label)
        label.font = UIFont.regular(size: 12)
        label.textAlignment = .center
        label.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
            make.left.equalTo(3)
            make.right.equalTo(-3)
            make.width.greaterThanOrEqualTo(26)
        }

    }
    
    func setSelected(selected: Bool) {
        if selected {
            iv.isHidden = false
            label.textColor = UIColor.white
        } else {
            iv.isHidden = true
            label.textColor = Color.parade
        }
    }
    
    func setTitle(title: String) {
        self.label.text = title
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

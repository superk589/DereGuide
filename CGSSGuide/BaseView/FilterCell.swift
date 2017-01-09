//
//  FilterCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import ZKCornerRadiusView

class FilterCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var colorView: ZKCornerRadiusView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorView = ZKCornerRadiusView()
        contentView.addSubview(colorView)
        colorView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        colorView.zk_cornerRadius = 3
        colorView.image = #imageLiteral(resourceName: "icon_placeholder")
        colorView.layer.borderWidth = 1 / Screen.scale
        colorView.layer.borderColor = selectColor.cgColor
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.top.equalTo(3)
            make.bottom.equalTo(-3)
        }
        titleLabel.font = UIFont.regular(size: 14)
    }
    
    var customSelected: Bool = false {
        didSet {
            if customSelected {
                colorView.tintColor = selectColor
                
            } else {
                colorView.tintColor = UIColor.clear
            }
        }
    }
    
    var selectColor: UIColor = Color.parade {
        didSet {
            colorView.layer.borderColor = selectColor.cgColor
        }
    }
    
    func setup(title:String) {
        self.titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  CharaProfileTitleView.swift
//  DereGuide
//
//  Created by zzk on 08/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import ZKCornerRadiusView

class CharaProfileTitleView: UIView {

    var label: CharaProfileTitleLabel!
    var backgoundImageView: ZKCornerRadiusView!
    var text: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgoundImageView = ZKCornerRadiusView()
        addSubview(backgoundImageView)
        backgoundImageView.zk.cornerRadius = 6
        backgoundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        label = CharaProfileTitleLabel.init(frame: CGRect(x: 5, y: 0, width: frame.size.width - 10, height: frame.size.height))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(label)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(5)
            make.right.lessThanOrEqualTo(-5)
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgoundImageView.image = nil
        backgoundImageView.render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

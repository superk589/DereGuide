//
//  LiveDifficultyView.swift
//  DereGuide
//
//  Created by zzk on 2017/7/5.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import ZKCornerRadiusView

class LiveDifficultyView: UIView {
    var label: UILabel!
    var backgoundView: ZKCornerRadiusView!
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
        backgoundView = ZKCornerRadiusView.init(frame: self.bounds)
        addSubview(backgoundView)
        backgoundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        label = UILabel()
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textColor = .darkGray
        label.textAlignment = .center
        backgoundView.zk.cornerRadius = 8
    }
    
    func addTarget(_ target: AnyObject?, action: Selector) {
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        self.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgoundView.image = nil
        backgoundView.render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

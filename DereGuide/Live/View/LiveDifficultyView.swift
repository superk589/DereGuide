//
//  LiveDifficultyView.swift
//  DereGuide
//
//  Created by zzk on 2017/7/5.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import ZKCornerRadiusView

class LiveDifficultyView: UIView {
    
    let label = UILabel()
    let subtitleLabel = UILabel()
    private(set) lazy var backgoundView = ZKCornerRadiusView(frame: self.bounds)
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(backgoundView)
        backgoundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        addSubview(subtitleLabel)
        addSubview(label)
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.textColor = .darkGray
        subtitleLabel.font = .systemFont(ofSize: 14)
       
        label.font = .boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.textColor = .darkGray
        label.textAlignment = .center
        backgoundView.zk.cornerRadius = 8
    }
    
    func setup(title: String, subtitle: String?) {
        label.text = title
        subtitleLabel.text = subtitle
        if let _ = subtitle {
            label.snp.remakeConstraints { (make) in
                make.left.equalTo(5)
                make.right.equalTo(-5)
                make.top.equalToSuperview()
            }
            subtitleLabel.isHidden = false
            subtitleLabel.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.equalTo(5)
                make.right.equalTo(-5)
            }
        } else {
            label.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
                make.left.equalTo(5)
                make.right.equalTo(-5)
            }
            subtitleLabel.snp.removeConstraints()
            subtitleLabel.isHidden = true
        }
    }
    
    func addTarget(_ target: AnyObject?, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
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

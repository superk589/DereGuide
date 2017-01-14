//
//  EventStatusIndicator.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/14.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class EventStatusIndicator: UIView {
    
    var isShiny: Bool = false {
        didSet {
            if isShiny {
                self.grayView.isHidden = true
                self.shinyCenterView.isHidden = false
                self.shinyView.isHidden = false
            } else {
                self.grayView.isHidden = false
                self.shinyCenterView.isHidden = true
                self.shinyView.isHidden = true
            }
        }
    }
    
    
    var grayView: UIView!
    
    var shinyView: UIView!
    
    var shinyCenterView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        grayView = UIView()
        addSubview(grayView)
        grayView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().dividedBy(4)
            make.center.equalToSuperview()
        }
        
        grayView.backgroundColor = Color.allType
        grayView.layer.masksToBounds = true
        
        shinyView = UIView()
        
        addSubview(shinyView)
        shinyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        shinyView.backgroundColor = Color.parade.withAlphaComponent(0.5)
        shinyCenterView = UIView()
        shinyView.addSubview(shinyCenterView)
        shinyCenterView.snp.makeConstraints { (make) in
            make.height.width.equalToSuperview().multipliedBy(0.5)
            make.center.equalToSuperview()
        }
        shinyCenterView.backgroundColor = Color.parade
        
        shinyView.layer.masksToBounds = true
        shinyCenterView.layer.masksToBounds = true
        shinyView.isHidden = true
        shinyCenterView.isHidden = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        grayView.layer.cornerRadius = grayView.fheight / 2
        shinyView.layer.cornerRadius = shinyView.fheight / 2
        shinyView.layoutIfNeeded()
        shinyCenterView.layer.cornerRadius = shinyCenterView.fheight / 2
    }
    
    var shinyColor: UIColor = Color.parade {
        didSet {
            shinyView.backgroundColor = shinyColor.withAlphaComponent(0.5)
            shinyCenterView.backgroundColor = shinyColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

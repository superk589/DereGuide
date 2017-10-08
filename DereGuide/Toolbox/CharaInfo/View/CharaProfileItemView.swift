//
//  CharaProfileItemView.swift
//  DereGuide
//
//  Created by zzk on 08/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class CharaProfileItemView: UIView {
    
    var titleView: CharaProfileTitleView!
    var contentLabel: CharaProfileContentLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleView = CharaProfileTitleView()
        // .init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        contentLabel = CharaProfileContentLabel()
        // .init(frame: CGRect(x: 65, y: 0, width: frame.size.width - 65, height: 30))
        addSubview(titleView)
        addSubview(contentLabel)
        
        titleView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleView.snp.right).offset(5)
            make.right.top.bottom.equalToSuperview()
        }
    }
    
    func setup(_ desc: String, content: String) {
        titleView.text = desc
        contentLabel.text = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

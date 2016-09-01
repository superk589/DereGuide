//
//  CharDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

private let topSpace: CGFloat = 10
private let leftSpace: CGFloat = 10
private let bottomInset: CGFloat = 30

protocol CharDetilViewDelegate: class {
    func CardIconClick()
    
}

class CharDetailView: UIView {
    weak var delegate: CharDetilViewDelegate?
    
    var charIconView: CGSSCharIconView!
    var charNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    var basicView: UIView!
    var detailView: UIView!
    var relatedView: UIView!
    
    var profileView: CharProfileView!
    
    private func prepare() {
        basicView = UIView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 68))
        charIconView = CGSSCharIconView(frame: CGRectMake(10, 10, 48, 48))
        
        charNameLabel = UILabel()
        charNameLabel.frame = CGRectMake(68, 26, CGSSGlobal.width - 78, 16)
        charNameLabel.font = UIFont.systemFontOfSize(16)
        charNameLabel.adjustsFontSizeToFitWidth = true
        
        basicView.addSubview(charNameLabel)
        basicView.addSubview(charIconView)
        addSubview(basicView)
        
        profileView = CharProfileView.init(frame: CGRectMake(10, 78, CGSSGlobal.width - 20, 0))
        addSubview(profileView)
        
    }
    
    func setup(char: CGSSChar) {
        charNameLabel.text = "\(char.kanjiSpaced)  \(char.conventional)"
        charIconView.setWithCharId(char.charaId)
        profileView.setup(char)
        fheight = profileView.fheight + profileView.fy
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}

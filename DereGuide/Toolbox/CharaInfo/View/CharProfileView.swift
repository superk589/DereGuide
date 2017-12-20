//
//  CharaProfileView.swift
//  DereGuide
//
//  Created by zzk on 16/9/1.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CharaProfileView: UIView {
    
    var nameKanaCell: CharaProfileItemView!
    var heightCell: CharaProfileItemView!
    var ageCell: CharaProfileItemView!
    var weightCell: CharaProfileItemView!
    var birthdayCell: CharaProfileItemView!
    var bloodCell: CharaProfileItemView!
    var handCell: CharaProfileItemView!
    var threeSizeCell: CharaProfileItemView!
    var constellationCell: CharaProfileItemView!
    var homeTownCell: CharaProfileItemView!
    var favoriteCell: CharaProfileItemView!
    var voiceCell: CharaProfileItemView!
    
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameKanaCell = CharaProfileItemView()
        
        heightCell = CharaProfileItemView()
        
        ageCell = CharaProfileItemView()
        
        let stackView1 = UIStackView(arrangedSubviews: [heightCell, ageCell])
        stackView1.distribution = .fillEqually
        
        weightCell = CharaProfileItemView()
        birthdayCell = CharaProfileItemView()
        
        let stackView2 = UIStackView(arrangedSubviews: [weightCell, birthdayCell])
        stackView2.distribution = .fillEqually
        
        
        bloodCell = CharaProfileItemView()
        
        handCell = CharaProfileItemView()
        
        let stackView3 = UIStackView(arrangedSubviews: [bloodCell, handCell])
        stackView3.distribution = .fillEqually
        
        
        threeSizeCell = CharaProfileItemView()
        
        constellationCell = CharaProfileItemView()
        
        homeTownCell = CharaProfileItemView()
        
        favoriteCell = CharaProfileItemView()
        
        voiceCell = CharaProfileItemView()
        
        stackView = UIStackView(arrangedSubviews: [nameKanaCell, stackView1, stackView2, stackView3, threeSizeCell, constellationCell, homeTownCell, favoriteCell, voiceCell])
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(30 * 9 + 10 * 8)
        }
    }
    
    func setup(_ char: CGSSChar) {
        nameKanaCell.setup(NSLocalizedString("姓名假名", comment: "角色信息页面"), content: char.kanaSpaced!)
        heightCell.setup(NSLocalizedString("身高", comment: "角色信息页面"), content: "\(char.height!)cm")
        ageCell.setup(NSLocalizedString("年龄", comment: "角色信息页面"), content: char.ageString())
        weightCell.setup(NSLocalizedString("体重", comment: "角色信息页面"), content: "\(char.weightString())")
        birthdayCell.setup(NSLocalizedString("生日", comment: "角色信息页面"), content: String.init(format: NSLocalizedString("%d月%d日", comment: "角色信息页面"), char.birthMonth!, char.birthDay!))
        bloodCell.setup(NSLocalizedString("血型", comment: "角色信息页面"), content: char.bloodTypeString)
        handCell.setup(NSLocalizedString("习惯用手", comment: "角色信息页面"), content: char.handString())
        threeSizeCell.setup(NSLocalizedString("三围", comment: "角色信息页面"), content: char.threeSizeString())
        constellationCell.setup(NSLocalizedString("星座", comment: "角色信息页面"), content: char.constellationString())
        homeTownCell.setup(NSLocalizedString("出生地", comment: "角色信息页面"), content: char.homeTownString())
        favoriteCell.setup(NSLocalizedString("兴趣", comment: "角色信息页面"), content: char.favorite)
        voiceCell.setup("CV", content: char.voiceFromDB ?? "")
        
        for subView in stackView.arrangedSubviews {
            if let backgroundImageView = (subView as? CharaProfileItemView)?.titleView.backgoundImageView {
                backgroundImageView.zk.backgroundColor = char.attColor.lighter()
            } else if let views = (subView as? UIStackView)?.arrangedSubviews {
                for view in views {
                    if let backgroundImageView = (view as? CharaProfileItemView)?.titleView.backgoundImageView {
                        backgroundImageView.zk.backgroundColor = char.attColor.lighter()
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  CenterWantedEditingView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol CenterWantedEditingViewDelegate: class {
    func didDelete(centerWantedEditingView: CenterWantedEditingView)
}

class CenterWantedEditingView: UIView {

    var deleteButton: UIButton!
    
    var stackView: UIStackView!
    
    var card: CGSSCard!
    
    weak var delegate: CenterWantedEditingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    func prepare() {
        
        deleteButton = UIButton()
        deleteButton.setTitle(NSLocalizedString("删除", comment: ""), for: .normal)
        deleteButton.titleLabel?.textColor = UIColor.white
        deleteButton.backgroundColor = Color.vocal
        deleteButton.addTarget(self, action: #selector(handleDeleteButton(_:)), for: .touchUpInside)
        deleteButton.layer.cornerRadius = 4
        deleteButton.layer.masksToBounds = true
        
        stackView = UIStackView(arrangedSubviews: [deleteButton])
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
    }

    func handleDeleteButton(_ button: UIButton) {
        delegate?.didDelete(centerWantedEditingView: self)
    }
    
    func setupWith(card: CGSSCard) {
        self.card = card
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  ColleagueButtonsCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol ColleaColleagueButtonsCellDelegate: class {
    func didRevoke(_ colleagueButtonsCell: ColleagueButtonsCell)
//    func didPost(_ colleagueButtonsCell: ColleagueButtonsCell)
    func didSave(_ colleagueButtonsCell: ColleagueButtonsCell)
}

class ColleagueDescriptionLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfLines = 0
        font = .systemFont(ofSize: 14)
        textColor = .darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ColleagueButtonsCell: UITableViewCell {
    
    let revokeButton = WideButton()
//    let postButton = Widebutton()
    let saveButton = WideButton()
    
    weak var delegate: ColleaColleagueButtonsCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        let descriptionLabel1 = ColleagueDescriptionLabel()
//        descriptionLabel1.text = NSLocalizedString("向所有用户公开您的信息", comment: "")
//        contentView.addSubview(descriptionLabel1)
//        descriptionLabel1.snp.makeConstraints { (make) in
//            make.top.left.equalTo(10)
//            make.right.lessThanOrEqualTo(-10)
//        }
//
//        postButton.setTitle(NSLocalizedString("发布", comment: ""), for: .normal)
//        postButton.titleLabel?.textColor = UIColor.white
//        postButton.backgroundColor = Color.cool
//        postButton.addTarget(self, action: #selector(handlePostButton(_:)), for: .touchUpInside)
//        contentView.addSubview(postButton)
//        postButton.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
//            make.top.equalTo(descriptionLabel1.snp.bottom).offset(5)
//            make.height.equalTo(40)
//        }
        
        let descriptionLabel2 = ColleagueDescriptionLabel()
        descriptionLabel2.text = NSLocalizedString("保存信息，但是暂不公开", comment: "")
        contentView.addSubview(descriptionLabel2)
        descriptionLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
//            make.top.equalTo(postButton.snp.bottom).offset(20)
            make.right.lessThanOrEqualTo(-10)
        }

        saveButton.setTitle(NSLocalizedString("保存", comment: ""), for: .normal)
        saveButton.backgroundColor = Color.dance
        saveButton.addTarget(self, action: #selector(handleSaveButton(_:)), for: .touchUpInside)
        contentView.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(descriptionLabel2.snp.bottom).offset(5)
        }
        
        let descriptionLabel3 = ColleagueDescriptionLabel()
        descriptionLabel3.text = NSLocalizedString("不再公开您之前已经发布的信息", comment: "")
        contentView.addSubview(descriptionLabel3)
        descriptionLabel3.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.right.lessThanOrEqualTo(-10)
        }
        
        revokeButton.setTitle(NSLocalizedString("撤销", comment: ""), for: .normal)
        revokeButton.backgroundColor = Color.vocal
        revokeButton.addTarget(self, action: #selector(handleRevokeButton(_:)), for: .touchUpInside)
        contentView.addSubview(revokeButton)
        revokeButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(descriptionLabel3.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        
    }
    
    @objc func handleRevokeButton(_ button: UIButton) {
        delegate?.didRevoke(self)
    }
    
//    func handlePostButton(_ button: UIButton) {
//        delegate?.didPost(self)
//    }
    
    @objc func handleSaveButton(_ button: UIButton) {
        delegate?.didSave(self)
    }
    
    private lazy var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    func setRevoking(_ isRevoking: Bool) {
        if isRevoking {
            revokeButton.isUserInteractionEnabled = false
            revokeButton.setTitle(NSLocalizedString("撤销中...", comment: ""), for: .normal)
            revokeButton.addSubview(indicator)
            indicator.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(revokeButton.titleLabel!.snp.left)
            }
            indicator.startAnimating()
        } else {
            revokeButton.isUserInteractionEnabled = true
            revokeButton.setTitle(NSLocalizedString("撤销", comment: ""), for: .normal)
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

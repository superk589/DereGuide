//
//  ColleagueRevokeCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol ColleagueRevokeCellDelegate: class {
    func didRevoke(_ colleagueRevokeCell: ColleaguePostButton)
}

class ColleaguePostButton: UITableViewCell {
    
    var revokeButton = UIButton()
    
    weak var delegate: ColleagueRevokeCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(revokeButton)
        revokeButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(40)
        }
        
        revokeButton.setTitle(NSLocalizedString("发布", comment: ""), for: .normal)
        revokeButton.titleLabel?.textColor = UIColor.white
        revokeButton.backgroundColor = Color.cool
        revokeButton.addTarget(self, action: #selector(handleRevokeButton(_:)), for: .touchUpInside)
        
    }
    
    func handleRevokeButton(_ button: UIButton) {
        delegate?.didRevoke(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

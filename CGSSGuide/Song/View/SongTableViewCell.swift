//
//  SongTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ZKCornerRadiusView
import SnapKit

typealias SongTableViewCellDelegate = LiveViewDelegate

class SongTableViewCell: UITableViewCell {
    
    weak var delegate: SongTableViewCellDelegate? {
        didSet {
            liveView.delegate = self.delegate
        }
    }
    
    var liveView: LiveView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        liveView = LiveView()
        
        contentView.addSubview(liveView)
        liveView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(768)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.left.equalToSuperview().priority(900)
            make.right.equalToSuperview().priority(900)
            make.centerX.equalToSuperview()
        }
        let line = LineView()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(liveView)
            make.bottom.equalToSuperview()
        }
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with live: CGSSLive) {
        liveView.setup(with: live)
    }
}

//
//  SongTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 16/7/23.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

typealias SongTableViewCellDelegate = LiveViewDelegate

class SongTableViewCell: ReadableWidthTableViewCell {
    
    weak var delegate: SongTableViewCellDelegate? {
        didSet {
            liveView.delegate = self.delegate
        }
    }
    
    var liveView: LiveView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        liveView = LiveView()
        readableContentView.addSubview(liveView)
        liveView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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

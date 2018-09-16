//
//  GachaTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017 zzk. All rights reserved.
//


import UIKit
import SnapKit

class GachaTableViewCell: UITableViewCell {
    
    let banner = BannerView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let startLabel = UILabel()
    let startDateView = UIView()
    let endLabel = UILabel()

    var statusIndicator = TimeStatusIndicator()
    
    static let estimatedHeight: CGFloat = (Screen.width - 33 - 32) * (212 / 824) + 53

    private let topSpace: CGFloat = 10
    private let leftSpace: CGFloat = 10
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(32)
            make.right.lessThanOrEqualToSuperview()
            make.left.equalTo(32).priority(900)
            make.right.equalToSuperview().priority(900)
            make.bottom.equalTo(-10)
            make.centerX.equalToSuperview().offset(11)
            make.width.lessThanOrEqualTo(824)
            make.height.equalTo(banner.snp.width).multipliedBy(212.0 / 824.0)
        }
        let separator = LineView()
        contentView.addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.left.right.equalTo(banner)
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(startDateView)
        startDateView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(banner)
            make.bottom.equalTo(banner.snp.top).offset(-10)
        }
        startDateView.backgroundColor = .parade
        startDateView.layer.cornerRadius = 3
        startDateView.layer.masksToBounds = true
        
        startDateView.addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        }
        startLabel.textColor = .white
        startLabel.font = .boldSystemFont(ofSize: 14)
        
        
        let line = LineView()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.right.equalTo(banner.snp.left).offset(-16)
            make.width.equalTo(1 / Screen.scale)
            make.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(statusIndicator)
        statusIndicator.snp.makeConstraints { (make) in
            make.centerY.equalTo(startDateView)
            make.height.width.equalTo(12)
            make.left.equalTo(banner.snp.left).offset(-22)
        }
             
        contentView.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = .black
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(startDateView.snp.right).offset(10)
            make.centerY.equalTo(startDateView)
            make.right.equalToSuperview()
        }
       
        startLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        startLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    func setup(pool: CGSSGacha) {
        startLabel.text = pool.startDate.toDate().toString(format: "yyyy-MM-dd")
        startDateView.backgroundColor = pool.gachaColor
        let now = Date()
        let start = pool.startDate.toDate()
        let end = pool.endDate.toDate()
        banner.sd_setImage(with: pool.detailBannerURL)
        if now >= start && now <= end {
            statusIndicator.style = .now
        } else if now < start {
            statusIndicator.style = .future
        } else if now > end {
            statusIndicator.style = .past
        }
        nameLabel.text = pool.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

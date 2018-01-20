//
//  GachaDetailBasicCell.swift
//  DereGuide
//
//  Created by zzk on 18/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class GachaDetailBasicCell: ReadableWidthTableViewCell {

    let nameLabel = UILabel()
    
    let detailLabel = UILabel()
    
    let ratioLabel = UILabel()
    
    let timeLabel = UILabel()
    
    let timeIndicator = TimeStatusIndicator()
    
    override var maxReadableWidth: CGFloat {
        return 824
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        readableContentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.lessThanOrEqualTo(-10)
        }
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.baselineAdjustment = .alignCenters
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        readableContentView.addSubview(ratioLabel)
        ratioLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        ratioLabel.font = UIFont.systemFont(ofSize: 12)
        ratioLabel.textAlignment = .left
        ratioLabel.textColor = .vocal
        
        readableContentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(ratioLabel.snp.bottom).offset(8)
        }
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.numberOfLines = 0
        detailLabel.textColor = .darkGray
        
        readableContentView.addSubview(timeIndicator)
        timeIndicator.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.height.width.equalTo(12)
            make.top.equalTo(detailLabel.snp.bottom).offset(6)
        }
        
        readableContentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeIndicator.snp.right).offset(10)
            make.centerY.equalTo(timeIndicator)
            make.right.lessThanOrEqualTo(-10)
            make.bottom.equalTo(-10)
        }
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.baselineAdjustment = .alignCenters
        timeLabel.textColor = .darkGray
        
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        ratioLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        detailLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        ratioLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        detailLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        selectionStyle = .none
        
    }
    
    func setup(pool: CGSSGacha) {
        nameLabel.text = pool.name
        ratioLabel.text = "SSR: \(Float(pool.ssrRatio) / 100)%   SR: \(Float(pool.srRatio) / 100)%   R: \(Float(pool.rareRatio) / 100)%"
        detailLabel.text = pool.dicription
        timeLabel.text = "\(pool.startDate.toDate().toString(format: "(zzz)yyyy-MM-dd HH:mm:ss", timeZone: TimeZone.current)) ~ \(pool.endDate.toDate().toString(timeZone: TimeZone.current))"
        
        let start = pool.startDate.toDate()
        let end = pool.endDate.toDate()
        let now = Date()
        if now >= start && now <= end {
            timeIndicator.style = .now
        } else if now < start {
            timeIndicator.style = .future
        } else if now > end {
            timeIndicator.style = .past
        }
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
}

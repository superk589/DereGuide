//
//  EventTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class EventTableViewCell: UITableViewCell {

    var banner: BannerView!
    var eventNameLabel: UILabel!
    var dateLabel: UILabel!
    var startDateView: UIView!
    var startLabel: UILabel!
    var endLabel: UILabel!
//    var songView: UIView!
//    var idolView: UIView!
    var statusIndicator: TimeStatusIndicator!
    
    static let estimatedHeight: CGFloat = (Screen.width - 33 - 32) * (212 / 824) + 53

    private let topSpace:CGFloat = 10
    private let leftSpace:CGFloat = 10
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        startDateView = UIView()
        contentView.addSubview(startDateView)
        startDateView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(32)
        }
        startDateView.backgroundColor = Color.parade
        startDateView.layer.cornerRadius = 3
        startDateView.layer.masksToBounds = true
        
        startLabel = UILabel()
        startDateView.addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 3))
        }
        startLabel.textColor = UIColor.white
        startLabel.font = UIFont.boldSystemFont(ofSize: 14)
        

        let line = LineView()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(1 / Screen.scale)
            make.top.bottom.equalToSuperview()
        }
        
        statusIndicator = TimeStatusIndicator()
        contentView.addSubview(statusIndicator)
        statusIndicator.snp.makeConstraints { (make) in
            make.centerY.equalTo(startDateView)
            make.height.width.equalTo(12)
            make.left.equalTo(10)
        }
        
        
        banner = BannerView()
        contentView.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.top.equalTo(startDateView.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
            make.right.equalToSuperview()
            // make.height.equalTo(banner.snp.width).multipliedBy(212 / 824)
        }
        // 宽高比snapkit有问题 用原生方法加
        banner.addConstraint(NSLayoutConstraint.init(item: banner, attribute: .height, relatedBy: .equal, toItem: banner, attribute: .width, multiplier: 212 / 824, constant: 1))
        
        eventNameLabel = UILabel()
        contentView.addSubview(eventNameLabel)
        eventNameLabel.font = UIFont.systemFont(ofSize: 14)
        eventNameLabel.textColor = UIColor.black
        eventNameLabel.adjustsFontSizeToFitWidth = true
        eventNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(startDateView.snp.right).offset(10)
            make.centerY.equalTo(startDateView)
            make.right.equalToSuperview()
        }
        // 两个Label同行, setContentHuggingPriority优先级高的可以避免拉伸
        // 同理setContentCompressionResistancePriority 优先级高的可以避免被缩小
        startLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        startLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        eventNameLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        eventNameLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
    }
    
    func setup(event:CGSSEvent) {
        startLabel.text = event.startDate.toDate().toString(format: "yyyy-MM-dd")
        startDateView.backgroundColor = event.eventColor
        let now = Date()
        let start = event.startDate.toDate()
        let end = event.endDate.toDate()
        if now >= start && now <= end {
            statusIndicator.style = .now
        } else if now < start {
            statusIndicator.style = .future
//            if let preStartDateString = event.preStartDate?.toString(format: "yyyy-MM-dd") {
//                startLabel.text = preStartDateString
//            }
        } else if now > end {
            statusIndicator.style = .past
        }
        banner.sd_setImage(with: event.detailBannerURL)
        eventNameLabel.text = event.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

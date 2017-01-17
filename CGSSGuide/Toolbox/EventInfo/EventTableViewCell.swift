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

    var banner:EventBannerView!
    var eventNameLabel: UILabel!
    var dateLabel: UILabel!
    var startLabel: UILabel!
    var endLabel: UILabel!
//    var songView: UIView!
//    var idolView: UIView!
    var statusIndicator: EventStatusIndicator!

    private let topSpace:CGFloat = 10
    private let leftSpace:CGFloat = 10
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        statusIndicator = EventStatusIndicator()
        contentView.addSubview(statusIndicator)
        statusIndicator.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(12)
            make.left.equalTo(10)
        }
        statusIndicator.isShiny = true

        banner = EventBannerView()
        contentView.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(46)
            make.width.equalTo(97)
        }
        
        eventNameLabel = UILabel()
        contentView.addSubview(eventNameLabel)
        eventNameLabel.font = UIFont.regular(size: 14)
        eventNameLabel.textColor = UIColor.black
        eventNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(banner.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(-10)
        }
        
//        startLabel = UILabel()
//        contentView.addSubview(startLabel)
//        startLabel.font = UIFont.regular(size: 12)
//        startLabel.textColor = UIColor.darkGray
//        startLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(eventNameLabel.snp.left)
//            make.top.equalTo(eventNameLabel.snp.bottom).offset(5)
//            make.right.lessThanOrEqualTo(-10)
//            make.height.equalTo(12)
//        }
//        
//        endLabel = UILabel()
//        contentView.addSubview(endLabel)
//        endLabel.font = UIFont.regular(size: 12)
//        endLabel.textColor = UIColor.darkGray
//        endLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(startLabel.snp.left)
//            make.top.equalTo(startLabel.snp.bottom).offset(3)
//            make.right.lessThanOrEqualTo(-10)
//            make.height.equalTo(12)
//        }
        
        self.accessoryType = .disclosureIndicator
        
        
//        let originX:CGFloat = 194 + 2 * leftSpace
//        let originY:CGFloat = 92 + 2 * topSpace
//        
//        statusIndicator = UIImageView.init(frame: CGRect(x: originX, y: originY, width: 12, height: 12))
//        statusIndicator.zy_cornerRadiusAdvance(6, rectCornerType: .allCorners)
        
//        eventNameLabel = UILabel.init(frame: CGRect.init(x: originX, y: originY, width: CGSSGlobal.width - originX - leftSpace, height: 17))
//        eventNameLabel.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    func setup(event:CGSSEvent) {
        let now = Date()
        let start = event.startDate.toDate()
        let end = event.endDate.toDate()
        if now >= start && now <= end {
            statusIndicator.shinyColor = UIColor.green.withAlphaComponent(0.6)
            banner.bannerId = event.sortId
        } else if now < start {
            statusIndicator.shinyColor = UIColor.orange.withAlphaComponent(0.6)
            banner.preBannerId = event.id
        } else if now > end {
            statusIndicator.shinyColor = UIColor.red.withAlphaComponent(0.6)
            banner.bannerId = event.sortId
        }
        // 顺序id为21的的活动没有图 特殊处理
        if event.sortId == 21 {
             banner.preBannerId = 2003
        }
//        // 前两次篷车活动特殊处理
//        if event.id == 2001 || event.id == 2002 {
//            banner.preBannerId = 2003
//        }
//        startLabel.text = NSLocalizedString("开始时间：", comment: "") + event.startDate
//        endLabel.text = NSLocalizedString("结束时间：", comment: "") + event.endDate
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

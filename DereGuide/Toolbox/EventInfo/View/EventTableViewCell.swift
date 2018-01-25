//
//  EventTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class EventTableViewCell: GachaTableViewCell {
    
    func setup(event: CGSSEvent) {
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
        nameLabel.text = event.name
    }
}

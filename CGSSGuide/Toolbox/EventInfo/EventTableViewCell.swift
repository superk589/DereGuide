//
//  EventTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit


class EventTableViewCell: UITableViewCell {

    var banner:EventBannerView!
//    var eventNameLabel: UILabel!
//    var startLabel: UILabel!
//    var endLabel: UILabel!
//    var songView: UIView!
//    var idolView: UIView!
    var statusIndicator: UIImageView!

    private let topSpace:CGFloat = 10
    private let leftSpace:CGFloat = 10
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        banner = EventBannerView(frame: CGRect.init(x: leftSpace, y: topSpace, width: 194, height: 92))
        self.contentView.addSubview(banner)
        self.accessoryType = .disclosureIndicator
        
//        let originX:CGFloat = 194 + 2 * leftSpace
//        let originY:CGFloat = 92 + 2 * topSpace
//        
//        statusIndicator = UIImageView.init(frame: CGRect(x: originX, y: originY, width: 12, height: 12))
//        statusIndicator.zy_cornerRadiusAdvance(6, rectCornerType: .allCorners)
        
//        eventNameLabel = UILabel.init(frame: CGRect.init(x: originX, y: originY, width: CGSSGlobal.width - originX - leftSpace, height: 17))
//        eventNameLabel.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    func setupWith(event:CGSSEvent, bannerId:Int) {
        banner.bannerId = bannerId
        
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

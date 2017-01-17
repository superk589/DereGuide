//
//  GachaTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/17.
//  Copyright © 2017年 zzk. All rights reserved.
//


import UIKit
import SnapKit

class GachaTableViewCell: UITableViewCell {
    
    var banner: GachaBannerView!
    var nameLabel: UILabel!
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
        
        banner = GachaBannerView()
        contentView.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(46)
            make.width.equalTo(97)
        }
        
        nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        nameLabel.font = UIFont.regular(size: 14)
        nameLabel.textColor = UIColor.black
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(banner.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(-10)
        }
        nameLabel.adjustsFontSizeToFitWidth = true
        
        self.accessoryType = .disclosureIndicator
    }
    
    func setup(pool: CGSSGachaPool) {
        
        let now = Date()
        let start = pool.startDate.toDate()
        let end = pool.endDate.toDate()
        banner.bannerId = pool.bannerId
        if now >= start && now <= end {
            statusIndicator.shinyColor = UIColor.green.withAlphaComponent(0.6)
        } else if now < start {
            statusIndicator.shinyColor = UIColor.orange.withAlphaComponent(0.6)
        } else if now > end {
            statusIndicator.shinyColor = UIColor.red.withAlphaComponent(0.6)
        }
        nameLabel.text = pool.name
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

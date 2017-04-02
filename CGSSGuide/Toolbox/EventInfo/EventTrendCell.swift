//
//  EventTrendCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/4/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import TTGTagCollectionView

class EventTrendCell: UITableViewCell, TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {

    var startLabel: UILabel!
    var startDateView: UIView!
    var statusIndicator: TimeStatusIndicator!

    var arrow: UIImageView!
    var collectionView: TTGTagCollectionView!
    
    var tagViews = [BannerView]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
    
        statusIndicator = TimeStatusIndicator()
        contentView.addSubview(statusIndicator)
        statusIndicator.snp.makeConstraints { (make) in
            make.centerY.equalTo(startDateView)
            make.height.width.equalTo(12)
            make.left.equalTo(10)
        }
        
        arrow = UIImageView()
        contentView.addSubview(arrow)
        arrow.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.right.equalTo(-10)
            make.centerY.equalTo(startDateView)
        }
        arrow.tintColor = UIColor.lightGray
        arrow.contentMode = .scaleAspectFit
        arrow.image = #imageLiteral(resourceName: "764-arrow-down-toolbar-selected").withRenderingMode(.alwaysTemplate)
        
        collectionView = TTGTagCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(startDateView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        collectionView.alignment = .center
        
        selectionStyle = .none
        clipsToBounds = true
    }
    
    func setup(with trend: EventTrend) {
        startLabel.text = trend.startDate.toDate().toString(format: "yyyy-MM-dd")
        startDateView.backgroundColor = Color.parade
        let now = Date()
        let start = trend.startDate.toDate()
        let end = trend.endDate.toDate()
        if now >= start && now <= end {
            statusIndicator.style = .now
        } else if now < start {
            statusIndicator.style = .future
        } else if now > end {
            statusIndicator.style = .past
        }
        tagViews.removeAll()
        for live in trend.lives {
            let jacketView = BannerView.init(frame: CGRect.init(x: 0, y: 0, width: 66, height: 66))
            tagViews.append(jacketView)
            if let url = live.jacketURL {
                jacketView.sd_setImage(with: url)
            }
        }
        collectionView.reload()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: { [weak self] in
            if selected {
                self?.arrow.transform = CGAffineTransform.init(rotationAngle: .pi)
            } else {
                self?.arrow.transform = .identity
            }
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(tagViews.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        return tagViews[Int(index)]
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        
        return CGSize.init(width: 66, height: 66)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, updateContentSize contentSize: CGSize) {
        
    }
    
}

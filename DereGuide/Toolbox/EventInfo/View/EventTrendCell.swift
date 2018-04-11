//
//  EventTrendCell.swift
//  DereGuide
//
//  Created by zzk on 2017/4/2.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit
import TTGTagCollectionView

protocol EventTrendCellDelegate: class {
    func eventTrendCell(_ eventTrendCell: EventTrendCell, didSelect live: CGSSLive, banner: BannerView)
}

class EventTrendCell: UITableViewCell, TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {

    let startLabel = UILabel()
    let startDateView = UIView()
    let statusIndicator = TimeStatusIndicator()

    let arrow = UIImageView()
    let collectionView = TTGTagCollectionView()
    
    var trend: EventTrend? {
        didSet {
            needToReload = true
        }
    }
    
    weak var delegate: EventTrendCellDelegate?
    
    private var needToReload = false
    
    var tagViewsCache = NSCache<NSNumber, UIView>()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(startDateView)
        startDateView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(32)
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
        
        contentView.addSubview(statusIndicator)
        statusIndicator.snp.makeConstraints { (make) in
            make.centerY.equalTo(startDateView)
            make.height.width.equalTo(12)
            make.left.equalTo(10)
        }
        
        contentView.addSubview(arrow)
        arrow.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.right.equalTo(-10)
            make.centerY.equalTo(startDateView)
        }
        arrow.tintColor = .lightGray
        arrow.contentMode = .scaleAspectFit
        arrow.image = #imageLiteral(resourceName: "764-arrow-down-toolbar-selected").withRenderingMode(.alwaysTemplate)
        
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
        startDateView.backgroundColor = .parade
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
        self.trend = trend
        setArrowSelected(isSelected, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            reloadIfNeeded()
        }
    }
    
    var indexPath: IndexPath?
    
     func reloadIfNeeded() {
        if needToReload {
            collectionView.reload()
            needToReload = false
        }
    }
    
    func setArrowSelected(_ selected: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState], animations: { [weak self] in
                if selected {
                    self?.arrow.transform = CGAffineTransform(rotationAngle: .pi)
                } else {
                    self?.arrow.transform = .identity
                }
            }, completion: nil)
        } else {
            if selected {
                arrow.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                arrow.transform = .identity
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func dequeueFromCachedTags(for index: UInt) -> UIView? {
        return tagViewsCache.object(forKey: NSNumber(value: index))
    }
    
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return isSelected ? UInt(trend?.lives.count ?? 0) : 0
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        
        let tagView = dequeueFromCachedTags(for: index) as? BannerView ?? BannerView.init(frame: CGRect(x: 0, y: 0, width: 132, height: 132))
        
        if let url = trend?.lives[Int(index)].jacketURL {
            tagView.sd_setImage(with: url)
        }
        
        tagViewsCache.setObject(tagView, forKey: NSNumber(value: index))
        return tagView
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        return CGSize.init(width: 132, height: 132)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
        if let live = trend?.lives[Int(index)], let banner = tagView as? BannerView {
            delegate?.eventTrendCell(self, didSelect: live, banner: banner)
        }
    }

}

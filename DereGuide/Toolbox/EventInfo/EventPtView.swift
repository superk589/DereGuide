//
//  EventPtView.swift
//  DereGuide
//
//  Created by zzk on 2017/1/24.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit


protocol EventPtViewDelegate: class {
    func refresh(eventPtView: EventPtView)
}

class EventPtView: UIView {

    var dateLabel: UILabel!
    var refreshButton: UIButton!
    
    var gridView: GridLabel!
    
    var loadingHUD: LoadingImageView!
    
    weak var delegate: EventPtViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let dateDescLabel = UILabel()
        addSubview(dateDescLabel)
        dateDescLabel.text = NSLocalizedString("最后更新时间：", comment: "")
        dateDescLabel.textColor = UIColor.darkGray
        dateDescLabel.font = UIFont.systemFont(ofSize: 12)
        dateDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(8)
        }
        
        dateLabel = UILabel()
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateDescLabel.snp.right).offset(5)
            make.top.equalTo(dateDescLabel)
        }
        dateLabel.textColor = UIColor.darkGray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        
        refreshButton = UIButton()
        addSubview(refreshButton)
        refreshButton.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right).offset(10)
            make.height.width.equalTo(18)
            make.centerY.equalTo(dateDescLabel)
        }
        refreshButton.setImage(#imageLiteral(resourceName: "759-refresh-2-toolbar").withRenderingMode(.alwaysTemplate), for: .normal)
        refreshButton.tintColor = Color.parade
        refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        
        gridView = GridLabel.init(rows: 7, columns: 3)
        addSubview(gridView)
        gridView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(dateDescLabel.snp.bottom).offset(10)
        }
        
        loadingHUD = LoadingImageView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        
        setLoading(loading: true)
    }
    
    private var _isLoading: Bool = true
    var isLoading: Bool {
        set {
            setLoading(loading: newValue)
        }
        get {
            return _isLoading
        }
    }
    
    func setLoading(loading: Bool) {
        _isLoading = loading
        if loading {
            loadingHUD.show(to: self)
            gridView.isHidden = true
            refreshButton.isEnabled = false
        } else {
            loadingHUD.stopAnimating()
            gridView.isHidden = false
            refreshButton.isEnabled = true
        }
    }
    
    @objc func refreshAction() {
        if !isLoading {
            delegate?.refresh(eventPtView: self)
            setLoading(loading: true)
        }
    }
    
    
    func setup(rankingList: EventPtRanking, onGoing: Bool) {
        dateLabel.text = rankingList.lastDate?.toString(format: "(zzz)yyyy-MM-dd HH:mm", timeZone: TimeZone.current)
        setLoading(loading: false)
        if let last = rankingList.last {
            gridView.isHidden = false
            var gridStrings = [[String]]()
            if onGoing {
                gridStrings.append(["", NSLocalizedString("当前Pt", comment: ""), NSLocalizedString("增速(/h)", comment: "")])
                gridStrings.append(["1", String(last.rank1), "\(Int(rankingList.speed.rank1))"])
                gridStrings.append([rankingList.event.rankingPtLabels[0], String(last.reward1), "\(rankingList.speed.reward1)"])
                gridStrings.append([rankingList.event.rankingPtLabels[1], String(last.reward2), "\(rankingList.speed.reward2)"])
                gridStrings.append([rankingList.event.rankingPtLabels[2], String(last.reward3), "\(rankingList.speed.reward3)"])
                gridStrings.append([rankingList.event.rankingPtLabels[3], String(last.reward4), "\(rankingList.speed.reward4)"])
                gridStrings.append([rankingList.event.rankingPtLabels[4], String(last.reward5), "\(rankingList.speed.reward5)"])
            } else {
                gridStrings.append(["", NSLocalizedString("最终Pt", comment: ""), "-"])
                gridStrings.append(["1", String(last.rank1), "-"])
                gridStrings.append([rankingList.event.rankingPtLabels[0], String(last.reward1), "-"])
                gridStrings.append([rankingList.event.rankingPtLabels[1], String(last.reward2), "-"])
                gridStrings.append([rankingList.event.rankingPtLabels[2], String(last.reward3), "-"])
                gridStrings.append([rankingList.event.rankingPtLabels[3], String(last.reward4), "-"])
                gridStrings.append([rankingList.event.rankingPtLabels[4], String(last.reward5), "-"])
            }
            gridView.setContents(gridStrings)
        } else {
            gridView.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  LoadingMoreTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/8/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol LoadMoreTableViewCellDelegate: class {
    func didLoadMore(_ loadMoreTableViewCell: LoadMoreTableViewCell)
}

class LoadMoreTableViewCell: UITableViewCell {

    var loadMoreButton: WideLoadingButton!
    
    var noMoreLabel: UILabel!
    
    weak var delegate: LoadMoreTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        loadMoreButton = WideLoadingButton()
        contentView.addSubview(loadMoreButton)
        loadMoreButton.setup(normalTitle: NSLocalizedString("加载更多", comment: ""), loadingTitle: NSLocalizedString("正在加载...", comment: ""))
        loadMoreButton.backgroundColor = Color.dance
        loadMoreButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.equalTo(10)
            make.width.equalTo(160)
        }
        
        loadMoreButton.addTarget(self, action: #selector(handleLoadMoreButton(_:)), for: .touchUpInside)
        
        noMoreLabel = UILabel()
        noMoreLabel.text = NSLocalizedString("没有更多数据了", comment: "")
        noMoreLabel.textColor = UIColor.lightGray
        noMoreLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(noMoreLabel)
        noMoreLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        noMoreLabel.isHidden = true
        loadMoreButton.isHidden = true
        
        selectionStyle = .none
    }
    
    func setNoMoreData(_ isNoMore: Bool) {
        loadMoreButton.isHidden = isNoMore
        noMoreLabel.isHidden = !isNoMore
    }
    
    @objc func handleLoadMoreButton(_ button: UIButton) {
        delegate?.didLoadMore(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

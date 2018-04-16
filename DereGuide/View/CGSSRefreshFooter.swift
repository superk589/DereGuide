//
//  CGSSRefreshFooter.swift
//  DereGuide
//
//  Created by zzk on 11/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import MJRefresh

class CGSSRefreshFooter: MJRefreshAutoFooter {
    
    var loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var stateLabel = UILabel()
    
    var centerOffset: CGFloat = 0
    
    private let noMoreString = NSLocalizedString("没有更多数据了", comment: "")
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                stateLabel.text = nil
                loadingView.isHidden = true
                loadingView.stopAnimating()
            case .refreshing:
                stateLabel.text = nil
                loadingView.isHidden = false
                loadingView.startAnimating()
            case .noMoreData:
                stateLabel.text = noMoreString
                loadingView.isHidden = true
                loadingView.stopAnimating()
            default:
                break
            }
        }
    }

    override func prepare() {
        super.prepare()
        
        frame.size.height = 50
        
        addSubview(loadingView)
        
        stateLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        stateLabel.textAlignment = .center
        stateLabel.font = UIFont.systemFont(ofSize: 16)
        stateLabel.textColor = .gray
        addSubview(stateLabel)
    }
    
    override func placeSubviews(){
        super.placeSubviews()
        loadingView.center = CGPoint(x: frame.width / 2, y: frame.height / 2 + centerOffset)
        stateLabel.center = CGPoint(x: frame.width / 2, y: frame.height / 2  + centerOffset)
    }
    
}

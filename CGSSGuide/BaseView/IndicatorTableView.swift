//
//  IndicatorTableView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/3.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class TableViewScrollViewIndicator: ScrollViewIndicator {
    
    override var offsetRatio: CGFloat {
        if let tableView = self.scrollView as? UITableView {
            let indicatorScrollabelHeight = tableView.bounds.height - tableView.contentInset.top - tableView.contentInset.bottom - bounds.maxY - tableView.sectionFooterHeight - tableView.sectionHeaderHeight
            let totalHeight = tableView.contentSize.height - tableView.bounds.height + tableView.contentInset.top + tableView.contentInset.bottom
            return indicatorScrollabelHeight / totalHeight
        }
        return 1
    }
    
    override var maxOffsetY: CGFloat {
        if let tableView = self.scrollView as? UITableView {
            return tableView.contentOffset.y + tableView.bounds.height - tableView.contentInset.bottom - bounds.midY - tableView.sectionFooterHeight
        }
        return 0
    }
    
    override var minOffsetY: CGFloat {
        if let tableView = self.scrollView as? UITableView {
            return tableView.contentOffset.y + tableView.contentInset.top + bounds.midY + tableView.sectionHeaderHeight
        }
        return 0
    }
    
    
    override func adjustFrameInScrollView() {
        if let tableView = self.scrollView as? UITableView {
            center.x = tableView.bounds.maxX - bounds.midY - 1
            center.y = max(min((tableView.contentInset.top + tableView.contentOffset.y) * (1 + offsetRatio) + tableView.sectionHeaderHeight + bounds.midY, maxOffsetY), minOffsetY)
        }
    }
    
    override func adjustScrollView() {
        if let tableView = scrollView as? UITableView {
            let offsetY = frame.minY - tableView.contentInset.top - tableView.contentOffset.y - tableView.sectionHeaderHeight
            tableView.contentOffset.y = offsetY / offsetRatio - tableView.contentInset.top
        }
    }

}

class IndicatorTableView: UITableView {

    var indicator = TableViewScrollViewIndicator(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
    
    lazy var debouncer: Debouncer = {
        return Debouncer.init(interval: 3, callback: { [weak self] in
            if self?.indicator.panGesture.state == .possible {
                self?.indicator.hide()
            } else {
                self?.debouncer.call()
            }
        })
    }()
    
    override var contentOffset: CGPoint {
        set {
            super.contentOffset = newValue
            debouncer.call()
            indicator.adjustFrameInScrollView()
        }
        get {
            return super.contentOffset
        }
    }
    
    func handlePanGestureInside(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            indicator.show(to: self)
        }
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        showsVerticalScrollIndicator = false
        delaysContentTouches = false
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGestureInside(_:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

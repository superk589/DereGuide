//
//  GridView.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class GridView: UIStackView {

    var rows: Int = 0
    var columns: Int = 0
    
    subscript (r: Int, c: Int) -> UIView {
        get {
            return (arrangedSubviews[r] as! UIStackView).arrangedSubviews[c]
        }
    }
    
    convenience init(rows: Int, columns: Int, views: [[UIView]]) {
        var stackViews = [UIStackView]()
        
        for r in 0..<rows {
            let rowViews = views[r]
            let stackView = UIStackView(arrangedSubviews: rowViews)
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            stackView.spacing = -1 / CGSSGlobal.scale
            stackViews.append(stackView)
        }
        self.init(arrangedSubviews: stackViews)
        self.rows = rows
        self.columns = columns
        spacing = -1 / CGSSGlobal.scale
        distribution = .fillEqually
        axis = .vertical
    }
    
    override var distribution: UIStackView.Distribution {
        set {
            super.distribution = newValue
            for stackView in arrangedSubviews {
                if let stackView = stackView as? UIStackView {
                    stackView.distribution = newValue
                }
            }
        }
        get {
            return super.distribution
        }
    }
}

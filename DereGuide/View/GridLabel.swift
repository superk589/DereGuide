//
//  GridLabel.swift
//  DereGuide
//
//  Created by zzk on 2017/5/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class GridLabel: GridView {
    
    override subscript (r: Int, c: Int) -> UILabel {
        get {
            return (arrangedSubviews[r] as! UIStackView).arrangedSubviews[c].subviews.first as! UILabel
        }
    }

    var numberOfLines: Int = 0 {
        didSet {
            for r in 0..<rows {
                for c in 0..<columns {
                    self[r, c].numberOfLines = numberOfLines
                }
            }
        }
    }
    
    convenience init(rows: Int, columns: Int, textAligment: NSTextAlignment = .center) {
        
        var views = [[UIView]]()
        
        for _ in 0..<rows {
            var subViews = [UIView]()
            for _ in 0..<columns {
                let label = UILabel()
                label.textAlignment = textAligment
                label.font = UIFont.init(name: "menlo", size: 14)
                label.adjustsFontSizeToFitWidth = true
                label.textColor = Color.allType
                label.baselineAdjustment = .alignCenters
                let view = UIView()
                view.layer.borderColor = UIColor.black.cgColor
                view.layer.borderWidth = 1 / UIScreen.main.scale
                view.addSubview(label)
                label.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 1, left: 2, bottom: 1, right: 2))
                })
                subViews.append(view)
            }
            views.append(subViews)
        }
        
        self.init(rows: rows, columns: columns, views: views)
    }
    
    func setContents(_ contents: [[String]]) {
        for i in 0...columns - 1 {
            for j in 0...rows - 1 {
                if let text = contents[safe: j]?[safe: i] {
                    self[j, i].text = text
                }
            }
        }
    }
    
    func setColors(_ colors: [[UIColor]]) {
        for i in 0...columns - 1 {
            for j in 0...rows - 1 {
                if let color = colors[safe: j]?[safe: i] {
                    self[j, i].textColor = color
                }
            }
        }
    }
    
    func setFonts(_ fonts: [[UIFont]]) {
        for i in 0...columns - 1 {
            for j in 0...rows - 1 {
                if let font = fonts[safe: j]?[safe: i] {
                    self[j, i].font = font
                }
            }
        }
    }
}

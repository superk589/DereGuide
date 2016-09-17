//
//  CGSSGridLabel.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/12.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

private class Label: UILabel {
    private override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsetsMake(1, 2, 1, 2)
        super.drawText(in:UIEdgeInsetsInsetRect(rect, inset))
    }
}

class CGSSGridLabel: CGSSGridView {
    
    override subscript (r: Int, c: Int) -> UILabel {
        get {
            return grid[r * columns + c] as! UILabel
        }
    }

    
    init(frame: CGRect, rows: Int, columns: Int, textAligment: NSTextAlignment = .center) {
        
        var views = [Label]()
        for _ in 0...rows * columns - 1 {
            let view = Label()
            view.textAlignment = textAligment
            // view.font = UIFont.systemFontOfSize(gridHeight-2)
            view.numberOfLines = 0
            view.font = UIFont.init(name: "menlo", size: 14)
            view.adjustsFontSizeToFitWidth = true
            view.textColor = CGSSGlobal.allTypeColor
            views.append(view)
        }
        
        super.init(frame: frame, rows: rows, columns: columns, views: views)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGridContent(_ content: [[String]]) {
        for i in 0...columns - 1 {
            for j in 0...rows - 1 {
                self[j, i].text = content[j][i]
            }
        }
    }
    
    func setGridColor(_ content: [[UIColor]]) {
        for i in 0...columns - 1 {
            for j in 0...rows - 1 {
                self[j, i].textColor = content[j][i]
            }
        }
    }
    
    func setGridFont(_ content: [[UIFont]]) {
        for i in 0...columns - 1 {
            for j in 0...rows - 1 {
                self[j, i].font = content[j][i]
            }
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}

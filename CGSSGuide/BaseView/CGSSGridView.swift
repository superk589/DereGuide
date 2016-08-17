//
//  CGSSGridView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSGridView: UIView {
    
    var rows: Int
    var columns: Int
    // var borderPixels:CGFloat?
    var grid: [UIView]
    
    subscript (r: Int, c: Int) -> UIView {
        get {
            return grid[r * columns + c]
        }
    }
    
    init(frame: CGRect, rows: Int, columns: Int, views: [UIView]) {
        self.rows = rows
        self.columns = columns
        self.grid = views
        let borderWidth = 1 / UIScreen.mainScreen().scale
        let gridWidth = frame.width / CGFloat(columns)
        let gridHeight = frame.height / CGFloat(rows)
        
        super.init(frame: frame)
        
        for i in 0...rows * columns - 1 {
            let view = views[i]
            view.frame = CGRectMake(CGFloat(i % columns) * gridWidth, CGFloat(i / columns) * gridHeight, gridWidth + borderWidth, gridHeight + borderWidth)
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = UIColor.blackColor().CGColor
            self.addSubview(view)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}

//
//  CGSSGridView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSGridView: UIView {

    var rows:Int
    var columns:Int
    //var borderPixels:CGFloat?
    var grid:[UILabel]
    
    subscript (r:Int, c:Int) -> UILabel {
        get {
            return grid[r*columns+c]
        }
    }
    
    init(frame: CGRect, rows:Int, columns:Int, textAligment:NSTextAlignment = .Center) {
        self.rows = rows
        self.columns = columns
        self.grid = [UILabel]()
        super.init(frame: frame)
        
        //self.borderPixels = 1
        let borderWidth = 1 / UIScreen.mainScreen().scale
        let gridWidth = frame.width / CGFloat(columns) //+ borderWidth * (CGFloat(columns) - 1)
        let gridHeight = frame.height / CGFloat(rows) //+ borderWidth * (CGFloat(rows) - 1)
        
        for i in 0...rows*columns - 1 {
            let view = UILabel()
            

            view.frame = CGRectMake(CGFloat(i%columns)*gridWidth, CGFloat(i/columns)*gridHeight, gridWidth+borderWidth, gridHeight+borderWidth)
            
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = UIColor.blackColor().CGColor
            
            view.textAlignment = textAligment
            //view.font = UIFont.systemFontOfSize(gridHeight-2)
            view.numberOfLines = 0
            view.font = UIFont.init(name: "menlo", size: gridHeight-2)
            view.adjustsFontSizeToFitWidth = true

            self.grid.append(view)
            self.addSubview(view)
        }
    }
    
    func setGridContent(content:[[String]]) {
        for i in 0...columns - 1 {
            for j in 0...rows - 1 {
                self[j,i].text = content[j][i]
            }
        }
    }
    
    func setGridColor(content:[[UIColor]]) {
        for i in 0...columns - 1 {
            for j in 0...rows - 1 {
                self[j,i].textColor = content[j][i]
            }
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

//
//  CGSSCheckBoxV.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSCheckBox: UIView {

    var checkBox: UIImageView!
    var descLabel: UILabel!
    var isChecked = false {
        didSet {
            if isChecked {
                check()
            } else {
                uncheck()
            }
        }
    }
    var text:String? {
        set {
            self.descLabel.text = newValue
        }
        get {
            return self.descLabel.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        checkBox = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.fheight, height: self.fheight))
        descLabel = UILabel.init(frame: CGRect(x: self.fheight + 5, y: 0, width: self.fwidth - fheight, height: self.fheight))
        descLabel.adjustsFontSizeToFitWidth = true
        addSubview(checkBox)
        addSubview(descLabel)
    }
    
    func check() {
        checkBox.image = UIImage.init(named: "888-checkmark-toolbar-selected")?.withRenderingMode(.alwaysTemplate)
    }
    func uncheck() {
        checkBox.image = UIImage.init(named: "888-checkmark-toolbar")?.withRenderingMode(.alwaysTemplate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

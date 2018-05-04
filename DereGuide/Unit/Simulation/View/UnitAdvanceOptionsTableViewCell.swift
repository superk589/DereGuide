//
//  UnitAdvanceOptionsTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/3.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

class UnitAdvanceOptionsTableViewCell: UITableViewCell {

    enum OptionStyle {
        case slider(SliderOption)
        case textField(TextFieldOption)
        case `switch`(SwitchOption)
        case stepper(StepperOption)
        case segmented(SegmentedOption)
        case plain
        
        var view: UIView? {
            switch self {
            case .`switch`(let view):
                return view
            case .textField(let view):
                return view
            case .slider(let view):
                return view
            case .stepper(let view):
                return view
            case .segmented(let view):
                return view
            default:
                return nil
            }
        }
    }
    
    var optionView: UIView!
    
    private(set) var optionStyle: OptionStyle = .plain
    
    convenience init(optionStyle: OptionStyle) {
        self.init()
        self.optionStyle = optionStyle
        
        if let view = optionStyle.view {
            optionView = view
            contentView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.bottom.equalTo(-10)
                make.left.right.equalTo(readableContentGuide)
            }
        }
        
        selectionStyle = .none
    }
    
}

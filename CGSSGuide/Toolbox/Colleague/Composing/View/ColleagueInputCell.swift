//
//  ColleagueInputCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol ColleagueInputCellDelegate: class {
    func colleagueInputCell(_ cell: ColleagueInputCell, didChange text: String)
}

class ColleagueInputTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autocorrectionType = .no
        autocapitalizationType = .none
        textAlignment = .right
        font = UIFont.systemFont(ofSize: 14)
        returnKeyType = .done
        contentVerticalAlignment = .center
        layer.cornerRadius = 4
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1 / Screen.scale
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColleagueInputCell: ColleagueBaseCell {

    var input: ColleagueInputTextField
    
    var isValid: Bool {
        if let pattern = checkPattern {
            if input.text?.match(pattern: pattern).count == 1 {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    var checkPattern: String?
    
    weak var delegate: ColleagueInputCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        input = ColleagueInputTextField()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.snp.remakeConstraints { (remake) in
            remake.centerY.equalToSuperview()
            remake.left.equalTo(10)
        }
        
        contentView.addSubview(input)
        input.font = UIFont.systemFont(ofSize: 16)
        input.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftLabel)
            make.width.equalTo(self.contentView.snp.width).dividedBy(2).offset(-20)
            make.right.equalTo(-10)
            make.height.greaterThanOrEqualTo(30)
        }
        input.addTarget(self, action: #selector(didEndEditing), for: .editingDidEndOnExit)
        input.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
    }
    
    @objc func didEndEditing() {
        delegate?.colleagueInputCell(self, didChange: input.text ?? "")
        if isValid {
            input.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            input.layer.borderColor = UIColor.red.lighter().cgColor
        }
    }
    
    func setup(with text: String, keyboardType: UIKeyboardType) {
        input.text = text
        input.keyboardType = keyboardType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

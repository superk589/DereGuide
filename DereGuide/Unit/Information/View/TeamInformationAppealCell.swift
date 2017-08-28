//
//  TeamInformationAppealCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/20.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit


protocol TeamInformationAppealCellDelegate: class {
    func teamInformationAppealCell(_ teamInformationAppealCell: TeamInformationAppealCell, didUpdate supportAppeal: Int)
    
    func teamInformationAppealCell(_ teamInformationAppealCell: TeamInformationAppealCell, beginEdit textField: UITextField)
}

extension TeamInformationAppealCellDelegate {
    func teamInformationAppealCell(_ teamInformationAppealCell: TeamInformationAppealCell, beginEdit textField: UITextField) {
        
    }
}

class TeamInformationAppealCell: UITableViewCell {
    
    var leftLabel: UILabel!
    
    var descriptionLabel: UILabel!
    
    var supportLabel: UILabel!
    
    var supportAppealLabel: UILabel!
    
    var supportAppealTextField: UITextField!
    
    var appealGrid: GridLabel!
    
    weak var delegate: TeamInformationAppealCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel = UILabel()
        leftLabel.text = NSLocalizedString("表现值", comment: "队伍详情页面") + ": "
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.textAlignment = .left
        
        
//        supportLabel = UILabel()
//        supportLabel.font = UIFont.systemFont(ofSize: 14)
//        // backSupportLabel.textColor = UIColor.lightGrayColor()
//        supportLabel.text = NSLocalizedString("后援数值", comment: "队伍详情页面") + ": "
//        supportLabel.textColor = UIColor.darkGray
//        supportLabel.adjustsFontSizeToFitWidth = true
        
//        supportAppealTextField = TeamSimulationAppealInputTextField()
//        supportAppealTextField.addTarget(self, action: #selector(beginEditAppealTextField(sender:)), for: .editingDidBegin)
//        supportAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEnd)
//        supportAppealTextField.addTarget(self, action: #selector(endEditAppeal), for: .editingDidEndOnExit)
//
//        supportAppealLabel = UILabel()
//        supportAppealLabel.font = UIFont.systemFont(ofSize: 14)
//        supportAppealLabel.textColor = UIColor.darkGray
       
        appealGrid = GridLabel.init(rows: 5, columns: 5)
        
        contentView.addSubview(leftLabel)
//        contentView.addSubview(supportLabel)
//        contentView.addSubview(supportAppealLabel)
        contentView.addSubview(appealGrid)
        
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
        }
        
//        supportAppealTextField.snp.makeConstraints { (make) in
//            make.right.equalTo(-10)
//            make.top.equalTo(leftLabel.snp.bottom).offset(5)
//            make.width.equalTo(contentView.snp.width).dividedBy(2).offset(-20)
//            make.height.greaterThanOrEqualTo(24)
//        }
        
//        supportAppealLabel.snp.makeConstraints { (make) in
//            make.right.equalTo(-10)
//            make.top.equalTo(leftLabel.snp.bottom).offset(5)
//        }
//
//        supportLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(10)
//            make.centerY.equalTo(supportAppealLabel)
//            make.right.lessThanOrEqualTo(supportAppealLabel.snp.left)
//        }
        
        appealGrid.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.right.equalTo(-10)
        }
        
        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = NSLocalizedString("* 不含后援值，歌曲模式为常规模式", comment: "")
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(appealGrid.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
            make.left.equalTo(10)
            make.right.lessThanOrEqualTo(-10)
        }
        
        selectionStyle = .none
    }
    
    func beginEditAppealTextField(sender: UITextField) {
        delegate?.teamInformationAppealCell(self, beginEdit: sender)
    }
    
    private func validteInputResult() {
        let value1 = Int(supportAppealTextField.text ?? "")
        if value1 == nil {
            supportAppealTextField.text = String(CGSSGlobal.defaultSupportAppeal)
        }
    }
    
    func endEditAppeal() {
        validteInputResult()
        delegate?.teamInformationAppealCell(self, didUpdate: Int(supportAppealTextField.text ?? "") ?? 0)
    }
    
    func setup(with unit: Unit) {
//        supportAppealLabel.text = "\(team.supportAppeal!)"
        
        var appealStrings = [[String]]()
        var presentColor = [[UIColor]]()
        
        appealStrings.append([" ", "Total", "Vocal", "Dance", "Visual"])
        var presentSub1 = [NSLocalizedString("彩色曲", comment: "队伍详情页面")]
        presentSub1.append(contentsOf: unit.getAppealBy(simulatorType: .normal, liveType: .allType).toStringArrayWithBackValue(0))
        var presentSub2 = [NSLocalizedString("Cu曲", comment: "队伍详情页面")]
        presentSub2.append(contentsOf: unit.getAppealBy(simulatorType: .normal, liveType: .cute).toStringArrayWithBackValue(0))
        var presentSub3 = [NSLocalizedString("Co曲", comment: "队伍详情页面")]
        presentSub3.append(contentsOf: unit.getAppealBy(simulatorType: .normal, liveType: .cool).toStringArrayWithBackValue(0))
        var presentSub4 = [NSLocalizedString("Pa曲", comment: "队伍详情页面")]
        presentSub4.append(contentsOf: unit.getAppealBy(simulatorType: .normal, liveType: .passion).toStringArrayWithBackValue(0))
        
        appealStrings.append(presentSub1)
        appealStrings.append(presentSub2)
        appealStrings.append(presentSub3)
        appealStrings.append(presentSub4)
        
        let colorArray2 = [UIColor.darkGray, Color.allType, Color.vocal, Color.dance, Color.visual]
        presentColor.append(contentsOf: Array.init(repeating: colorArray2, count: 5))
        presentColor[2][0] = Color.cute
        presentColor[3][0] = Color.cool
        presentColor[4][0] = Color.passion
        
        appealGrid.setContents(appealStrings)
        appealGrid.setColors(presentColor)
        
        for i in 0..<5 {
            appealGrid[0, i].font = CGSSGlobal.alphabetFont
        }
        for i in 0..<5 {
            appealGrid[i, 0].font = CGSSGlobal.alphabetFont
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

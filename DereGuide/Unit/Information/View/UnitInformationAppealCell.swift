//
//  UnitInformationAppealCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/20.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit


protocol UnitInformationAppealCellDelegate: class {
    func unitInformationAppealCell(_ unitInformationAppealCell: UnitInformationAppealCell, didUpdate supportAppeal: Int)
    func unitInformationAppealCell(_ unitInformationAppealCell: UnitInformationAppealCell, beginEdit textField: UITextField)
}

extension UnitInformationAppealCellDelegate {
    func unitInformationAppealCell(_ unitInformationAppealCell: UnitInformationAppealCell, beginEdit textField: UITextField) {
        
    }
}

class UnitInformationAppealCell: UITableViewCell {
    
    let leftLabel = UILabel()
    
    let descriptionLabel = UILabel()
    
    let supportLabel = UILabel()
    
    let supportAppealLabel = UILabel()
    
    let supportAppealTextField = UITextField()
    
    let appealGrid = GridLabel(rows: 5, columns: 5)
    
    weak var delegate: UnitInformationAppealCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel.text = NSLocalizedString("表现值", comment: "队伍详情页面")
        leftLabel.font = .systemFont(ofSize: 16)
        leftLabel.textAlignment = .left
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(appealGrid)
        
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
        }
        
        appealGrid.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.right.equalTo(-10)
        }
        
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = .systemFont(ofSize: 14)
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
        delegate?.unitInformationAppealCell(self, beginEdit: sender)
    }
    
    private func validteInputResult() {
        let value1 = Int(supportAppealTextField.text ?? "")
        if value1 == nil {
            supportAppealTextField.text = String(Config.maximumSupportAppeal)
        }
    }
    
    func endEditAppeal() {
        validteInputResult()
        delegate?.unitInformationAppealCell(self, didUpdate: Int(supportAppealTextField.text ?? "") ?? 0)
    }
    
    func setup(with unit: Unit) {        
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
        
        let colorArray2 = [UIColor.darkGray, .allType, .vocal, .dance, .visual]
        presentColor.append(contentsOf: Array(repeating: colorArray2, count: 5))
        presentColor[2][0] = .cute
        presentColor[3][0] = .cool
        presentColor[4][0] = .passion
        
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

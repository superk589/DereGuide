//
//  UnitSimulationMainBodyCell.swift
//  DereGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol UnitSimulationMainBodyCellDelegate: class {
    func startCalculate(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell)
    func startSimulate(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell)
    func cancelSimulating(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell)
    func startAfkModeSimulating(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell)
    func cancelAfkModeSimulating(_ unitSimulationMainBodyCell: UnitSimulationMainBodyCell)
}

class UnitSimulationMainBodyCell: UITableViewCell {
    
    var calculationButton: UIButton!
    
    var calculationGrid: GridLabel!
    
    var simulationButton: UIButton!
    
    var cancelButton: UIButton!
    
    var simulationGrid: GridLabel!
    
    var simulatingIndicator: UIActivityIndicatorView!
    
    var cancelButtonWidthConstraint: Constraint!
    
    var cancelButtonLeftConstraint: Constraint!
    
    let afkModeButton = WideButton()
    
    let afkModeCancelButton = WideButton()
    
    let afkModeIndicator = UIActivityIndicatorView(style: .white)
    
    let afkModeGrid = GridLabel(rows: 2, columns: 3)
    
    var afkModeCancelButtonLeftConstraint: Constraint!
    
    var afkModeCancelButtonWidthConstraint: Constraint!
    
//    var scoreDistributionButton: UIButton!
//    
//    var scoreDetailButton: UIButton!
//    
//    var supportSkillDetailButton: UIButton!
    
    weak var delegate: UnitSimulationMainBodyCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        calculationButton = WideButton()
        calculationButton.setTitle(NSLocalizedString("一般计算", comment: "队伍详情页面"), for: .normal)
        calculationButton.backgroundColor = .dance
        calculationButton.addTarget(self, action: #selector(startCalculate), for: .touchUpInside)
        
        contentView.addSubview(calculationButton)
        calculationButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
        }
        
        calculationGrid = GridLabel.init(rows: 2, columns: 4)
        contentView.addSubview(calculationGrid)
        calculationGrid.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(calculationButton.snp.bottom).offset(10)
        }
        
        simulationButton = WideButton()
        simulationButton.setTitle(NSLocalizedString("模拟计算", comment: "队伍详情页面"), for: .normal)
        simulationButton.backgroundColor = .vocal
        simulationButton.addTarget(self, action: #selector(startSimulate), for: .touchUpInside)
        contentView.addSubview(simulationButton)
        simulationButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(calculationGrid.snp.bottom).offset(10)
        }
        
        simulatingIndicator = UIActivityIndicatorView(style: .white)
        simulationButton.addSubview(simulatingIndicator)
        simulatingIndicator.snp.makeConstraints { (make) in
            make.right.equalTo(simulationButton.titleLabel!.snp.left)
            make.centerY.equalTo(simulationButton)
        }
        
        cancelButton = WideButton()
        cancelButton.setTitle(NSLocalizedString("取消", comment: ""), for: .normal)
        cancelButton.backgroundColor = .vocal
        cancelButton.addTarget(self, action: #selector(cancelSimulating), for: .touchUpInside)
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(simulationButton)
            self.cancelButtonWidthConstraint = make.width.equalTo(0).constraint
            self.cancelButtonLeftConstraint = make.left.equalTo(simulationButton.snp.right).constraint
            make.width.equalTo(calculationGrid.snp.width).dividedBy(4).priority(900)
            make.left.equalTo(simulationButton.snp.right).offset(1).priority(900)
        }
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.titleLabel?.baselineAdjustment = .alignCenters
        
        simulationGrid = GridLabel.init(rows: 2, columns: 4)
        contentView.addSubview(simulationGrid)
        simulationGrid.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(simulationButton.snp.bottom).offset(10)
        }

        contentView.addSubview(afkModeButton)
        afkModeButton.setTitle(NSLocalizedString("模拟挂机模式", comment: ""), for: .normal)
        afkModeButton.backgroundColor = .passion
        afkModeButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(simulationGrid.snp.bottom).offset(10)
        }
        afkModeButton.addTarget(self, action: #selector(startAfkModeSimulating), for: .touchUpInside)
        
        contentView.addSubview(afkModeGrid)
        afkModeGrid.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(afkModeButton.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        
        afkModeButton.addSubview(afkModeIndicator)
        afkModeIndicator.snp.makeConstraints { (make) in
            make.right.equalTo(afkModeButton.titleLabel!.snp.left)
            make.centerY.equalTo(afkModeButton)
        }
        
        afkModeCancelButton.setTitle(NSLocalizedString("取消", comment: ""), for: .normal)
        afkModeCancelButton.backgroundColor = .passion
        afkModeCancelButton.addTarget(self, action: #selector(cancelAfkModeSimulating), for: .touchUpInside)
        contentView.addSubview(afkModeCancelButton)
        afkModeCancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(afkModeButton)
            self.afkModeCancelButtonWidthConstraint = make.width.equalTo(0).constraint
            self.afkModeCancelButtonLeftConstraint = make.left.equalTo(afkModeButton.snp.right).constraint
            make.width.equalTo(afkModeGrid.snp.width).dividedBy(4).priority(900)
            make.left.equalTo(afkModeButton.snp.right).offset(1).priority(900)
        }
        afkModeCancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        afkModeCancelButton.titleLabel?.baselineAdjustment = .alignCenters
        
        prepareGridViewFields()
        
        selectionStyle = .none

    }
    
    private func prepareGridViewFields() {
        var calculationString = [[String]]()
        calculationString.append([NSLocalizedString("表现值", comment: "队伍详情页面"), NSLocalizedString("极限分数", comment: "队伍详情页面") + "1", NSLocalizedString("极限分数", comment: "队伍详情页面") + "2", NSLocalizedString("平均分数", comment: "队伍详情页面")])
        calculationString.append(["", "", "", ""])
        calculationGrid.setContents(calculationString)
        
        var simulationStrings = [[String]]()
        simulationStrings.append(["1%", "5%", "20%", "50%"])
        simulationStrings.append(["", "", "", ""])
        simulationGrid.setContents(simulationStrings)
        
        var afkModeStrings = [[String]]()
        afkModeStrings.append([NSLocalizedString("存活率%", comment: ""), NSLocalizedString("S Rank率%", comment: ""), NSLocalizedString("最高得分", comment: "")])
        afkModeStrings.append(["", "", "", ""])
        afkModeGrid.setContents(afkModeStrings)
    }
    
    func resetCalculationButton() {
        calculationButton.setTitle(NSLocalizedString("一般计算", comment: ""), for: .normal)
        calculationButton.isUserInteractionEnabled = true
    }
    
    func stopSimulationAnimating() {
        simulationButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25) {
            self.cancelButtonWidthConstraint.activate()
            self.cancelButtonLeftConstraint.activate()
            self.layoutIfNeeded()
        }
        simulatingIndicator.stopAnimating()
        simulationButton.setTitle(NSLocalizedString("模拟计算", comment: ""), for: .normal)
    }
    
    func startSimulationAnimating() {
        simulatingIndicator.startAnimating()
        UIView.animate(withDuration: 0.25) {
            self.cancelButtonLeftConstraint.deactivate()
            self.cancelButtonWidthConstraint.deactivate()
            self.layoutIfNeeded()
        }
        simulationButton.isUserInteractionEnabled = false
    }
    
    func startAfkModeSimulationAnimating() {
        afkModeIndicator.startAnimating()
        UIView.animate(withDuration: 0.25) {
            self.afkModeCancelButtonLeftConstraint.deactivate()
            self.afkModeCancelButtonWidthConstraint.deactivate()
            self.layoutIfNeeded()
        }
        afkModeButton.isUserInteractionEnabled = false
    }
    
    func stopAfkModeSimulationAnimating() {
        afkModeButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25) {
            self.afkModeCancelButtonLeftConstraint.activate()
            self.afkModeCancelButtonWidthConstraint.activate()
            self.layoutIfNeeded()
        }
        afkModeIndicator.stopAnimating()
        afkModeButton.setTitle(NSLocalizedString("模拟挂机模式", comment: ""), for: .normal)
    }

    func setupCalculationResult(value1: Int, value2: Int, value3: Int, value4: Int) {
        calculationGrid[1, 0].text = String(value1)
        calculationGrid[1, 1].text = String(value2)
        calculationGrid[1, 2].text = String(value3)
        calculationGrid[1, 3].text = String(value4)
    }
    
    func setupSimulationResult(value1: Int, value2: Int, value3: Int, value4: Int) {
        simulationGrid[1, 0].text = String(value1)
        simulationGrid[1, 1].text = String(value2)
        simulationGrid[1, 2].text = String(value3)
        simulationGrid[1, 3].text = String(value4)
    }
    
    func setupAfkModeResult(value1: String, value2: String, value3: String) {
        afkModeGrid[1, 0].text = value1
        afkModeGrid[1, 1].text = value2
        afkModeGrid[1, 2].text = value3
    }
    
    func setupAppeal(_ appeal: Int) {
        calculationGrid[1, 0].text = String(appeal)
    }
    
    func clearCalculationGrid() {
        calculationGrid[1, 2].text = ""
        calculationGrid[1, 1].text = ""
        calculationGrid[1, 0].text = ""
        calculationGrid[1, 3].text = ""
    }
    
    func clearSimulationGrid() {
        simulationGrid[1, 0].text = ""
        simulationGrid[1, 1].text = ""
        simulationGrid[1, 2].text = ""
        simulationGrid[1, 3].text = ""
    }
    
    func clearAfkModeGrid() {
        afkModeGrid[1, 0].text = ""
        afkModeGrid[1, 1].text = ""
        afkModeGrid[1, 2].text = ""
    }
    
    @objc func startCalculate() {
        delegate?.startCalculate(self)
    }
    
    @objc func startSimulate() {
        delegate?.startSimulate(self)
    }
    
    @objc func cancelSimulating() {
        delegate?.cancelSimulating(self)
    }
    
    @objc private func startAfkModeSimulating() {
        delegate?.startAfkModeSimulating(self)
    }
    
    @objc private func cancelAfkModeSimulating() {
        delegate?.cancelAfkModeSimulating(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

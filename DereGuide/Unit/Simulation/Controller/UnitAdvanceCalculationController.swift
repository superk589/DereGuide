//
//  UnitAdvanceCalculationController.swift
//  DereGuide
//
//  Created by zzk on 2017/6/20.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class UnitAdvanceCalculationController: UITableViewController {
    
    struct DescriptionRow {
        var name: String
        var value: Int
    }
    
    struct CalculationRow {
        var name: String
        var variableDescriptions: [String]
        var result: String?
        var variables: [String]?
    }
    
    var formulator: LiveFormulator!
    var result: LSResult!
    
    fileprivate lazy var descriptionSection: [DescriptionRow] = {
        let row1 = DescriptionRow(name: NSLocalizedString("模拟次数", comment: ""), value: self.result.scores.count)
        let row2 = DescriptionRow(name: NSLocalizedString("最高分数", comment: ""), value: self.result.maxScore)
        let row3 = DescriptionRow(name: NSLocalizedString("最低分数", comment: ""), value: self.result.minScore)
        let row4 = DescriptionRow(name: NSLocalizedString("理论最高分数", comment: ""), value: self.formulator.maxScore)
        let row5 = DescriptionRow(name: NSLocalizedString("理论最低分数", comment: ""), value: self.formulator.minScore)
        return [row1, row2, row3, row4, row5]
    }()
    
    fileprivate lazy var calculationSection: [CalculationRow] = {
        let row1 = CalculationRow(name: NSLocalizedString("模拟结果中前x%的最低分数", comment: ""), variableDescriptions: ["x"], result: nil, variables: nil)
        let row2 = CalculationRow(name: NSLocalizedString("模拟结果中后x%的最高分数", comment: ""), variableDescriptions: ["x"], result: nil, variables: nil)
        let row3 = CalculationRow(name: NSLocalizedString("模拟结果中分数落入指定区间[a, b]的概率", comment: ""), variableDescriptions: ["a(" + NSLocalizedString("不填表示", comment: "") + "-∞)", "b(" + NSLocalizedString("不填表示", comment: "") + "+∞)"], result: nil, variables: nil)
        let row4 = CalculationRow(name: NSLocalizedString("根据概率密度曲线估算分数区间[a, b]的概率", comment: ""), variableDescriptions: ["a(" + NSLocalizedString("不填表示", comment: "") + "-∞)", "b(" + NSLocalizedString("不填表示", comment: "") + "+∞)"], result: nil, variables: nil)
        return [row1, row2, row3, row4]
    }()
    
    convenience init(result: LSResult) {
        self.init()
        self.result = result
        navigationItem.title = NSLocalizedString("高级计算", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(UnitAdvanceCalculationCell.self, forCellReuseIdentifier: UnitAdvanceCalculationCell.description())
        tableView.register(UnitAdvanceDescriptionCell.self, forCellReuseIdentifier: UnitAdvanceDescriptionCell.description())
    }
}

extension UnitAdvanceCalculationController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("参考值", comment: "")
        } else {
            return NSLocalizedString("自定义计算", comment: "")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return descriptionSection.count
        } else {
            return calculationSection.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitAdvanceDescriptionCell.description(), for: indexPath) as! UnitAdvanceDescriptionCell
            let row = descriptionSection[indexPath.row]
            cell.setupWith(leftString: row.name, rightString: String(row.value))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitAdvanceCalculationCell.description(), for: indexPath) as! UnitAdvanceCalculationCell
            let row = calculationSection[indexPath.row]
            cell.setup(row)
            cell.delegate = self
            return cell
        }
    }
}

extension UnitAdvanceCalculationController: UnitAdvanceCalculationCellDelegate {
    private func validateDoublePercentInput(variable: String) -> Bool {
        if let double = Double(variable), double <= 100, double >= 0 {
            return true
        } else {
            showNotValidAlert()
            return false
        }
    }
    
    private func validateDoubleOrNilInput(variable: String) -> Bool {
        if variable == "" {
            return true
        } else if let _ = Double(variable) {
            return true
        } else {
            showNotValidAlert()
            return false
        }
    }
    
    private func showNotValidAlert() {
        UIAlertController.showHintMessage(NSLocalizedString("您输入的变量不合法", comment: ""), in: nil)
    }
    
    func unitAdvanceCalculationCell(_ unitAdvanceCalculationCell: UnitAdvanceCalculationCell, didStartCalculationWith varibles: [String]) {
        guard let indexPath = tableView.indexPath(for: unitAdvanceCalculationCell) else {
            return
        }
        switch indexPath.row {
        case 0:
            if validateDoublePercentInput(variable: varibles[0]) {
                let x = Double(varibles[0])!
                calculationSection[indexPath.row].variables = [String(x)]
                calculationSection[indexPath.row].result = String(result.get(percent: x, true))
                unitAdvanceCalculationCell.updateResult(calculationSection[indexPath.row])
            }
        case 1:
            if validateDoublePercentInput(variable: varibles[0]) {
                let x = Double(varibles[0])!
                calculationSection[indexPath.row].variables = [String(x)]
                calculationSection[indexPath.row].result = String(result.get(percent: x, false))
                unitAdvanceCalculationCell.updateResult(calculationSection[indexPath.row])
            }
        case 2:
            if validateDoubleOrNilInput(variable: varibles[0]) && validateDoubleOrNilInput(variable: varibles[1]) {
                let a = Double(varibles[0]) ?? 0
                let b = Double(varibles[1]) ?? Double.greatestFiniteMagnitude
                calculationSection[indexPath.row].variables = varibles
                let value = Double(result.scores.filter { Double($0) <= b && Double($0) >= a }.count) / Double(result.scores.count)
                calculationSection[indexPath.row].result = String(value)
                unitAdvanceCalculationCell.updateResult(calculationSection[indexPath.row])
            }
        case 3:
            if validateDoubleOrNilInput(variable: varibles[0]) && validateDoubleOrNilInput(variable: varibles[1]) {
                let a = Double(varibles[0]) ?? 0
                let b = Double(varibles[1]) ?? Double.greatestFiniteMagnitude
                calculationSection[indexPath.row].variables = varibles
                unitAdvanceCalculationCell.startCalculationAnimating()
                DispatchQueue.global(qos: .userInteractive).async {
                    let value = self.result.estimate(using: LSResult.Kernel.gaussian, range: Range<Double>.init(uncheckedBounds: (a, b)), bound: Range<Double>.init(uncheckedBounds: (Double(self.formulator.minScore), Double(self.formulator.maxScore))))
                    self.calculationSection[indexPath.row].result = String(value)
                    DispatchQueue.main.async {
                        unitAdvanceCalculationCell.stopCalculationAnimating()
                        unitAdvanceCalculationCell.updateResult(self.calculationSection[indexPath.row])
                    }
                }
            }
        default:
            break
        }
    }
}

//
//  UnitAdvanceCalculationCell.swift
//  DereGuide
//
//  Created by zzk on 2017/6/20.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

typealias UnitAdvanceCalculationCellVariableView = TextFieldOption

protocol UnitAdvanceCalculationCellDelegate: class {
    func unitAdvanceCalculationCell(_ unitAdvanceCalculationCell: UnitAdvanceCalculationCell, didStartCalculationWith varibles: [String])
}

class UnitAdvanceCalculationCell: UITableViewCell {

    let titleLabel = UILabel()
    
    weak var delegate: UnitAdvanceCalculationCellDelegate?
    
    var variableNames = [String]() {
        didSet {
            rearrangeStackView()
        }
    }
    
    var inputStrings: [String] {
        return stackView.arrangedSubviews.map {
            return ($0 as? UnitAdvanceCalculationCellVariableView)?.textField.text ?? ""
        }
    }
    
    var stackView: UIStackView!
    let startButton = WideButton()
    let resultView = UnitAdvanceCalculationResultView()
    let startButtonIndicator = UIActivityIndicatorView(style: .white)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
        }
        stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.right.equalTo(readableContentGuide)
        }
        
        contentView.addSubview(resultView)
        resultView.snp.makeConstraints { (make) in
            make.right.equalTo(readableContentGuide)
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(stackView.snp.bottom).offset(10)
        }
        
        startButton.setTitle(NSLocalizedString("开始计算", comment: ""), for: .normal)
        startButton.backgroundColor = .dance
        startButton.addTarget(self, action: #selector(handleStartButton(_:)), for: .touchUpInside)
        contentView.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
            make.top.equalTo(resultView.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        
        startButton.addSubview(startButtonIndicator)
        startButtonIndicator.snp.makeConstraints { (make) in
            make.right.equalTo(startButton.titleLabel!.snp.left)
            make.centerY.equalTo(startButton)
        }
    }
    
    private func rearrangeStackView() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for name in variableNames {
            let view = UnitAdvanceCalculationCellVariableView()
            view.label.text = name
            view.textField.delegate = self
            stackView.addArrangedSubview(view)
        }
        
        selectionStyle = .none
    }
    
    @objc private func handleStartButton(_ button: UIButton) {
        delegate?.unitAdvanceCalculationCell(self, didStartCalculationWith: inputStrings)
    }
    
    func setup(_ data: UnitAdvanceCalculationController.CalculationRow) {
        titleLabel.text = data.name
        variableNames = data.variableDescriptions
        for view in stackView.arrangedSubviews {
            if let view = view as? UnitAdvanceCalculationCellVariableView,
                let index = stackView.arrangedSubviews.firstIndex(of: view),
                let variables = data.variables {
                view.textField.text = variables[index]
            }
        }
        updateResult(data)
    }
    
    func updateResult(_ data: UnitAdvanceCalculationController.CalculationRow) {
        if let result = data.result {
            resultView.rightLabel.text = result
        } else {
            resultView.rightLabel.text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopCalculationAnimating() {
        startButton.isUserInteractionEnabled = true
        startButtonIndicator.stopAnimating()
        startButton.setTitle(NSLocalizedString("开始计算", comment: ""), for: .normal)
    }
    
    func startCalculationAnimating() {
        startButtonIndicator.startAnimating()
        startButton.setTitle(NSLocalizedString("计算中...", comment: ""), for: .normal)
        startButton.isUserInteractionEnabled = false
    }
}

extension UnitAdvanceCalculationCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        resultView.rightLabel.text = ""
    }
}

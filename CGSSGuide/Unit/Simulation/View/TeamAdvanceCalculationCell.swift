//
//  TeamAdvanceCalculationCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/20.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

typealias TeamAdvanceCalculationCellVariableView = TeamSimulationTextFieldOption

protocol TeamAdvanceCalculationCellDelegate: class {
    func teamAdvanceCalculationCell(_ teamAdvanceCalculationCell: TeamAdvanceCalculationCell, didStartCalculationWith varibles: [String])
}

class TeamAdvanceCalculationCell: UITableViewCell {

    var titleLabel: UILabel!
    
    weak var delegate: TeamAdvanceCalculationCellDelegate?
    
    var variableNames = [String]() {
        didSet {
            rearrangeStackView()
        }
    }
    
    var inputStrings: [String] {
        return stackView.arrangedSubviews.map {
            return ($0 as? TeamAdvanceCalculationCellVariableView)?.textField.text ?? ""
        }
    }
    var stackView: UIStackView!
    var startButton: UIButton!
    var resultView: TeamAdvanceCalculationResultView!
    var startButtonIndicator: UIActivityIndicatorView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.right.equalTo(-10)
        }
        
        resultView = TeamAdvanceCalculationResultView()
        contentView.addSubview(resultView)
        resultView.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.left.equalTo(10)
            make.top.equalTo(stackView.snp.bottom).offset(10)
        }
        
        startButton = UIButton()
        startButton.setTitle(NSLocalizedString("开始计算", comment: ""), for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.backgroundColor = Color.parade
        startButton.addTarget(self, action: #selector(handleStartButton(_:)), for: .touchUpInside)
        contentView.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(30)
            make.top.equalTo(resultView.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        
        startButtonIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
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
            let view = TeamAdvanceCalculationCellVariableView()
            view.label.text = name
            view.textField.delegate = self
            stackView.addArrangedSubview(view)
        }
        
        selectionStyle = .none
    }
    
    func handleStartButton(_ button: UIButton) {
        delegate?.teamAdvanceCalculationCell(self, didStartCalculationWith: inputStrings)
    }
    
    func setup(_ data: TeamAdvanceCalculationController.CalculationRow) {
        titleLabel.text = data.name
        variableNames = data.variableDescriptions
        for view in stackView.arrangedSubviews {
            if let view = view as? TeamAdvanceCalculationCellVariableView,
                let index = stackView.arrangedSubviews.index(of: view),
                let variables = data.variables {
                view.textField.text = variables[index]
            }
        }
        updateResult(data)
    }
    
    func updateResult(_ data: TeamAdvanceCalculationController.CalculationRow) {
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

extension TeamAdvanceCalculationCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        resultView.rightLabel.text = ""
    }
}

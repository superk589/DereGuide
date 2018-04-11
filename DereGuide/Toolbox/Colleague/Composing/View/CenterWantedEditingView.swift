//
//  CenterWantedEditingView.swift
//  DereGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

protocol CenterWantedEditingViewDelegate: class {
    func didDelete(centerWantedEditingView: CenterWantedEditingView)
}

class CenterWantedEditingView: UIView {

    var deleteButton: UIButton!
    
    var minLevelStepper: PotentialValueStepper!
    
    var stackView: UIStackView!
    
    var card: CGSSCard!
    
    weak var delegate: CenterWantedEditingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    var minLevel: Int {
        get {
            return Int(minLevelStepper.value)
        }
        set {
            self.minLevelStepper.value = Double(newValue)
        }
    }
    
    func prepare() {
        minLevelStepper = PotentialValueStepper(type: .all)
        minLevelStepper.maximumValue = Double(Config.maximumTotalPotential)
        minLevelStepper.addTarget(self, action: #selector(handleStepperValueChanged(_:)), for: .valueChanged)
        minLevelStepper.numberFormatter.positivePrefix = "≥ "

        deleteButton = UIButton()
        deleteButton.setTitle(NSLocalizedString("删除", comment: ""), for: .normal)
        deleteButton.titleLabel?.textColor = UIColor.white
        deleteButton.backgroundColor = .vocal
        deleteButton.addTarget(self, action: #selector(handleDeleteButton(_:)), for: .touchUpInside)
        deleteButton.layer.cornerRadius = 4
        deleteButton.layer.masksToBounds = true
        
        stackView = UIStackView(arrangedSubviews: [minLevelStepper, deleteButton])
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
    }

    @objc func handleDeleteButton(_ button: UIButton) {
        delegate?.didDelete(centerWantedEditingView: self)
    }
    
    @objc func handleStepperValueChanged(_ stepper: ValueStepper) {
        setDescriptionLabels()
    }
    
    func setupWith(card: CGSSCard, minLevel: Int) {
        self.card = card
        self.minLevel = minLevel
        setDescriptionLabels()
    }
    
    private func setDescriptionLabels() {
//        minLevelStepper.descriptionLabel.text = ">= " + String(minLevel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

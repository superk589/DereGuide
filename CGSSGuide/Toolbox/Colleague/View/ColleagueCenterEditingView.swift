//
//  ColleagueCenterEditingView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/3.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol MyCenterEditingViewDelegate: class {
    func didDelete(myCenterEditingView: MyCenterEditingView)
}

class MyCenterEditingView: UIView {
  
    var vocalStepper: ValueStepper!
    var danceStepper: ValueStepper!
    var visualStepper: ValueStepper!
    
    var deleteButton: UIButton!
    
    var stackView: UIStackView!

    var card: CGSSCard!
    var potential: CGSSPotential {
        set {
            vocalStepper.value = Double(newValue.vocalLevel)
            danceStepper.value = Double(newValue.danceLevel)
            visualStepper.value = Double(newValue.visualLevel)
        }
        get {
            return CGSSPotential(vocalLevel: Int(vocalStepper.value), danceLevel: Int(danceStepper.value), visualLevel: Int(visualStepper.value), lifeLevel: 0)
        }
    }
    
    var appeal: CGSSAppeal {
        return card.appeal.addBy(potential: potential, rarity: card.rarityType)
    }
    
    weak var delegate: MyCenterEditingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    func prepare() {
        
        vocalStepper = PotentialValueStepper(type: .vocal)
        vocalStepper.addTarget(self, action: #selector(handleStepperValueChanged(_:)), for: .valueChanged)
        
        danceStepper = PotentialValueStepper(type: .dance)
        danceStepper.addTarget(self, action: #selector(handleStepperValueChanged(_:)), for: .valueChanged)
        
        visualStepper = PotentialValueStepper(type: .visual)
        visualStepper.addTarget(self, action: #selector(handleStepperValueChanged(_:)), for: .valueChanged)

        deleteButton = UIButton()
        deleteButton.setTitle(NSLocalizedString("删除", comment: ""), for: .normal)
        deleteButton.titleLabel?.textColor = UIColor.white
        deleteButton.backgroundColor = Color.vocal
        deleteButton.addTarget(self, action: #selector(handleDeleteButton(_:)), for: .touchUpInside)
        deleteButton.layer.cornerRadius = 4
        deleteButton.layer.masksToBounds = true
        
        stackView = UIStackView(arrangedSubviews: [vocalStepper, danceStepper, visualStepper, deleteButton])
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
    
    @objc func handleStepperValueChanged(_ stepper: ValueStepper) {
        setDescriptionLabels()
    }
    
    func handleDeleteButton(_ button: UIButton) {
        delegate?.didDelete(myCenterEditingView: self)
    }
    
    func setupWith(potential: CGSSPotential, card: CGSSCard) {
        self.card = card
        self.potential = potential
        setDescriptionLabels()
    }
    
    private func setDescriptionLabels() {
        vocalStepper.descriptionLabel.text = String(appeal.vocal)
        danceStepper.descriptionLabel.text = String(appeal.dance)
        visualStepper.descriptionLabel.text = String(appeal.visual)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

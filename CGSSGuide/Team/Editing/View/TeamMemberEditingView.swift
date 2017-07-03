//
//  TeamMemberEditingView.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/18.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamMemberEditingView: UIView {

    var skillStepper: ValueStepper!
    var vocalStepper: ValueStepper!
    var danceStepper: ValueStepper!
    var visualStepper: ValueStepper!
    
    var stackView: UIStackView!
    
    var card: CGSSCard!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    func prepare() {
        
        skillStepper = ValueStepper()
        skillStepper.maximumValue = 10
        skillStepper.minimumValue = 1
        skillStepper.stepValue = 1
        skillStepper.numberFormatter.maximumFractionDigits = 0
        skillStepper.numberFormatter.positivePrefix = "SLv. "
        skillStepper.addTarget(self, action: #selector(handleStepperValueChanged(_:)), for: .valueChanged)
        skillStepper.tintColor = UIColor.black
        
        vocalStepper = ValueStepper()
        vocalStepper.maximumValue = 10
        vocalStepper.minimumValue = 0
        vocalStepper.stepValue = 1
        vocalStepper.numberFormatter.maximumFractionDigits = 0
        vocalStepper.numberFormatter.positivePrefix = "Vo +"
        vocalStepper.addTarget(self, action: #selector(handleStepperValueChanged(_:)), for: .valueChanged)
        vocalStepper.tintColor = Color.vocal
        
        danceStepper = ValueStepper()
        danceStepper.maximumValue = 10
        danceStepper.minimumValue = 0
        danceStepper.stepValue = 1
        danceStepper.numberFormatter.maximumFractionDigits = 0
        danceStepper.numberFormatter.positivePrefix = "Da +"
        danceStepper.addTarget(self, action: #selector(handleStepperValueChanged(_:)), for: .valueChanged)
        danceStepper.tintColor = Color.dance
        
        visualStepper = ValueStepper()
        visualStepper.maximumValue = 10
        visualStepper.minimumValue = 0
        visualStepper.stepValue = 1
        visualStepper.numberFormatter.maximumFractionDigits = 0
        visualStepper.numberFormatter.positivePrefix = "Vi +"
        visualStepper.addTarget(self, action: #selector(handleStepperValueChanged(_:)), for: .valueChanged)
        visualStepper.tintColor = Color.visual
        
        stackView = UIStackView(arrangedSubviews: [skillStepper, vocalStepper, danceStepper, visualStepper])
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
    
    func handleStepperValueChanged(_ stepper: ValueStepper) {
        let potential = CGSSPotential(vocalLevel: Int(vocalStepper.value), danceLevel: Int(danceStepper.value), visualLevel: Int(visualStepper.value), lifeLevel: 0)
        let appeal = card.appeal.addBy(potential: potential, rarity: card.rarityType)
        if stepper == skillStepper {
            if let skill = card.skill {
                stepper.descriptionLabel.text = String.init(format: "%.2f/%ds, %.2f%%\n%@", skill.effectLengthOfLevel(Int(stepper.value)) / 100, skill.condition, skill.procChanceOfLevel(Int(stepper.value)) / 100, skill.skillFilterType.description)
            }
        } else if stepper == vocalStepper {
            stepper.descriptionLabel.text = String(appeal.vocal)
        } else if stepper == danceStepper {
            stepper.descriptionLabel.text = String(appeal.dance)
        } else if stepper == visualStepper {
            stepper.descriptionLabel.text = String(appeal.visual)
        }
    }
    
    private func setSkillItemNotAvailable() {
        skillStepper.isEnabled = false
        skillStepper.valueLabel.text = "n/a"
        skillStepper.descriptionLabel.text = ""
    }
    
    func setupWith(member: CGSSTeamMember, card: CGSSCard) {
        self.card = card
        if let skill = member.cardRef?.skill {
            skillStepper.value = Double(member.skillLevel!)
            skillStepper.valueLabel.text = "SLv. \(member.skillLevel!)"
            skillStepper.descriptionLabel.text = String.init(format: "%.2f/%ds, %.2f%%\n%@", skill.effectLengthOfLevel(member.skillLevel!) / 100, skill.condition, skill.procChanceOfLevel(member.skillLevel!) / 100, skill.skillFilterType.description)
        } else {
            setSkillItemNotAvailable()
        }
        
        let potential = member.potential
        let appeal = card.appeal.addBy(potential: potential, rarity: card.rarityType)
        
        vocalStepper.value = Double(member.vocalLevel!)
        vocalStepper.descriptionLabel.text = String(appeal.vocal)
        
        danceStepper.value = Double(member.danceLevel!)
        danceStepper.descriptionLabel.text = String(appeal.dance)
        
        visualStepper.value = Double(member.visualLevel!)
        visualStepper.descriptionLabel.text = String(appeal.visual)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

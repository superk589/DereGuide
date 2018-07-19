//
//  MemberEditingView.swift
//  DereGuide
//
//  Created by zzk on 2016/9/18.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class MemberEditingView: UIView {

    let skillStepper = ValueStepper()
    let vocalStepper = ValueStepper()
    let danceStepper = ValueStepper()
    let visualStepper = ValueStepper()
    let lifeStepper = ValueStepper()
    var skillPotentialStepper = ValueStepper()
    
    var stackView: UIStackView!
    
    var card: CGSSCard!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    private func config(stepper: ValueStepper, maximumValue: Double, minimumValue: Double, tintColor: UIColor, prefix: String) {
        stepper.maximumValue = maximumValue
        stepper.minimumValue = minimumValue
        stepper.stepValue = 1
        stepper.numberFormatter.maximumFractionDigits = 0
        stepper.numberFormatter.positivePrefix = prefix
        stepper.addTarget(self, action: #selector(handleStepperValueChanged(_:)), for: .valueChanged)
        stepper.tintColor = tintColor
    }
    
    func prepare() {
        
        config(stepper: skillStepper, maximumValue: 10, minimumValue: 1, tintColor: .black, prefix: "SLv. ")
        config(stepper: vocalStepper, maximumValue: 10, minimumValue: 0, tintColor: .vocal, prefix: "Vo +")
        config(stepper: danceStepper, maximumValue: 10, minimumValue: 0, tintColor: .dance, prefix: "Da +")
        config(stepper: visualStepper, maximumValue: 10, minimumValue: 0, tintColor: .visual, prefix: "Vi +")
        config(stepper: lifeStepper, maximumValue: 10, minimumValue: 0, tintColor: .life, prefix: "HP +")
        config(stepper: skillPotentialStepper, maximumValue: 10, minimumValue: 0, tintColor: .skill, prefix: "SP +")
        
        stackView = UIStackView(arrangedSubviews: [skillStepper, vocalStepper, danceStepper, visualStepper, lifeStepper, skillPotentialStepper])
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
        let potential = Potential(vocal: Int(vocalStepper.value), dance: Int(danceStepper.value), visual: Int(visualStepper.value), skill: Int(skillPotentialStepper.value), life: Int(lifeStepper.value))
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
        } else if stepper == lifeStepper {
            stepper.descriptionLabel.text = String(appeal.life)
        } else if stepper == skillPotentialStepper {
            stepper.descriptionLabel.text = String(format: "+%d%%", skillPotentialOfLevel[card.rarityType]?[Int(stepper.value)] ?? 0)
        }
    }
    
    private func setSkillItemNotAvailable() {
        skillStepper.isEnabled = false
        skillStepper.valueLabel.text = "n/a"
        skillStepper.descriptionLabel.text = ""
    }
    
    func setupWith(member: Member, card: CGSSCard) {
        self.card = card
        if let skill = member.card?.skill {
            skillStepper.value = Double(member.skillLevel)
            skillStepper.valueLabel.text = "SLv. \(member.skillLevel)"
            skillStepper.descriptionLabel.text = String.init(format: "%.2f/%ds, %.2f%%\n%@", skill.effectLengthOfLevel(Int(member.skillLevel)) / 100, skill.condition, skill.procChanceOfLevel(Int(member.skillLevel)) / 100, skill.skillFilterType.description)
        } else {
            setSkillItemNotAvailable()
        }
        
        let potential = member.potential
        let appeal = card.appeal.addBy(potential: potential, rarity: card.rarityType)
        
        vocalStepper.value = Double(member.vocalLevel)
        vocalStepper.descriptionLabel.text = String(appeal.vocal)
        
        danceStepper.value = Double(member.danceLevel)
        danceStepper.descriptionLabel.text = String(appeal.dance)
        
        visualStepper.value = Double(member.visualLevel)
        visualStepper.descriptionLabel.text = String(appeal.visual)
        
        lifeStepper.value = Double(member.lifeLevel)
        lifeStepper.descriptionLabel.text = String(appeal.life)
        
        skillPotentialStepper.value = Double(member.skillPotentialLevel)
        skillPotentialStepper.descriptionLabel.text = String(format: "+%d%%", skillPotentialOfLevel[card.rarityType]?[Int(skillPotentialStepper.value)] ?? 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

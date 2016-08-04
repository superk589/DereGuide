//
//  TeamMemberTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/3.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol TeamMemberTableViewCellDelegate {
    func skillLevelDidChange(cell:TeamMemberTableViewCell, lv:String)
    func skillLevelDidBeginEditing(cell:TeamMemberTableViewCell)
}
class TeamMemberTableViewCell: UITableViewCell {

    var delegate:TeamMemberTableViewCellDelegate?
    @IBOutlet weak var detail: UIView! {
        didSet {
            detail.hidden = true
        }
    }
    @IBOutlet weak var skilllevel: UITextField!
    @IBOutlet weak var skillDesc: UILabel!
    @IBOutlet weak var icon: CGSSCardIconView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var skillName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateLevel(model:CGSSTeamMember) {
        self.skilllevel.text = String(model.skillLevel!)
        if var skillDesc = model.cardRef?.skill?.explain_en {
            
            let pattern =  "[0-9.]+ ~ [0-9.]+"
            let subs = CGSSTool.getStringByPattern(skillDesc, pattern: pattern)
            let skill = model.cardRef!.skill!
            let sub1 = subs[0]
            let range1 = skillDesc.rangeOfString(sub1 as String)
            skillDesc.replaceRange(range1!, with: String(skill.procChanceOfLevel(model.skillLevel!)!))
            let sub2 = subs[1]
            let range2 = skillDesc.rangeOfString(sub2 as String)
            skillDesc.replaceRange(range2!, with: String(skill.effectLengthOfLevel(model.skillLevel!)!))
            self.skillDesc.text = skillDesc
        }
    }
    func initWith(model:CGSSTeamMember) {
        self.updateLevel(model)
        self.icon.setWithCardId((model.cardRef?.id)!)
        self.skillName.text = model.cardRef?.skill?.skill_name
        self.cardName.text = model.cardRef?.name_only
        detail.hidden = false
        //self.title.text = title
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func levelFieldBegin(sender: UITextField) {
        delegate?.skillLevelDidBeginEditing(self)
    }
    @IBAction func levelFieldDone(sender: UITextField) {
        skilllevel.resignFirstResponder()
        delegate?.skillLevelDidChange(self, lv: skilllevel.text!)
    }
}

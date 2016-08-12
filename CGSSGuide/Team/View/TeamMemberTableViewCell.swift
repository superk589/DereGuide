//
//  TeamMemberTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/3.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol TeamMemberTableViewCellDelegate: class {
	func skillLevelDidChange(cell: TeamMemberTableViewCell, lv: String)
	func skillLevelDidBeginEditing(cell: TeamMemberTableViewCell)
}
class TeamMemberTableViewCell: UITableViewCell, UITextFieldDelegate {
	
	weak var delegate: TeamMemberTableViewCellDelegate?
	
	var skillView: UIView!
	var skilllevel: UITextField!
	var skillDesc: UILabel!
	var icon: CGSSCardIconView!
	var title: UILabel!
	
	var cardName: UILabel!
	var skillName: UILabel!
	
	var leaderSkillView: UIView!
	
	var leaderSkillName: UILabel!
	var leaderSkillDesc: UILabel!
	
	var originY: CGFloat = 0
	var topSpace: CGFloat = 10
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		originY += topSpace
		title = UILabel.init(frame: CGRectMake(10, originY, 48, 18))
		title.font = UIFont.systemFontOfSize(16)
		title.textColor = UIColor.lightGrayColor()
		title.textAlignment = .Left
		
		cardName = UILabel.init(frame: CGRectMake(68, originY, CGSSTool.width - 90, 18))
		cardName.font = UIFont.systemFontOfSize(16)
		cardName.textAlignment = .Left
		
		let detail = UILabel.init(frame: CGRectMake(CGSSTool.width - 22, originY, 12, 18))
		detail.text = ">"
		detail.textColor = UIColor.lightGrayColor()
		
		originY += 18 + topSpace
		
		icon = CGSSCardIconView.init(frame: CGRectMake(10, originY, 48, 48))
		
		// originY += 30 + topSpace
		
		contentView.addSubview(icon)
		contentView.addSubview(title)
		contentView.addSubview(cardName)
		contentView.addSubview(detail)
		contentView.fheight = originY
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupSkillView() {
		if skillView != nil {
			return
		}
		skillView = UIView.init(frame: CGRectMake(68, originY, CGSSTool.width - 78, 0))
		
		let skillStaticDesc = UILabel.init(frame: CGRectMake(0, 0, 35, 16))
		skillStaticDesc.text = "特技:"
		skillStaticDesc.font = UIFont.systemFontOfSize(14)
		skillStaticDesc.textAlignment = .Left
		skillStaticDesc.textColor = UIColor.lightGrayColor()
		
		skillName = UILabel.init(frame: CGRectMake(40, 0, skillView.fwidth - 160, 16))
		skillName.textColor = UIColor.darkGrayColor()
		skillName.textAlignment = .Left
		skillName.font = UIFont.systemFontOfSize(14)
		
		let skillLevelStaticDesc = UILabel.init(frame: CGRectMake(skillView.fwidth - 120, 0, 70, 16))
		skillLevelStaticDesc.text = "特技等级:"
		skillLevelStaticDesc.font = UIFont.systemFontOfSize(14)
		skillLevelStaticDesc.textAlignment = .Left
		skillLevelStaticDesc.textColor = UIColor.lightGrayColor()
		
		skilllevel = UITextField.init(frame: CGRectMake(skillView.fwidth - 50, 0, 50, 16))
		skilllevel.borderStyle = .RoundedRect
		skilllevel.font = UIFont.systemFontOfSize(14)
		skilllevel.delegate = self
		skilllevel.textAlignment = .Right
		
		// originY += 16 + topSpace / 2
		
		skillDesc = UILabel.init(frame: CGRectMake(0, 21, skillView.fwidth, 0))
		skillDesc.numberOfLines = 0
		skillDesc.lineBreakMode = .ByCharWrapping
		skillDesc.font = UIFont.systemFontOfSize(12)
		skillDesc.textColor = UIColor.darkGrayColor()
		
		skillView.addSubview(skillStaticDesc)
		skillView.addSubview(skillLevelStaticDesc)
		skillView.addSubview(skillName)
		skillView.addSubview(skilllevel)
		skillView.addSubview(skillDesc)
		
		skillView.clipsToBounds = true
		contentView.addSubview(skillView)
		contentView.fheight = max(skillView.fy, icon.fheight + icon.fy)
		
	}
	
	func setupLeaderSkillView() {
		if leaderSkillView != nil {
			return
		}
		leaderSkillView = UIView.init(frame: CGRectMake(68, originY, CGSSTool.width - 78, 0))
		let leaderSkillStaticDesc = UILabel.init(frame: CGRectMake(0, 0, 65, 16))
		leaderSkillStaticDesc.text = "队长技能:"
		leaderSkillStaticDesc.font = UIFont.systemFontOfSize(14)
		leaderSkillStaticDesc.textAlignment = .Left
		leaderSkillStaticDesc.textColor = UIColor.lightGrayColor()
		
		leaderSkillName = UILabel.init(frame: CGRectMake(70, 0, leaderSkillView.fwidth - 70, 16))
		leaderSkillName.textColor = UIColor.darkGrayColor()
		leaderSkillName.textAlignment = .Left
		leaderSkillName.font = UIFont.systemFontOfSize(14)
		
		leaderSkillDesc = UILabel.init(frame: CGRectMake(0, 21, leaderSkillView.fwidth, 0))
		leaderSkillDesc.numberOfLines = 0
		leaderSkillDesc.lineBreakMode = .ByCharWrapping
		leaderSkillDesc.font = UIFont.systemFontOfSize(12)
		leaderSkillDesc.textColor = UIColor.darkGrayColor()
		
		leaderSkillView.addSubview(leaderSkillStaticDesc)
		leaderSkillView.addSubview(leaderSkillName)
		leaderSkillView.addSubview(leaderSkillDesc)
		leaderSkillView.clipsToBounds = true
		
		contentView.addSubview(leaderSkillView)
		contentView.fheight = max(leaderSkillView.fy, icon.fheight + icon.fy)
		
	}
	
	func initSkillViewWith(skill: CGSSSkill, skillLevel: Int?) {
		skillView.fy = originY
		skilllevel.text = String(skillLevel!)
		skillName.text = skill.skill_name
		skillDesc.fwidth = skillView.fwidth
		skillDesc.text = skill.getExplainByLevel(skillLevel!)
		skillDesc.sizeToFit()
		skillView.fheight = skillDesc.fheight + skillDesc.fy
		originY += skillView.fheight + topSpace
	}
	
	func initLeaderSkillViewWith(leaderSkill: CGSSLeaderSkill) {
		leaderSkillView.fy = originY
		leaderSkillName.text = leaderSkill.name
		leaderSkillDesc.text = leaderSkill.explain_en
		leaderSkillDesc.fwidth = leaderSkillView.fwidth
		leaderSkillDesc.sizeToFit()
		leaderSkillView.fheight = leaderSkillDesc.fheight + leaderSkillDesc.fy
		originY += leaderSkillView.fheight + topSpace
	}
	func initWith(model: CGSSTeamMember, type: CGSSTeamMemberType) {
		self.icon.setWithCardId((model.cardRef?.id)!)
		self.cardName.text = model.cardRef?.chara?.name
		originY = cardName.fy + cardName.fheight + topSpace
		skillView?.fheight = 0
		leaderSkillView?.fheight = 0
		switch type {
		case .Leader:
			if let skill = model.cardRef?.skill {
				self.setupSkillView()
				self.initSkillViewWith(skill, skillLevel: model.skillLevel)
			}
			if let leaderSkill = model.cardRef?.leader_skill {
				self.setupLeaderSkillView()
				self.initLeaderSkillViewWith(leaderSkill)
			}
		case .Sub:
			if let skill = model.cardRef?.skill {
				self.setupSkillView()
				self.initSkillViewWith(skill, skillLevel: model.skillLevel)
			}
		case .Friend:
			if let leaderSkill = model.cardRef?.leader_skill {
				self.setupLeaderSkillView()
				self.initLeaderSkillViewWith(leaderSkill)
			}
		}
		contentView.fheight = max(originY, icon.fheight + icon.fy)
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
	}
	
	// 如果通过协议方法实现结束时的回调 会导致按键盘的return键时 调用了两次skillLevelDidChange回调, 故此处不采用这个方法
//    func textFieldDidEndEditing(textField: UITextField) {
//        delegate?.skillLevelDidChange(self, lv: skilllevel.text!)
//        print("aaa")
//    }
	@IBAction func levelFieldBegin(sender: UITextField) {
		delegate?.skillLevelDidBeginEditing(self)
	}
	// 此方法同时处理did end on exit 和 editing did end
	@IBAction func levelFieldDone(sender: UITextField) {
		skilllevel.resignFirstResponder()
		delegate?.skillLevelDidChange(self, lv: skilllevel.text!)
	}
}

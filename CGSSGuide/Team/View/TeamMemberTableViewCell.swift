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
	
	var skilllevel: UITextField!
	var skillDesc: UILabel!
	var icon: CGSSCardIconView!
	var title: UILabel!
	
	var cardName: UILabel!
	var skillName: UILabel!
	
	var originY: CGFloat = 0
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		let topSpace: CGFloat = 10
		originY += topSpace
		title = UILabel.init(frame: CGRectMake(10, originY, 48, 18))
		title.font = UIFont.systemFontOfSize(16)
		title.textColor = UIColor.lightGrayColor()
		title.textAlignment = .Left
		
		cardName = UILabel.init(frame: CGRectMake(68, originY, CGSSTool.width - 90, 18))
		cardName.font = UIFont.systemFontOfSize(16)
		cardName.textAlignment = .Left
		
		let detail = UILabel.init(frame: CGRectMake(CGSSTool.width - 22, originY - 5, 12, 21))
		detail.text = ">"
		detail.textColor = UIColor.lightGrayColor()
		
		originY += 18 + topSpace
		
		icon = CGSSCardIconView.init(frame: CGRectMake(10, originY, 48, 48))
		
		let skillStaticDesc = UILabel.init(frame: CGRectMake(68, originY, 35, 16))
		skillStaticDesc.text = "技能:"
		skillStaticDesc.font = UIFont.systemFontOfSize(14)
		skillStaticDesc.textAlignment = .Left
		skillStaticDesc.textColor = UIColor.lightGrayColor()
		
		skillName = UILabel.init(frame: CGRectMake(108, originY, CGSSTool.width - 140, 16))
		skillName.textColor = UIColor.darkGrayColor()
		skillName.textAlignment = .Left
		skillName.font = UIFont.systemFontOfSize(14)
		
		let skillLevelStaticDesc = UILabel.init(frame: CGRectMake(CGSSTool.width - 130, originY, 70, 16))
		skillLevelStaticDesc.text = "技能等级:"
		skillLevelStaticDesc.font = UIFont.systemFontOfSize(14)
		skillLevelStaticDesc.textAlignment = .Left
		skillLevelStaticDesc.textColor = UIColor.lightGrayColor()
		
		skilllevel = UITextField.init(frame: CGRectMake(CGSSTool.width - 60, originY, 50, 18))
		skilllevel.borderStyle = .RoundedRect
		skilllevel.font = UIFont.systemFontOfSize(14)
		skilllevel.delegate = self
		skilllevel.textAlignment = .Right
		
		originY += 18 + topSpace
		
		skillDesc = UILabel.init(frame: CGRectMake(68, originY, CGSSTool.width - 78, 30))
		skillDesc.numberOfLines = 0
		skillDesc.font = UIFont.systemFontOfSize(14)
		skillDesc.textColor = UIColor.darkGrayColor()
		
		originY += 30 + topSpace
		
		contentView.addSubview(icon)
		contentView.addSubview(title)
		contentView.addSubview(cardName)
		contentView.addSubview(detail)
		contentView.addSubview(skillStaticDesc)
		contentView.addSubview(skillLevelStaticDesc)
		contentView.addSubview(skilllevel)
		contentView.addSubview(skillDesc)
		
		contentView.frame.size.height = originY
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateLevel(model: CGSSTeamMember) {
		self.skilllevel.text = String(model.skillLevel!)
		if model.cardRef?.skill?.explain_en != nil {
			self.skillDesc.text = model.cardRef?.skill?.getExplainByLevel(model.skillLevel!)
		}
	}
	func initWith(model: CGSSTeamMember) {
		self.updateLevel(model)
		self.icon.setWithCardId((model.cardRef?.id)!)
		self.skillName.text = model.cardRef?.skill?.skill_name
		self.cardName.text = model.cardRef?.name_only
	}
	func initWithoutSkill(model: CGSSTeamMember) {
		self.skilllevel.text = ""
		self.skillDesc.text = ""
		self.icon.setWithCardId((model.cardRef?.id)!)
		self.skillName.text = ""
		self.cardName.text = model.cardRef?.name_only
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

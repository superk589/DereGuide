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
    var skillLevelTF: UITextField!
    var skillDesc: UILabel!
    var icon: CGSSCardIconView!
    var title: UILabel!
    
    var cardName: UILabel!
    var skillName: UILabel!
    var skillLevelStaticDesc: UILabel!
    
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
        
        cardName = UILabel.init(frame: CGRectMake(68, originY, CGSSGlobal.width - 90, 18))
        cardName.font = UIFont.systemFontOfSize(16)
        cardName.textAlignment = .Left
        
        let detail = UILabel.init(frame: CGRectMake(CGSSGlobal.width - 22, originY, 12, 18))
        detail.text = ">"
        detail.font = UIFont.systemFontOfSize(16)
        detail.textColor = UIColor.lightGrayColor()
        
        originY += 18 + topSpace
        
        icon = CGSSCardIconView.init(frame: CGRectMake(10, originY + 5, 48, 48))
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
    
    func prepareSkillView() {
        if skillView != nil {
            return
        }
        
        skillView = UIView.init(frame: CGRectMake(68, originY, CGSSGlobal.width - 78, 0))
        
        let skillStaticDesc = UILabel.init(frame: CGRectMake(0, 5, 35, 17))
        skillStaticDesc.text = "特技:"
        skillStaticDesc.font = UIFont.systemFontOfSize(14)
        skillStaticDesc.textAlignment = .Left
        skillStaticDesc.textColor = UIColor.blackColor()
        skillStaticDesc.sizeToFit()
        
        skillName = UILabel.init(frame: CGRectMake(skillStaticDesc.fwidth + 5, 5, skillView.fwidth - skillStaticDesc.fwidth - 85, 17))
        skillName.textColor = UIColor.blackColor()
        skillName.textAlignment = .Left
        skillName.font = UIFont.systemFontOfSize(14)
        
        skillLevelStaticDesc = UILabel.init(frame: CGRectMake(skillView.fwidth - 75, 5, 35, 17))
        skillLevelStaticDesc.text = "SLv."
        skillLevelStaticDesc.font = UIFont.systemFontOfSize(14)
        skillLevelStaticDesc.textAlignment = .Left
        skillLevelStaticDesc.textColor = UIColor.blackColor()
        
        skillLevelTF = UITextField.init(frame: CGRectMake(skillView.fwidth - 40, 0, 40, 27))
        skillLevelTF.borderStyle = .RoundedRect
        skillLevelTF.font = UIFont.systemFontOfSize(14)
        skillLevelTF.delegate = self
        skillLevelTF.textAlignment = .Right
        skillLevelTF.autocorrectionType = .No
        skillLevelTF.autocapitalizationType = .None
        skillLevelTF.autocapitalizationType = .None
        skillLevelTF.returnKeyType = .Done
        // 因为还不会给数字键盘加完成按钮 暂时采用这个键盘
        skillLevelTF.keyboardType = .NumbersAndPunctuation
        skillLevelTF.addTarget(self, action: #selector(levelFieldBegin), forControlEvents: .EditingDidBegin)
        skillLevelTF.addTarget(self, action: #selector(levelFieldDone), forControlEvents: .EditingDidEndOnExit)
        skillLevelTF.addTarget(self, action: #selector(levelFieldDone), forControlEvents: .EditingDidEnd)
        
        // originY += 16 + topSpace / 2
        
        skillDesc = UILabel.init(frame: CGRectMake(0, 26, skillView.fwidth, 0))
        skillDesc.numberOfLines = 0
        skillDesc.lineBreakMode = .ByCharWrapping
        skillDesc.font = UIFont.systemFontOfSize(12)
        skillDesc.textColor = UIColor.darkGrayColor()
        
        skillView.addSubview(skillStaticDesc)
        skillView.addSubview(skillLevelStaticDesc)
        skillView.addSubview(skillName)
        skillView.addSubview(skillLevelTF)
        skillView.addSubview(skillDesc)
        
        skillView.clipsToBounds = true
        contentView.addSubview(skillView)
        contentView.fheight = max(skillView.fy, icon.fheight + icon.fy)
        
    }
    
    // 当点击的位置是编辑技能等级的周围部分时 也触发编辑效果
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        if view == skillView {
            let newPoint = convertPoint(point, toView: skillView)
            if newPoint.x >= skillView.fwidth - 85 && newPoint.y <= 50 {
                return skillLevelTF
            }
        }
        return view
    }
    
    func prepareLeaderSkillView() {
        if leaderSkillView != nil {
            return
        }
        leaderSkillView = UIView.init(frame: CGRectMake(68, originY, CGSSGlobal.width - 78, 0))
        let leaderSkillStaticDesc = UILabel.init(frame: CGRectMake(0, 0, 65, 17))
        leaderSkillStaticDesc.text = "队长技能:"
        leaderSkillStaticDesc.font = UIFont.systemFontOfSize(14)
        leaderSkillStaticDesc.textAlignment = .Left
        leaderSkillStaticDesc.textColor = UIColor.blackColor()
        leaderSkillStaticDesc.sizeToFit()
        
        leaderSkillName = UILabel.init(frame: CGRectMake(leaderSkillStaticDesc.fwidth + 5, 0, leaderSkillView.fwidth - leaderSkillStaticDesc.fwidth - 5, 17))
        leaderSkillName.textColor = UIColor.blackColor()
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
    
    func setupSkillViewWith(skill: CGSSSkill?, skillLevel: Int?) {
        originY = cardName.fy + cardName.fheight + topSpace
        skillView.fy = originY
        if skill != nil {
            skillLevelTF.hidden = false
            skillLevelStaticDesc.hidden = false
            skillLevelTF.text = String(skillLevel!)
            skillName.text = skill!.skillName
            skillDesc.fwidth = skillView.fwidth
            skillDesc.text = skill!.getExplainByLevel(skillLevel!)
            skillDesc.sizeToFit()
        } else {
            skillLevelTF.hidden = true
            skillLevelStaticDesc.hidden = true
            skillName.text = "无"
            skillDesc.fheight = 0
        }
        
        skillView.fheight = skillDesc.fheight + skillDesc.fy
        originY += skillView.fheight + topSpace
    }
    
    func setupLeaderSkillViewWith(leaderSkill: CGSSLeaderSkill?) {
        leaderSkillView.fy = originY
        if leaderSkill != nil {
            leaderSkillName.text = leaderSkill!.name
            leaderSkillDesc.text = leaderSkill!.explainEn
            leaderSkillDesc.fwidth = leaderSkillView.fwidth
            leaderSkillDesc.sizeToFit()
        } else {
            leaderSkillName.text = "无"
            leaderSkillDesc.fheight = 0
        }
        leaderSkillView.fheight = leaderSkillDesc.fheight + leaderSkillDesc.fy
        originY += leaderSkillView.fheight + topSpace
    }
    func initWith(model: CGSSTeamMember, type: CGSSTeamMemberType) {
        let card = model.cardRef!
        self.icon.setWithCardId(card.id!)
        self.cardName.text = card.chara?.name
        originY = cardName.fy + cardName.fheight + topSpace
        skillView?.fheight = 0
        leaderSkillView?.fheight = 0
        switch type {
        case .Leader:
            self.prepareSkillView()
            self.setupSkillViewWith(card.skill, skillLevel: model.skillLevel)
            self.prepareLeaderSkillView()
            self.setupLeaderSkillViewWith(card.leaderSkill)
        case .Sub:
            self.prepareSkillView()
            self.setupSkillViewWith(card.skill, skillLevel: model.skillLevel)
        case .Friend:
            self.prepareLeaderSkillView()
            self.setupLeaderSkillViewWith(card.leaderSkill)
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
    func levelFieldBegin(sender: UITextField) {
        delegate?.skillLevelDidBeginEditing(self)
    }
    // 此方法同时处理did end on exit 和 editing did end
    func levelFieldDone(sender: UITextField) {
        skillLevelTF.resignFirstResponder()
        delegate?.skillLevelDidChange(self, lv: skillLevelTF.text!)
    }
}

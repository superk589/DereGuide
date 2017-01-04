//
//  TeamMemberTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/3.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol TeamMemberTableViewCellDelegate: class {
//    func skillLevelDidChange(_ cell: TeamMemberTableViewCell, lv: String)
//    func skillLevelDidBeginEditing(_ cell: TeamMemberTableViewCell)
    func beginEdit(cell: TeamMemberTableViewCell)
    func endEdit(cell: TeamMemberTableViewCell)
    func replaceMember(cell: TeamMemberTableViewCell)
}
class TeamMemberTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: TeamMemberTableViewCellDelegate?
    
    var skillView: UIView!
    var skillLevelTF: UITextField!
    var skillDesc: UILabel!
    var iconView: CGSSCardIconView!
    var title: UILabel!

    var replaceButton: UILabel!
    var editButton: UILabel!
    var potentialLabel: UILabel!
    
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
        
        let titleContentView = UIView.init(frame: CGRect.init(x: 0, y: originY, width: CGSSGlobal.width, height: 33))
        originY += topSpace

        title = UILabel.init(frame: CGRect(x: 10, y: originY, width: 48, height: 18))
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = UIColor.lightGray
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true
        
        replaceButton = UILabel.init(frame: CGRect.init(x: CGSSGlobal.width - 90, y: originY - 5, width: 80, height: 28))
        replaceButton.text = NSLocalizedString("替换", comment: "队伍编辑页面") + " >"
        replaceButton.isUserInteractionEnabled = false
        replaceButton.textAlignment = .right
        replaceButton.font = UIFont.systemFont(ofSize: 16)
        replaceButton.textColor = UIColor.lightGray
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(replaceMemeber))
        titleContentView.addGestureRecognizer(tap1)
        replaceButton.isHidden = true
        
        cardName = UILabel.init(frame: CGRect(x: 68, y: originY, width: CGSSGlobal.width - 138, height: 18))
        cardName.font = UIFont.systemFont(ofSize: 16)
        cardName.textAlignment = .left
        
        titleContentView.addSubview(title)
        titleContentView.addSubview(replaceButton)
        titleContentView.addSubview(cardName)
        
//        let detail = UILabel.init(frame: CGRect(x: CGSSGlobal.width - 22, y: originY, width: 12, height: 18))
//        detail.text = ">"
//        detail.font = UIFont.systemFont(ofSize: 16)
//        detail.textColor = UIColor.lightGray
        
        originY += 18
        
        //let potentialContentView = UIView.init(frame: CGRect(x: 48, y: originY, width: CGSSGlobal.width, height: 30))
        
        
        originY += topSpace
        iconView = CGSSCardIconView.init(frame: CGRect(x: 10, y: originY, width: 48, height: 48))
        
        potentialLabel = UILabel.init(frame: CGRect.init(x: 68, y: originY, width: CGSSGlobal.width - 138, height: 18))
        potentialLabel.font = UIFont.systemFont(ofSize: 14)
        potentialLabel.adjustsFontSizeToFitWidth = true
        
        
        editButton = UILabel.init(frame: CGRect.init(x: CGSSGlobal.width - 60, y: originY - 5, width: 50, height: 28))
        editButton.text = NSLocalizedString("编辑", comment: "队伍编辑页面")
        editButton.isUserInteractionEnabled = true
        editButton.textAlignment = .right
        editButton.font = UIFont.systemFont(ofSize: 16)
        editButton.textColor = UIColor.lightGray
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(editButtonClick))
        editButton.addGestureRecognizer(tap2)
        editButton.isHidden = true
        
        
        
        contentView.addSubview(titleContentView)
        contentView.addSubview(editButton)
        contentView.addSubview(potentialLabel)
        contentView.addSubview(iconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareSkillView() {
        if skillView != nil {
            return
        }
        
        skillView = UIView.init(frame: CGRect(x: 68, y: originY, width: CGSSGlobal.width - 78, height: 0))
        
        let skillStaticDesc = UILabel.init(frame: CGRect(x: 0, y: 5, width: 35, height: 17))
        skillStaticDesc.text = NSLocalizedString("特技", comment: "通用") + ":"
        skillStaticDesc.font = UIFont.systemFont(ofSize: 14)
        skillStaticDesc.textAlignment = .left
        skillStaticDesc.textColor = UIColor.black
        skillStaticDesc.sizeToFit()
        
        skillName = UILabel.init(frame: CGRect(x: skillStaticDesc.fwidth + 5, y: 5, width: skillView.fwidth - skillStaticDesc.fwidth - 85, height: 17))
        skillName.textColor = UIColor.black
        skillName.textAlignment = .left
        skillName.adjustsFontSizeToFitWidth = true
        skillName.font = UIFont.systemFont(ofSize: 14)
        
//        skillLevelStaticDesc = UILabel.init(frame: CGRect(x: skillView.fwidth - 75, y: 5, width: 35, height: 17))
//        skillLevelStaticDesc.text = "SLv."
//        skillLevelStaticDesc.font = UIFont.systemFont(ofSize: 14)
//        skillLevelStaticDesc.textAlignment = .left
//        skillLevelStaticDesc.textColor = UIColor.black
//        
//        skillLevelTF = UITextField.init(frame: CGRect(x: skillView.fwidth - 40, y: 0, width: 40, height: 27))
//        skillLevelTF.borderStyle = .roundedRect
//        skillLevelTF.font = UIFont.systemFont(ofSize: 14)
//        skillLevelTF.delegate = self
//        skillLevelTF.textAlignment = .right
//        skillLevelTF.autocorrectionType = .no
//        skillLevelTF.autocapitalizationType = .none
//        skillLevelTF.autocapitalizationType = .none
//        skillLevelTF.returnKeyType = .done
//        // 因为还不会给数字键盘加完成按钮 暂时采用这个键盘
//        skillLevelTF.keyboardType = .numbersAndPunctuation
//        skillLevelTF.addTarget(self, action: #selector(levelFieldBegin), for: .editingDidBegin)
//        skillLevelTF.addTarget(self, action: #selector(levelFieldDone), for: .editingDidEndOnExit)
//        skillLevelTF.addTarget(self, action: #selector(levelFieldDone), for: .editingDidEnd)
        
        skillDesc = UILabel.init(frame: CGRect(x: 0, y: 26, width: skillView.fwidth, height: 0))
        skillDesc.numberOfLines = 0
        skillDesc.lineBreakMode = .byCharWrapping
        skillDesc.font = UIFont.systemFont(ofSize: 12)
        skillDesc.textColor = UIColor.darkGray
        
        skillView.addSubview(skillStaticDesc)
        //skillView.addSubview(skillLevelStaticDesc)
        skillView.addSubview(skillName)
        //skillView.addSubview(skillLevelTF)
        skillView.addSubview(skillDesc)
        
        skillView.clipsToBounds = true
        contentView.addSubview(skillView)
    }
    
//    // 当点击的位置是编辑技能等级的周围部分时 也触发编辑效果
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super.hitTest(point, with: event)
//        if view == nil {
//            return nil
//        }
//        if let sView = skillView , view == sView && !skillLevelTF.isHidden {
//            let newPoint = convert(point, to: sView)
//            if newPoint.x >= sView.fwidth - 85 && newPoint.y <= 50 {
//                return skillLevelTF
//            }
//        }
//        return view
//    }
    
    func prepareLeaderSkillView() {
        if leaderSkillView != nil {
            return
        }
        leaderSkillView = UIView.init(frame: CGRect(x: 68, y: originY, width: CGSSGlobal.width - 78, height: 0))
        let leaderSkillStaticDesc = UILabel.init(frame: CGRect(x: 0, y: 5, width: 65, height: 17))
        leaderSkillStaticDesc.text = NSLocalizedString("队长技能", comment: "通用") + ":"
        leaderSkillStaticDesc.font = UIFont.systemFont(ofSize: 14)
        leaderSkillStaticDesc.textAlignment = .left
        leaderSkillStaticDesc.textColor = UIColor.black
        leaderSkillStaticDesc.sizeToFit()
        
        leaderSkillName = UILabel.init(frame: CGRect(x: leaderSkillStaticDesc.fwidth + 5, y: 5, width: leaderSkillView.fwidth - leaderSkillStaticDesc.fwidth - 5, height: 17))
        leaderSkillName.textColor = UIColor.black
        leaderSkillName.textAlignment = .left
        leaderSkillName.font = UIFont.systemFont(ofSize: 14)
        
        leaderSkillDesc = UILabel.init(frame: CGRect(x: 0, y: 26, width: leaderSkillView.fwidth, height: 0))
        leaderSkillDesc.numberOfLines = 0
        leaderSkillDesc.lineBreakMode = .byCharWrapping
        leaderSkillDesc.font = UIFont.systemFont(ofSize: 12)
        leaderSkillDesc.textColor = UIColor.darkGray
        
        leaderSkillView.addSubview(leaderSkillStaticDesc)
        leaderSkillView.addSubview(leaderSkillName)
        leaderSkillView.addSubview(leaderSkillDesc)
        leaderSkillView.clipsToBounds = true
        
        contentView.addSubview(leaderSkillView)
    }
    
    func setupSkillViewWith(_ skill: CGSSSkill?, skillLevel: Int?) {
        originY = potentialLabel.fy + potentialLabel.fheight + 5
        skillView.fy = originY
        if skill != nil {
            //skillLevelTF.isHidden = false
            //skillLevelStaticDesc.isHidden = false
            //skillLevelTF.text = String(skillLevel!)
            skillName.text = skill!.skillName
            skillDesc.fwidth = skillView.fwidth
            skillDesc.text = skill!.getExplainByLevel(skillLevel!, languageType: CGSSGlobal.languageType)
            skillDesc.sizeToFit()
            skillView.fheight = skillDesc.fheight + skillDesc.fy
        } else {
            //skillLevelTF.isHidden = true
            //skillLevelStaticDesc.isHidden = true
            skillName.text = NSLocalizedString("无", comment: "空字符串说明文字")
            skillDesc.fheight = 0
            skillView.fheight = skillName.fheight + skillName.fy
        }
        originY += skillView.fheight + topSpace
    }
    
    func setupLeaderSkillViewWith(_ leaderSkill: CGSSLeaderSkill?) {
        if skillView != nil {
            originY = originY - 5
        }
        leaderSkillView.fy = originY
        if leaderSkill != nil {
            leaderSkillName.text = leaderSkill!.name
            leaderSkillDesc.text = leaderSkill!.getLocalizedExplain(languageType: CGSSGlobal.languageType)
            leaderSkillDesc.fwidth = leaderSkillView.fwidth
            leaderSkillDesc.sizeToFit()
            leaderSkillView.fheight = leaderSkillDesc.fheight + leaderSkillDesc.fy
        } else {
            leaderSkillName.text = NSLocalizedString("无", comment: "")
            leaderSkillDesc.fheight = 0
            leaderSkillView.fheight = leaderSkillName.fheight + leaderSkillName.fy
        }
        originY += leaderSkillView.fheight + topSpace
    }
    func initWith(_ model: CGSSTeamMember, type: CGSSTeamMemberType) {
        let card = model.cardRef!
        self.iconView.setWithCardId(card.id!)
        self.cardName.text = card.chara?.name
        var strSkill:NSAttributedString
        if  card.skill != nil && type != .friend {
            strSkill = NSAttributedString.init(string: "\(NSLocalizedString("特技等级", comment: "队伍编辑页面")): \(model.skillLevel!)  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:Color.allType])
        } else {
            strSkill = NSAttributedString.init(string: "\(NSLocalizedString("特技等级", comment: "队伍编辑页面")): n/a  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:Color.allType])
        }
        let strVocal = NSAttributedString.init(string: "Vo: +\(model.vocalLevel!)  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:Color.vocal])
        let strDance = NSAttributedString.init(string: "Da: +\(model.danceLevel!)  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:Color.dance])
        let strVisual = NSAttributedString.init(string: "Vi: +\(model.visualLevel!)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:Color.visual])
    
        let att = NSMutableAttributedString.init(attributedString: strSkill)
        att.append(strVocal)
        att.append(strDance)
        att.append(strVisual)
        
        potentialLabel.attributedText = att
        
        replaceButton.isHidden = false
        editButton.isHidden = false
        
        
        originY = potentialLabel.fy + potentialLabel.fheight + 5
        skillView?.fheight = 0
        leaderSkillView?.fheight = 0
        switch type {
        case .leader:
            self.prepareSkillView()
            self.setupSkillViewWith(card.skill, skillLevel: model.skillLevel)
            self.prepareLeaderSkillView()
            self.setupLeaderSkillViewWith(card.leaderSkill)
        case .sub:
            self.prepareSkillView()
            self.setupSkillViewWith(card.skill, skillLevel: model.skillLevel)
        case .friend:
            self.prepareLeaderSkillView()
            self.setupLeaderSkillViewWith(card.leaderSkill)
        }
        contentView.fheight = max(originY, iconView.fheight + iconView.fy + topSpace)
        // print(contentView.fheight)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    // 如果通过协议方法实现结束时的回调 会导致按键盘的return键时 调用了两次skillLevelDidChange回调, 故此处不采用这个方法
//    func textFieldDidEndEditing(textField: UITextField) {
//        delegate?.skillLevelDidChange(self, lv: skilllevel.text!)
//        print("aaa")
//    }
//    func levelFieldBegin(_ sender: UITextField) {
//        delegate?.skillLevelDidBeginEditing(self)
//    }
//    // 此方法同时处理did end on exit 和 editing did end
//    func levelFieldDone(_ sender: UITextField) {
//        skillLevelTF.resignFirstResponder()
//        delegate?.skillLevelDidChange(self, lv: skillLevelTF.text!)
//    }
    
    func editButtonClick() {
        delegate?.beginEdit(cell: self)
    }
    
    func replaceMemeber() {
        delegate?.replaceMember(cell: self)
    }
    
}

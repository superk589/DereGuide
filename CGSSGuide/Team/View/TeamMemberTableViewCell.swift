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
class TeamMemberTableViewCell: UITableViewCell, UITextFieldDelegate {

    var delegate:TeamMemberTableViewCellDelegate?
    @IBOutlet weak var detail: UIView! {
        didSet {
            detail.hidden = true
        }
    }
    @IBOutlet weak var skilllevel: UITextField! {
        didSet {
            skilllevel.delegate = self
        }
    }
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
        if model.cardRef?.skill?.explain_en != nil {
            self.skillDesc.text = model.cardRef?.skill?.getExplainByLevel(model.skillLevel!)
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
    }
    
    //如果通过协议方法实现结束时的回调 会导致按键盘的return键时 调用了两次skillLevelDidChange回调, 故此处不采用这个方法
//    func textFieldDidEndEditing(textField: UITextField) {
//        delegate?.skillLevelDidChange(self, lv: skilllevel.text!)
//        print("aaa")
//    }
    @IBAction func levelFieldBegin(sender: UITextField) {
        delegate?.skillLevelDidBeginEditing(self)
    }
    //此方法同时处理did end on exit 和 editing did end
    @IBAction func levelFieldDone(sender: UITextField) {
        skilllevel.resignFirstResponder()
        delegate?.skillLevelDidChange(self, lv: skilllevel.text!)
    }
}

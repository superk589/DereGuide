//
//  TeamMemberTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/3.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var detail: UIView! {
        didSet {
            detail.hidden = true
        }
    }
    @IBOutlet weak var skilllevel: UITextField! {
        didSet {
            skilllevel.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
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

    
    func initWith(model:CGSSTeamMember) {
        self.skilllevel.text = "10"
        self.skillDesc.text = model.cardRef?.skill?.explain_en
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
    
}

//
//  CardDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CGSSFoundation

class CardDetailViewController: UIViewController {
    
    var card:CGSSCard!
    
    @IBOutlet weak var fullImage: UIImageView!

    @IBOutlet weak var cardIcon: UIImageView!
    
    @IBOutlet weak var cardName: UILabel!
    
    @IBOutlet weak var life: UILabel!
    
    @IBOutlet weak var vocal: UILabel!
    
    @IBOutlet weak var dance: UILabel!
    
    @IBOutlet weak var visual: UILabel!
    
    @IBOutlet weak var overAll: UILabel!
    
    @IBOutlet weak var leaderSkillInfo: UILabel!
    
    @IBOutlet weak var skillInfo: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //显示大图
        if card.has_spread! {
            //let path = NSBundle.mainBundle().resourcePath! + "/fullImage/" + String(card.id!) + "_spread.png"
            //if let image = UIImage.init(named: String(card.id!) + "_spread.png" ) {
            
            if let image = UIImage.init(named: "200248" +  "_spread.png") {
                self.fullImage.image = image

            }
            
        }
        let dao = CGSSDAO.sharedDAO
        
        if let name = card.name {
            self.cardName.text = name
        }
        
        
        
        let cardIcon = dao.cardIconDict!.objectForKey(String(card.id!)) as! CGSSCardIcon
        
        let iconFile = cardIcon.file_name!
        
        
        let image = UIImage(named: iconFile)
        let cgRef = image!.CGImage
        let iconRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(96 * CGFloat(cardIcon.col!), 96 * CGFloat(cardIcon.row!) as CGFloat, 96, 96))
        let icon = UIImage.init(CGImage: iconRef!)
        self.cardIcon.image = icon
        
        //边角圆滑处理
        self.cardIcon.layer.cornerRadius = 4
        self.cardIcon.layer.masksToBounds = true
        
        //textLabel?.text = self.cardList[row] as? String
        
        //显示数值
        if let life = card.hp_max, let bonus = card.bonus_hp {
            self.life.text = String(life + bonus)
        }
        if let vocal = card.vocal_max, let bonus = card.bonus_vocal {
            self.vocal.text = String(vocal + bonus)
        }
        if let dance = card.dance_max, let bonus = card.bonus_dance {
            self.dance.text = String(dance + bonus)
        }
        if let visual = card.visual_max, let bonus = card.bonus_visual {
            self.visual.text = String(visual + bonus)
        }
        if let overall = card.overall_max, let bonus = card.overall_bonus {
            self.overAll.text = String(overall + bonus)
        }
        
        let leaderSkill = dao.findLeaderSkillById(card.leader_skill_id!)
        let skill = dao.findSkillById(card.skill_id!)
        
        if let ls = leaderSkill {
            self.leaderSkillInfo.text = ls.name! + ": " + ls.explain_en!
        }
        
        if let s = skill {
            self.skillInfo.text = s.skill_name! + ": " + s.explain_en!
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

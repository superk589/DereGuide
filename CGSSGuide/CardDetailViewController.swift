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
    var cardDV:CardDetailView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardDV = CardDetailView()
        
        self.automaticallyAdjustsScrollViewInsets = true
        view.addSubview(cardDV!)

        let titleView = UILabel.init(frame: CGRectMake(0, 0, 360, 44))
        titleView.text = card.name
        titleView.font = UIFont.systemFontOfSize(12)
        titleView.textAlignment = .Center
        navigationItem.titleView = titleView

        let rightItem = UIBarButtonItem.init(title: "收藏", style: .Plain, target: self, action: #selector(addFavorite))
        navigationItem.rightBarButtonItem = rightItem
        
        let leftItem = UIBarButtonItem.init(title: "返回", style: .Plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = leftItem
        
        if card.has_spread! {
            //使用非常驻的方式读取大图
            cardDV?.fullImageView?.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("200248_spread", ofType: "png")!)
        }
        else {
            cardDV?.setWithoutSpreadImage()
        }
        
        cardDV?.cardNameLabel.text = card.name_only! + "  " + (card.chara?.conventional)!
        cardDV?.titleLabel.text = card.title
        cardDV?.rarityLabel.text = card.rarity?.rarityString
        
        let dao = CGSSDAO.sharedDAO
        let cardIcon = dao.cardIconDict!.objectForKey(String(card.id!)) as! CGSSCardIcon
        let iconFile = cardIcon.file_name!
        let image = UIImage(named: iconFile)
        let cgRef = image!.CGImage
        let iconRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(96 * CGFloat(cardIcon.col!), 96 * CGFloat(cardIcon.row!) as CGFloat, 96, 96))
        let icon = UIImage.init(CGImage: iconRef!)
        cardDV?.cardIconView?.image = icon
        
        //边角圆滑处理
        cardDV?.cardIconView?.layer.cornerRadius = 6
        cardDV?.cardIconView?.layer.masksToBounds = true
        

        //设置属性列表
        var attGridStrings = [[String]]()
        attGridStrings.append(["  ", "HP", "Vocal", "Dance", "Visual", "Total"])
        attGridStrings.append(["Lv.1", String(card.hp_min!), String(card.vocal_min!), String(card.dance_min!), String(card.visual_min!), String(card.overall_min!)])
        attGridStrings.append(["Lv.\(card.rarity!.base_max_level)", String(card.hp_max!), String(card.vocal_max!), String(card.dance_max!), String(card.visual_max!), String(card.overall_max!)])
        attGridStrings.append(["Bonus", String(card.bonus_hp!), String(card.bonus_vocal!), String(card.bonus_dance!), String(card.bonus_visual!), String(card.overall_bonus!) ])
        attGridStrings.append(["Overall", String(card.life), String(card.vocal), String(card.dance), String(card.visual), String(card.overall)])

        cardDV?.attGridView.setGridContent(attGridStrings)
        
        var colors = [[UIColor]]()
       
        let colorArray = [UIColor.blackColor(),CGSSTool.lifeColor,CGSSTool.vocalColor,CGSSTool.danceColor,CGSSTool.visualColor, UIColor.blackColor().colorWithAlphaComponent(0.5)]
        colors.append(Array.init(count: 6, repeatedValue: UIColor.blackColor()))
        colors.append(colorArray)
        colors.append(colorArray)
        colors.append(colorArray)
        colors.append(colorArray)
        cardDV?.attGridView.setGridColor(colors)
        
        
        //设置属性排名列表
        var rankGridStrings = [[String]]()
        let rankInType = dao.getRankInType(card)
        let rankInAll = dao.getRankInAll(card)
        rankGridStrings.append(["  ", "Vocal", "Dance", "Visual", "Total"])
        rankGridStrings.append(["In \(card.attribute)", "#\(rankInType[0])", "#\(rankInType[1])", "#\(rankInType[2])", "#\(rankInType[3])"])
        rankGridStrings.append(["In all", "#\(rankInAll[0])", "#\(rankInAll[1])", "#\(rankInAll[2])", "#\(rankInAll[3])"])
        cardDV?.rankGridView.setGridContent(rankGridStrings)
        
        //设置主动技能
        if let skill = card.skill {
            cardDV?.setSkillContentView()
            cardDV?.skillNameLabel.text = skill.skill_name
            cardDV?.skillDescriptionLabel.text = skill.explain_en
            var procGridStrings = [[String]]()
            let procChanceMax = Double((skill.proc_chance?.1)!) / 100
            let procChanceMin = Double((skill.proc_chance?.0)!) / 100
            let durationMax = Double((skill.effect_length?.1)!) / 100
            let durationMin = Double((skill.effect_length?.0)!) / 100
            procGridStrings.append(["  ","触发几率%","持续时间s","最大覆盖率%","平均覆盖率%"])
            procGridStrings.append(["Lv.1",String(format: "%.2f", procChanceMin), String(format: "%.2f",durationMin)
                ,String(format:"%.2f", durationMin/Double(skill.condition!)*100),String(format:"%.2f", durationMin/Double(skill.condition!)*procChanceMin)])
            procGridStrings.append(["Lv.10",String(format: "%.2f",procChanceMax), String(format: "%.2f", durationMax)
                ,String(format:"%.2f", durationMax/Double(skill.condition!)*100),String(format:"%.2f", durationMax/Double(skill.condition!)*procChanceMax)])
            cardDV?.skillProcGridView.setGridContent(procGridStrings)
        }
        
        
    }
    func addFavorite() {
        //todo
    }
    func backAction() {
        //使用自定义动画返回
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionReveal
        navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
        navigationController?.popViewControllerAnimated(false)
    }
//        if let name = card.name {
//            self.cardName.text = name
//        }
//        
//        
//        
//        let cardIcon = dao.cardIconDict!.objectForKey(String(card.id!)) as! CGSSCardIcon
//        
//        let iconFile = cardIcon.file_name!
//        
//        
//        let image = UIImage(named: iconFile)
//        let cgRef = image!.CGImage
//        let iconRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(96 * CGFloat(cardIcon.col!), 96 * CGFloat(cardIcon.row!) as CGFloat, 96, 96))
//        let icon = UIImage.init(CGImage: iconRef!)
//        self.cardIcon.image = icon
//        
//        //边角圆滑处理
//        self.cardIcon.layer.cornerRadius = 4
//        self.cardIcon.layer.masksToBounds = true
//        
//        //textLabel?.text = self.cardList[row] as? String
//        
//        //显示数值
//        if let life = card.hp_max, let bonus = card.bonus_hp {
//            self.life.text = String(life + bonus)
//        }
//        if let vocal = card.vocal_max, let bonus = card.bonus_vocal {
//            self.vocal.text = String(vocal + bonus)
//        }
//        if let dance = card.dance_max, let bonus = card.bonus_dance {
//            self.dance.text = String(dance + bonus)
//        }
//        if let visual = card.visual_max, let bonus = card.bonus_visual {
//            self.visual.text = String(visual + bonus)
//        }
//        if let overall = card.overall_max, let bonus = card.overall_bonus {
//            self.overAll.text = String(overall + bonus)
//        }
//        
//        let leaderSkill = dao.findLeaderSkillById(card.leader_skill_id!)
//        let skill = dao.findSkillById(card.skill_id!)
//        
//        if let ls = leaderSkill {
//            self.leaderSkillInfo.text = ls.name! + ": " + ls.explain_en!
//        }
//        
//        if let s = skill {
//            self.skillInfo.text = s.skill_name! + ": " + s.explain_en!
//        }
//        
//        
//        

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

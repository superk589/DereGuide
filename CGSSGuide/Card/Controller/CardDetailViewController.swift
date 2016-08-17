//
//  CardDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController {
    
    var card: CGSSCard!
    var cardDV: CardDetailView?
    
    var fullScreenView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色为白色 防止导航动画时效果卡顿
        view.backgroundColor = UIColor.whiteColor()
        // 设置全屏视图 用于显示放大图片
        fullScreenView = UIView()
        fullScreenView?.frame = UIScreen.mainScreen().bounds
        view.addSubview(fullScreenView!)
        
        cardDV = CardDetailView()
        cardDV?.fullImageView?.delegate = self
        // 关闭自动躲避导航栏
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(cardDV!)
        
        // 自定义titleView的文字大小
        let titleView = UILabel.init(frame: CGRectMake(0, 0, 0, 44))
        titleView.text = card.name
        titleView.font = UIFont.systemFontOfSize(12)
        titleView.textAlignment = .Center
        navigationItem.titleView = titleView
        
        // let rightItem = UIBarButtonItem.init(title: CGSSFavoriteManager.defaultManager.contains(card.id!) ? "取消":"收藏", style: .Plain, target: self, action: #selector(addOrRemoveFavorite))
        let rightItem = UIBarButtonItem.init(image: CGSSFavoriteManager.defaultManager.contains(card.id!) ? UIImage.init(named: "748-heart-toolbar-selected") : UIImage.init(named: "748-heart-toolbar"), style: .Plain, target: self, action: #selector(addOrRemoveFavorite))
        rightItem.tintColor = UIColor.redColor()
        navigationItem.rightBarButtonItem = rightItem
        
        // let leftItem = UIBarButtonItem.init(title: "返回", style: .Plain, target: self, action: #selector(backAction))
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .Plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = leftItem
        
        if card.has_spread! {
            cardDV?.fullImageView?.setIndicator()
            cardDV?.fullImageView?.setCustomImageWithURL(NSURL(string: card.spread_image_ref!)!)
        } else {
            cardDV?.setWithoutSpreadImage()
        }
        
        cardDV?.cardNameLabel.text = card.name_only! + "  " + (card.chara?.conventional)!
        cardDV?.titleLabel.text = card.title
        cardDV?.rarityLabel.text = card.rarity?.rarityString
        
        let dao = CGSSDAO.sharedDAO
        cardDV?.cardIconView?.setWithCardId(card.id!)
        
        // 设置属性列表
        var attGridStrings = [[String]]()
        attGridStrings.append(["  ", "HP", "Vocal", "Dance", "Visual", "Total"])
        attGridStrings.append(["Lv.1", String(card.hp_min!), String(card.vocal_min!), String(card.dance_min!), String(card.visual_min!), String(card.overall_min!)])
        attGridStrings.append(["Lv.\(card.rarity!.base_max_level)", String(card.hp_max!), String(card.vocal_max!), String(card.dance_max!), String(card.visual_max!), String(card.overall_max!)])
        attGridStrings.append(["Bonus", String(card.bonus_hp!), String(card.bonus_vocal!), String(card.bonus_dance!), String(card.bonus_visual!), String(card.overall_bonus!)])
        attGridStrings.append(["Total", String(card.life), String(card.vocal), String(card.dance), String(card.visual), String(card.overall)])
        
        cardDV?.attGridView.setGridContent(attGridStrings)
        
        var colors = [[UIColor]]()
        
        let colorArray = [CGSSTool.allTypeColor, CGSSTool.lifeColor, CGSSTool.vocalColor, CGSSTool.danceColor, CGSSTool.visualColor, CGSSTool.allTypeColor]
        colors.append(colorArray)
        colors.append(colorArray)
        colors.append(colorArray)
        colors.append(colorArray)
        colors.append(colorArray)
        cardDV?.attGridView.setGridColor(colors)
        
        // 设置属性排名列表
        var rankGridStrings = [[String]]()
        let rankInType = dao.getRankInType(card)
        let rankInAll = dao.getRankInAll(card)
        rankGridStrings.append(["  ", "Vocal", "Dance", "Visual", "Total"])
        rankGridStrings.append(["In \(card.attShort)", "#\(rankInType[0])", "#\(rankInType[1])", "#\(rankInType[2])", "#\(rankInType[3])"])
        rankGridStrings.append(["In All", "#\(rankInAll[0])", "#\(rankInAll[1])", "#\(rankInAll[2])", "#\(rankInAll[3])"])
        cardDV?.rankGridView.setGridContent(rankGridStrings)
        
        var colors2 = [[UIColor]]()
        let colorArray2 = [card.attColor, CGSSTool.vocalColor, CGSSTool.danceColor, CGSSTool.visualColor, CGSSTool.allTypeColor]
        let colorArray3 = [CGSSTool.allTypeColor, CGSSTool.vocalColor, CGSSTool.danceColor, CGSSTool.visualColor, CGSSTool.allTypeColor]
        
        colors2.append(colorArray3)
        colors2.append(colorArray2)
        colors2.append(colorArray3)
        cardDV?.rankGridView.setGridColor(colors2)
        
        // 设置主动技能
        if let skill = card.skill {
            cardDV?.setSkillContentView(skill)
        }
        
        // 设置队长技能
        if let leaderSkill = card.leader_skill {
            cardDV?.setLeaderSkillContentView(leaderSkill)
        }
        
        // 设置进化信息
        if let evolution_id = card.evolution_id where evolution_id > 0 {
            cardDV?.setEvolutionContentView()
            cardDV?.evolutionFromImageView.setWithCardId(card.id!)
            cardDV?.evolutionToImageView.setWithCardId(card.evolution_id!, target: self, action: #selector(iconClick))
        }
        
        // 设置角色信息
        
        // 设置技能升级信息
        
        // 设置推荐组队信息
        
        // 设置出售价格
        
        // 设置饲料经验信息
        
    }
    
    // 添加当前卡到收藏
    func addOrRemoveFavorite() {
        let fm = CGSSFavoriteManager.defaultManager
        if !fm.contains(card.id!) {
            fm.addFavoriteCard(self.card, callBack: { (s) in
                self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar-selected")
            })
        } else {
            fm.removeFavoriteCard(self.card, callBack: { (s) in
                self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar")
            })
        }
        
    }
    func backAction() {
        if navigationController?.viewControllers.count > 2 {
            navigationController?.popViewControllerAnimated(true)
        } else {
            // 当返回列表页时为了搜索栏显示效果(使用默认的动画 会出现闪烁) 只能使用自定义动画返回
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionReveal
            navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
            navigationController?.popViewControllerAnimated(false)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    // 保存成功的回调方法
    func imageDidFinishingSaving(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        
        let alVC = UIAlertController(title: didFinishSavingWithError?.localizedFailureReason ?? "保存成功", message: nil, preferredStyle: .Alert)
        alVC.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
        presentViewController(alVC, animated: true, completion: nil)
    }
    
    // 点击卡片小图标时的响应方法
    func iconClick(iv: CGSSCardIconView) {
        let cardDetailVC = CardDetailViewController()
        let dao = CGSSDAO.sharedDAO
        cardDetailVC.card = dao.findCardById(iv.cardId!)
        cardDetailVC.modalTransitionStyle = .CoverVertical
        self.navigationController?.pushViewController(cardDetailVC, animated: true)
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

extension CardDetailViewController: CGSSImageViewDelegate {
    func beginRestore() {
        self.cardDV?.addSubview((self.cardDV?.fullImageView)!)
        self.view.sendSubviewToBack(fullScreenView!)
        self.cardDV?.fullImageView?.frame.origin.y = -64 + (self.cardDV?.contentOffset.y)!
        UIView.animateWithDuration(0.3) {
            self.cardDV?.fullImageView?.frame.origin.y = 0
            self.navigationController?.navigationBar.alpha = 1
            self.tabBarController?.tabBar.alpha = 1
        }
        // self.navigationController?.setNavigationBarHidden(false, animated: true)
        // self.tabBarController?.tabBar.hidden = false
        
        // self.cardDV?.backgroundColor = UIColor.whiteColor()
    }
    func endRestore() {
        
    }
    func beginFullSize() {
        // 置于顶层 覆盖一切
        // UIApplication.sharedApplication().keyWindow?.addSubview((self.cardDV?.fullImageView)!)
        self.fullScreenView?.bounds.origin.y = -64 + (self.cardDV?.contentOffset.y)!
        self.fullScreenView?.addSubview((self.cardDV?.fullImageView)!)
        UIView.animateWithDuration(0.3) {
            self.fullScreenView?.bounds.origin.y = 0
            self.navigationController?.navigationBar.alpha = 0
            self.tabBarController?.tabBar.alpha = 0
        }
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
        // self.tabBarController?.tabBar.hidden = true
        
        self.view.bringSubviewToFront(fullScreenView!)
        // self.navigationController?.setToolbarHidden(true, animated: true)
        
        // let vc = UIViewController()
        // self.modalTransitionStyle = .CoverVertical
        // presentViewController(vc, animated: true, completion: nil)
        // vc.view.addSubview((self.cardDV?.fullImageView)!)
        
        // self.tabBarController?.tabBar.hidden = true
        // self.navigationController?.navigationBar.hidden = true
        // self.automaticallyAdjustsScrollViewInsets = false
        // self.cardDV?.scrollEnabled = false
        // self.cardDV?.contentOffset = CGPointMake(0, -64)
        // self.cardDV?.backgroundColor = UIColor.blackColor()
        
    }
    func endFullSize() {
        
    }
    func longPress() {
        // 长按实现更多操作 保存/分享等
        let alVC = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alVC.addAction(UIAlertAction.init(title: "保存", style: .Default, handler: { (_: UIAlertAction) in
            UIImageWriteToSavedPhotosAlbum((self.cardDV?.fullImageView?.image)!, self, #selector(self.imageDidFinishingSaving), nil)
            }))
        // alVC.addAction(UIAlertAction.init(title: "分享", style: .Default, handler: { (_:UIAlertAction) in
        // //todo
        // }))
        alVC.addAction(UIAlertAction.init(title: "取消", style: .Cancel, handler: { (_: UIAlertAction) in
            // todo
            }))
        
        presentViewController(alVC, animated: true, completion: nil)
        
    }
}

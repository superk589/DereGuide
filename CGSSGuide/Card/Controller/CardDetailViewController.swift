//
//  CardDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController, CardDetailViewDelegate {
    
    var card: CGSSCard!
    var cardDV: CardDetailView!
    var sv: UIScrollView!
    var fullScreenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sv = UIScrollView.init(frame: CGRectMake(0, 64, CGSSGlobal.width, CGSSGlobal.height - 64))
        
        // 设置背景颜色为白色 防止导航动画时效果卡顿
        view.backgroundColor = UIColor.whiteColor()
        // 设置全屏视图 用于显示放大图片
        fullScreenView = UIView()
        fullScreenView?.frame = UIScreen.mainScreen().bounds
        view.addSubview(fullScreenView!)
        view.addSubview(sv)
        
        cardDV = CardDetailView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 0))
        cardDV.delegate = self
        cardDV.fullImageView?.delegate = self
        // 关闭自动躲避导航栏
        self.automaticallyAdjustsScrollViewInsets = false
        sv.addSubview(cardDV!)
        
        // 自定义titleView的文字大小
        let titleView = UILabel.init(frame: CGRectMake(0, 0, 0, 44))
        titleView.text = card.name
        titleView.font = UIFont.systemFontOfSize(12)
        titleView.textAlignment = .Center
        titleView.adjustsFontSizeToFitWidth = true
        navigationItem.titleView = titleView
        
        // let rightItem = UIBarButtonItem.init(title: CGSSFavoriteManager.defaultManager.contains(card.id!) ? "取消":"收藏", style: .Plain, target: self, action: #selector(addOrRemoveFavorite))
        let rightItem = UIBarButtonItem.init(image: CGSSFavoriteManager.defaultManager.contains(card.id!) ? UIImage.init(named: "748-heart-toolbar-selected") : UIImage.init(named: "748-heart-toolbar"), style: .Plain, target: self, action: #selector(addOrRemoveFavorite))
        rightItem.tintColor = UIColor.redColor()
        navigationItem.rightBarButtonItem = rightItem
        
        // let leftItem = UIBarButtonItem.init(title: "返回", style: .Plain, target: self, action: #selector(backAction))
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .Plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = leftItem
        
        cardDV.initWith(card)
        sv.contentSize = cardDV.frame.size
        
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
        navigationController?.popViewControllerAnimated(true)
        /*if navigationController?.viewControllers.count > 2 {
         navigationController?.popViewControllerAnimated(true)
         } else {
         // 当返回列表页时为了搜索栏显示效果(使用默认的动画 会出现闪烁) 只能使用自定义动画返回
         let transition = CATransition()
         transition.duration = 0.3
         transition.type = kCATransitionReveal
         navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
         navigationController?.popViewControllerAnimated(false)
         }*/
        
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
        // cardDetailVC.modalTransitionStyle = .CoverVertical
        self.navigationController?.pushViewController(cardDetailVC, animated: true)
    }
    
    func charInfoClick() {
        let charDetailVC = CharDetailViewController()
        charDetailVC.char = card.chara
        self.navigationController?.pushViewController(charDetailVC, animated: true)
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
    func beginRestore(iv: CGSSImageView) {
        self.cardDV?.addSubview(iv)
        self.view.sendSubviewToBack(fullScreenView!)
        iv.frame.origin.y = -64 + (self.sv.contentOffset.y)
        
        UIView.animateWithDuration(0.25) {
            UIApplication.sharedApplication().statusBarHidden = false
            iv.frame.origin.y = 0
            self.navigationController?.navigationBar.alpha = 1
            self.tabBarController?.tabBar.alpha = 1
        }
        // self.navigationController?.setNavigationBarHidden(false, animated: true)
        // self.tabBarController?.tabBar.hidden = false
        
        // self.cardDV?.backgroundColor = UIColor.whiteColor()
    }
    func endRestore(iv: CGSSImageView) {
        
    }
    func beginFullSize(iv: CGSSImageView) {
        // 置于顶层 覆盖一切
        // UIApplication.sharedApplication().keyWindow?.addSubview((iv)!)
        self.fullScreenView?.bounds.origin.y = -64 + (self.sv.contentOffset.y)
        self.fullScreenView?.addSubview(iv)
        
        UIView.animateWithDuration(0.25) {
            UIApplication.sharedApplication().statusBarHidden = true
            self.navigationController?.navigationBar.alpha = 0
            self.tabBarController?.tabBar.alpha = 0
            self.fullScreenView?.bounds.origin.y = 0
        }
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
        // self.tabBarController?.tabBar.hidden = true
        
        self.view.bringSubviewToFront(fullScreenView!)
        // self.navigationController?.setToolbarHidden(true, animated: true)
        
        // let vc = UIViewController()
        // self.modalTransitionStyle = .CoverVertical
        // presentViewController(vc, animated: true, completion: nil)
        // vc.view.addSubview((iv)!)
        
        // self.tabBarController?.tabBar.hidden = true
        // self.navigationController?.navigationBar.hidden = true
        // self.automaticallyAdjustsScrollViewInsets = false
        // self.cardDV?.scrollEnabled = false
        // self.cardDV?.contentOffset = CGPointMake(0, -64)
        // self.cardDV?.backgroundColor = UIColor.blackColor()
        
    }
    func endFullSize(iv: CGSSImageView) {
        
    }
    func longPress(press: UILongPressGestureRecognizer, iv: CGSSImageView) {
        // 长按实现更多操作 保存/分享等
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let location = press.locationInView(fullScreenView)
        alert.popoverPresentationController?.sourceView = fullScreenView
        alert.popoverPresentationController?.sourceRect = CGRectMake(location.x, location.y, 0, 0)
        alert.addAction(UIAlertAction.init(title: "保存到相册", style: .Default, handler: { (_: UIAlertAction) in
            if let image = iv.image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageDidFinishingSaving), nil)
            }
            }))
        // alVC.addAction(UIAlertAction.init(title: "分享", style: .Default, handler: { (_:UIAlertAction) in
        // //todo
        // }))
        alert.addAction(UIAlertAction.init(title: "取消", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        
    }
}

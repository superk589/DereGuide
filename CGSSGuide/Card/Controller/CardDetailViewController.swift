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
        sv = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: CGSSGlobal.width, height: CGSSGlobal.height - 64))
        
        // 设置背景颜色为白色 防止导航动画时效果卡顿
        view.backgroundColor = UIColor.white
        // 设置全屏视图 用于显示放大图片
        fullScreenView = UIView()
        fullScreenView?.frame = UIScreen.main.bounds
        view.addSubview(fullScreenView!)
        view.addSubview(sv)
        
        cardDV = CardDetailView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        cardDV.delegate = self
        cardDV.fullImageView?.delegate = self
        // 关闭自动躲避导航栏
        self.automaticallyAdjustsScrollViewInsets = false
        sv.addSubview(cardDV!)
        
        // 自定义titleView的文字大小
        let titleView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        titleView.text = card.name
        titleView.font = UIFont.systemFont(ofSize: 12)
        titleView.textAlignment = .center
        titleView.adjustsFontSizeToFitWidth = true
        navigationItem.titleView = titleView
        
        // let rightItem = UIBarButtonItem.init(title: CGSSFavoriteManager.defaultManager.contains(card.id!) ? "取消":"收藏", style: .Plain, target: self, action: #selector(addOrRemoveFavorite))
        let rightItem = UIBarButtonItem.init(image: CGSSFavoriteManager.defaultManager.containsCard(card.id!) ? UIImage.init(named: "748-heart-toolbar-selected") : UIImage.init(named: "748-heart-toolbar"), style: .plain, target: self, action: #selector(addOrRemoveFavorite))
        rightItem.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = rightItem
        
        // let leftItem = UIBarButtonItem.init(title: "返回", style: .Plain, target: self, action: #selector(backAction))
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = leftItem
        
        cardDV.initWith(card)
        sv.contentSize = cardDV.frame.size
        
    }
    
    // 添加当前卡到收藏
    func addOrRemoveFavorite() {
        let fm = CGSSFavoriteManager.defaultManager
        if !fm.containsCard(card.id!) {
            fm.addFavoriteCard(self.card)
            self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar-selected")
        } else {
            fm.removeFavoriteCard(self.card)
            self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar")
        }
        
    }
    func backAction() {
        _ = navigationController?.popViewController(animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    // 保存成功的回调方法
    func imageDidFinishingSaving(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        
        let alVC = UIAlertController(title: didFinishSavingWithError?.localizedFailureReason ?? NSLocalizedString("保存成功", comment: "弹出框标题"), message: nil, preferredStyle: .alert)
        alVC.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
        present(alVC, animated: true, completion: nil)
    }
    
    // 点击卡片小图标时的响应方法
    func iconClick(_ iv: CGSSCardIconView) {
        let dao = CGSSDAO.sharedDAO
        // 如果因为数据更新导致未查找到指定的卡片, 则不弹出新页面
        if let card = dao.findCardById(iv.cardId!) {
            let cardDetailVC = CardDetailViewController()
            cardDetailVC.card = card
            // cardDetailVC.modalTransitionStyle = .CoverVertical
            self.navigationController?.pushViewController(cardDetailVC, animated: true)
        }
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
    func beginRestore(_ iv: CGSSImageView) {
        self.cardDV?.addSubview(iv)
        self.view.sendSubview(toBack: fullScreenView!)
        iv.frame.origin.y = -64 + (self.sv.contentOffset.y)
        
        UIView.animate(withDuration: 0.25, animations: {
            UIApplication.shared.isStatusBarHidden = false
            iv.frame.origin.y = 0
            self.navigationController?.navigationBar.alpha = 1
            self.tabBarController?.tabBar.alpha = 1
            self.navigationController?.toolbar.alpha = 1
        }) 
        // self.navigationController?.setNavigationBarHidden(false, animated: true)
        // self.tabBarController?.tabBar.hidden = false
        
        // self.cardDV?.backgroundColor = UIColor.whiteColor()
    }
    func endRestore(_ iv: CGSSImageView) {
        
    }
    func beginFullSize(_ iv: CGSSImageView) {
        // 置于顶层 覆盖一切
        // UIApplication.sharedApplication().keyWindow?.addSubview((iv)!)
        self.fullScreenView?.bounds.origin.y = -64 + (self.sv.contentOffset.y)
        self.fullScreenView?.addSubview(iv)
        
        UIView.animate(withDuration: 0.25, animations: {
            UIApplication.shared.isStatusBarHidden = true
            self.navigationController?.navigationBar.alpha = 0
            self.navigationController?.toolbar.alpha = 0
            self.tabBarController?.tabBar.alpha = 0
            self.fullScreenView?.bounds.origin.y = 0
        }) 
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
        // self.tabBarController?.tabBar.hidden = true
        
        self.view.bringSubview(toFront: fullScreenView!)
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
    func endFullSize(_ iv: CGSSImageView) {
        
    }
    func longPress(_ press: UILongPressGestureRecognizer, iv: CGSSImageView) {
        // 长按实现更多操作 保存/分享等
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let location = press.location(in: fullScreenView)
        alert.popoverPresentationController?.sourceView = fullScreenView
        alert.popoverPresentationController?.sourceRect = CGRect(x: location.x, y: location.y, width: 0, height: 0)
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("保存到相册", comment: "底部弹出选项"), style: .default, handler: { (_: UIAlertAction) in
            if let image = iv.image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageDidFinishingSaving), nil)
            }
            }))
        // alVC.addAction(UIAlertAction.init(title: "分享", style: .Default, handler: { (_:UIAlertAction) in
        // //todo
        // }))
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "通用"), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
}

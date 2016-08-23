//
//  CardTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardTableViewController: BaseCardTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(NSHomeDirectory())
        // 作为工具启动的第一个页面 在此页面做自动更新检查
        let updater = CGSSUpdater.defaultUpdater
        // 如果数据Major版本号过低强制删除旧数据 再更新 没有取消按钮
        if updater.checkNewestDataVersion().0 > updater.checkCurrentDataVersion().0 {
            let dao = CGSSDAO.sharedDAO
            dao.removeAllData()
            let alert = UIAlertController.init(title: "数据需要更新", message: "数据主版本过低，请点击确定开始更新", preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: { (alertAction) in
                self.check(0b1111)
                }))
            self.tabBarController?.presentViewController(alert, animated: true, completion: nil)
        }
        // 如果数据Minor版本号过低 不管用户有没有设置自动更新 都提示更新 但是可以取消
        else if updater.checkNewestDataVersion().1 > updater.checkCurrentDataVersion().1 {
            let alert = UIAlertController.init(title: "数据需要更新", message: "数据存在新版本，推荐进行更新，请点击确定开始更新", preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: { (alertAction) in
                self.check(0b1111)
                }))
            alert.addAction(UIAlertAction.init(title: "取消", style: .Cancel, handler: nil))
            self.tabBarController?.presentViewController(alert, animated: true, completion: nil)
        }
        // 启动时根据用户设置检查常规更新
        else if NSUserDefaults.standardUserDefaults().valueForKey("DownloadAtStart") as? Bool ?? true {
            check(0b1111)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        let cardDetailVC = CardDetailViewController()
        cardDetailVC.card = cardList[indexPath.row]
        // 打开谱面时 隐藏tabbar
        cardDetailVC.hidesBottomBarWhenPushed = true
        
        // cardDetailVC.modalTransitionStyle = .CoverVertical
        self.navigationController?.pushViewController(cardDetailVC, animated: true)
        // 使用自定义动画效果
        // let transition = CATransition()
        // transition.duration = 0.3
        // transition.type = kCATransitionMoveIn
        // transition.subtype = kCATransitionFromRight
        // navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
        // navigationController?.pushViewController(cardDetailVC, animated: false)
        
    }
    
}


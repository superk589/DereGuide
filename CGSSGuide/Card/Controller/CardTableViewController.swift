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
        // print(Locale.current.identifier)
        // 作为工具启动的第一个页面 在此页面做自动更新检查
        let versionManager = CGSSVersionManager.default
        // 如果数据Major版本号过低强制删除旧数据 再更新 没有取消按钮
        if versionManager.newestDataVersion.0 > versionManager.currentDataVersion.0 {
            let dao = CGSSDAO.sharedDAO
            dao.removeAllData()
            let alert = UIAlertController.init(title: NSLocalizedString("数据需要更新", comment: "弹出框标题"), message: NSLocalizedString("数据主版本过低，请点击确定开始更新", comment: "弹出框正文"), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: { (alertAction) in
                self.check(.all)
                }))
            self.tabBarController?.present(alert, animated: true, completion: nil)
        }
        // 如果数据Minor版本号过低 不管用户有没有设置自动更新 都提示更新 但是可以取消
        else if versionManager.newestDataVersion.1 > versionManager.currentDataVersion.1 {
            let alert = UIAlertController.init(title: NSLocalizedString("数据需要更新", comment: "弹出框标题"), message: NSLocalizedString("数据存在新版本，推荐进行更新，请点击确定开始更新", comment: "弹出框正文"), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: { (alertAction) in
                self.check(.all)
                }))
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "弹出框按钮"), style: .cancel, handler: nil))
            self.tabBarController?.present(alert, animated: true, completion: nil)
        }
        // 启动时根据用户设置检查常规更新
        else if UserDefaults.standard.value(forKey: "DownloadAtStart") as? Bool ?? true {
            check(.all)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

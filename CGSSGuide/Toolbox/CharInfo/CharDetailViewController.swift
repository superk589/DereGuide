//
//  CharDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CharDetailViewController: UIViewController {
    var char: CGSSChar!
    var detailView: CharDetailView!
    var sv: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        sv = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: CGSSGlobal.width, height: CGSSGlobal.height -
                64))
        automaticallyAdjustsScrollViewInsets = false
        detailView = CharDetailView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        detailView.setup(char)
        detailView.delegate = self
        sv.contentSize = detailView.frame.size
        sv.addSubview(detailView)
        view.addSubview(sv)
        
        let rightItem = UIBarButtonItem.init(image: CGSSFavoriteManager.default.contains(charId: char.charaId) ? UIImage.init(named: "748-heart-toolbar-selected") : UIImage.init(named: "748-heart-toolbar"), style: .plain, target: self, action: #selector(addOrRemoveFavorite))
        rightItem.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = rightItem

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // 添加当前角色到收藏
    func addOrRemoveFavorite() {
        let fm = CGSSFavoriteManager.default
        if !fm.contains(charId: char.charaId) {
            fm.add(self.char)
            self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar-selected")
        } else {
            fm.remove(self.char)
            self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar")
        }
        
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

extension CharDetailViewController: CharDetailViewDelegate {
    func cardIconClick(_ icon: CGSSCardIconView) {
        let cardDetailVC = CardDetailViewController()
        let dao = CGSSDAO.sharedDAO
        cardDetailVC.card = dao.findCardById(icon.cardId!)
        // cardDetailVC.modalTransitionStyle = .CoverVertical
        self.navigationController?.pushViewController(cardDetailVC, animated: true)
    }
}

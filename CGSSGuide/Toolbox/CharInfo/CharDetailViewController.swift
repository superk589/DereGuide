//
//  CharDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CharDetailViewController: UIViewController {
    
    var char: CGSSChar!
    var detailView: CharDetailView!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
//        automaticallyAdjustsScrollViewInsets = false
        detailView = CharDetailView()
        scrollView.addSubview(detailView)
        detailView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        detailView.setup(char)
        detailView.delegate = self
        
        let rightItem = UIBarButtonItem.init(image: CGSSFavoriteManager.default.contains(charId: char.charaId) ? UIImage.init(named: "748-heart-toolbar-selected") : UIImage.init(named: "748-heart-toolbar"), style: .plain, target: self, action: #selector(addOrRemoveFavorite))
        rightItem.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = rightItem
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
}

extension CharDetailViewController: CharDetailViewDelegate {
    func cardIconClick(_ icon: CGSSCardIconView) {
        let cardDetailVC = CardDetailViewController()
        let dao = CGSSDAO.shared
        cardDetailVC.card = dao.findCardById(icon.cardId!)
        // cardDetailVC.modalTransitionStyle = .CoverVertical
        self.navigationController?.pushViewController(cardDetailVC, animated: true)
    }
}

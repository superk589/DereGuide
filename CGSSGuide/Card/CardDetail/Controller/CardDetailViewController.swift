//
//  CardDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CardDetailViewController: BaseTableViewController {
    
    var card: CGSSCard! {
        didSet {
            prepareRows()
            tableView?.reloadData()
            print("load card \(card.id!)")
        }
    }
    
    fileprivate struct Row: CustomStringConvertible {
        var type: UITableViewCell.Type
        var description: String {
            return type.description()
        }
    }
    
    fileprivate var rows: [Row] = []
    
    private func prepareRows() {
        rows.removeAll()
        guard let card = self.card else {
            return
        }
        if card.hasSpread {
            rows.append(Row(type: CardDetailSpreadImageCell.self))
        }
        rows.append(Row(type: CardDetailBasicCell.self))
        rows.append(Row(type: CardDetailAppealCell.self))
        rows.append(Row(type: CardDetailRelativeStrengthCell.self))
        if card.skill != nil {
            rows.append(Row(type: CardDetailSkillCell.self))
        }
        if card.leaderSkill != nil {
            rows.append(Row(type: CardDetailLeaderSkillCell.self))
        }
        
        rows.append(Row(type: CardDetailEvolutionCell.self))
        rows.append(Row(type: CardDetailRelatedCardsCell.self))
        
        if card.rarityType.rawValue >= CGSSRarityTypes.sr.rawValue {
            rows.append(Row(type: CardDetailSourceCell.self))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 自定义titleView的文字大小
        let titleView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        titleView.text = card.name
        titleView.font = UIFont.systemFont(ofSize: 12)
        titleView.textAlignment = .center
        titleView.adjustsFontSizeToFitWidth = true
        titleView.baselineAdjustment = .alignCenters
        navigationItem.titleView = titleView
        
        // let rightItem = UIBarButtonItem.init(title: CGSSFavoriteManager.defaultManager.contains(card.id!) ? "取消":"收藏", style: .Plain, target: self, action: #selector(addOrRemoveFavorite))
        let rightItem = UIBarButtonItem.init(image: CGSSFavoriteManager.default.contains(cardId: card.id!) ? UIImage.init(named: "748-heart-toolbar-selected") : UIImage.init(named: "748-heart-toolbar"), style: .plain, target: self, action: #selector(addOrRemoveFavorite))
        rightItem.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = rightItem
        
        // let leftItem = UIBarButtonItem.init(title: "返回", style: .Plain, target: self, action: #selector(backAction))
        let leftItem = UIBarButtonItem.init(image: UIImage.init(named: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = leftItem
        
        prepareToolbar()
        
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 68
        tableView.tableFooterView = UIView()
    }
    
    private func registerCells() {
        for row in rows {
            tableView
            .register(row.type, forCellReuseIdentifier: row.description)
        }
    }
    
    // 添加当前卡到收藏
    func addOrRemoveFavorite() {
        let manager = CGSSFavoriteManager.default
        if !manager.contains(cardId: card.id!) {
            manager.add(self.card)
            self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar-selected")
        } else {
            manager.remove(self.card)
            self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "748-heart-toolbar")
        }
    }
    
    @available(iOS 9.0, *)
    override var previewActionItems: [UIPreviewActionItem] {
        var titleString = ""
        if CGSSFavoriteManager.default.contains(cardId: card.id) {
            titleString = NSLocalizedString("取消收藏", comment: "")
        } else {
            titleString = NSLocalizedString("收藏", comment: "")
        }
        let item3 = UIPreviewAction.init(title: titleString, style: .default, handler: { (action, vc) in
            if let card = (vc as? CardDetailViewController)?.card {
                if CGSSFavoriteManager.default.contains(cardId: card.id) {
                    CGSSFavoriteManager.default.remove(card)
                } else {
                    CGSSFavoriteManager.default.add(card)
                }
            }
        })
        return [item3]
    }
    
    func prepareToolbar() {
//        let item1 = UIBarButtonItem.init(title: NSLocalizedString("3D模型", comment: ""), style: .plain, target: self, action: #selector(show3DModelAction))
//        let spaceItem1 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item2 = UIBarButtonItem.init(title: NSLocalizedString("卡片图", comment: ""), style: .plain, target: self, action: #selector(showCardImageAction))
        let spaceItem2 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item3 = UIBarButtonItem.init(title: NSLocalizedString("签名图", comment: ""), style: .plain, target: self, action: #selector(showSignImageAction))

        if card.signImageURL == nil {
            item3.isEnabled = false
        }
        toolbarItems = [item2, spaceItem2, item3]
        
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
    
    func show3DModelAction() {
        let vc = Card3DModelController()
        vc.card = self.card
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCardImageAction() {
        let vc = CardImageController()
        vc.card = self.card
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSignImageAction() {
        let vc = CardSignImageController()
        vc.card = self.card
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CardDetailViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.description, for: indexPath)
        (cell as? CardDetailSetable)?.setup(with: card)
        
//        (cell as? CardDetailBasicCell).delegate = self
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
}

extension CardDetailViewController: CardDetailViewDelegate {
    func seeCharInfo(cardDetailView: CardDetailView) {
        let charDetailVC = CharDetailViewController()
        charDetailVC.char = card.chara
        self.navigationController?.pushViewController(charDetailVC, animated: true)
    }
    func cardDetailView(_ cardDetailView: CardDetailView, didTapOn spreadImageView: SpreadImageView) {
        if let url = card.spreadImageURL {
            let vc = SpreadImageViewController()
            vc.imageURL = url
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension CardDetailViewController: CGSSIconViewDelegate {
    func iconClick(_ iv: CGSSIconView) {
        if let icon = iv as? CGSSCardIconView {
            let dao = CGSSDAO.shared
            // 如果因为数据更新导致未查找到指定的卡片, 则不弹出新页面
            if let card = dao.findCardById(icon.cardId!) {
                let cardDetailVC = CardDetailViewController()
                cardDetailVC.card = card
                // cardDetailVC.modalTransitionStyle = .CoverVertical
                self.navigationController?.pushViewController(cardDetailVC, animated: true)
            }
        }
    }
}

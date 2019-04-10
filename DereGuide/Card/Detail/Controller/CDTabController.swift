//
//  CDTabController.swift
//  DereGuide
//
//  Created by zzk on 2018/5/22.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class CDTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    static var defaultTabIndex = 0
    
    private var viewControllers: [UITableViewController]
    
    private var card: CGSSCard
    
    init(card: CGSSCard) {
        self.card = card
        let detailVC = CardDetailViewController()
        let imageVC = CDImageViewController()
        detailVC.card = card
        imageVC.prepareRows(for: card)
        
        viewControllers = [detailVC, imageVC]

        super.init(nibName: nil, bundle: nil)
        
        prepareNavigationBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareNavigationBar() {
        // 自定义titleView的文字大小
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        titleView.text = card.name
        titleView.font = UIFont.systemFont(ofSize: 12)
        titleView.textAlignment = .center
        titleView.adjustsFontSizeToFitWidth = true
        titleView.baselineAdjustment = .alignCenters
        navigationItem.titleView = titleView
        
        let rightItem = UIBarButtonItem(image: FavoriteCardsManager.shared.contains(card.id) ? #imageLiteral(resourceName: "748-heart-toolbar-selected") : #imageLiteral(resourceName: "748-heart-toolbar"), style: .plain, target: self, action: #selector(toggleFavorite(_:)))
        rightItem.tintColor = .red
        navigationItem.rightBarButtonItem = rightItem
        
        let leftItem = UIBarButtonItem(image: #imageLiteral(resourceName: "765-arrow-left-toolbar"), style: .plain, target: self, action: #selector(handleNavigationBackItem(_:)))
        
        navigationItem.leftBarButtonItem = leftItem
        
    }
    
    @objc private func toggleFavorite(_ item: UIBarButtonItem) {
        let manager = FavoriteCardsManager.shared
        if !manager.contains(card.id) {
            manager.add(card)
            navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "748-heart-toolbar-selected")
        } else {
            manager.remove(card.id)
            navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "748-heart-toolbar")
        }
    }
    
    @objc private func handleNavigationBackItem(_ item :UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private var items: [TMBarItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        items = [NSLocalizedString("属性", comment: ""),
                     NSLocalizedString("图片", comment: "")].map { TMBarItem(title: $0) }
        
        dataSource = self
        
        let bar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMBarIndicator.None>()
        let systemBar = bar.systemBar()
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        bar.layout.transitionStyle = .progressive
        addBar(systemBar, dataSource: self, at: .bottom)
        bar.buttons.customize { (button) in
            button.selectedTintColor = .parade
            button.tintColor = .lightGray
        }
        systemBar.backgroundStyle = .blur(style: .extraLight)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: CDTabViewController.defaultTabIndex)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index, direction: direction, animated: animated)
        CDTabViewController.defaultTabIndex = index
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
}

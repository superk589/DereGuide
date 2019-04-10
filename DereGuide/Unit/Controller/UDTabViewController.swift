//
//  UDTabViewController.swift
//  DereGuide
//
//  Created by zzk on 2018/6/23.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

protocol UnitDetailConfigurable: class {
    var unit: Unit { set get }
    var parentTabController: UDTabViewController? { set get }
}

class UDTabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    private var viewControllers: [UnitDetailConfigurable & UIViewController]
    
    private var observer: ManagedObjectObserver?
    
    var unit: Unit {
        didSet {
            observer = ManagedObjectObserver(object: unit, changeHandler: { [weak self] (type) in
                if type == .delete {
                    self?.navigationController?.popViewController(animated: true)
                } else if type == .update {
                    self?.setNeedsReloadUnit()
                    if self?.isShowing ?? false {
                        self?.reloadUnitIfNeeded()
                    }
                }
            })
            setNeedsReloadUnit()
            if self.isShowing {
                reloadUnitIfNeeded()
            }
        }
    }
    
    init(unit: Unit) {
        self.unit = unit
        viewControllers = [UnitSimulationController(unit: unit), UnitInformationController(unit: unit)]
        super.init(nibName: nil, bundle: nil)
        viewControllers.forEach { $0.parentTabController = self }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isShowing = false
    private var needsReloadUnit = false
    func setNeedsReloadUnit() {
        needsReloadUnit = true
    }
    
    func reloadUnitIfNeeded() {
        if needsReloadUnit {
            needsReloadUnit = false
            for vc in viewControllers {
                vc.unit = unit
            }
        }
    }
    
    private var items = [TMBarItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = [
            NSLocalizedString("得分计算", comment: ""),
            NSLocalizedString("队伍信息", comment: "")
        ].map { TMBarItem(title: $0) }
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShowing = true
        reloadUnitIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isShowing = false
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return items[index]
    }
}

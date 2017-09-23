//
//  UnitDetailController.swift
//  DereGuide
//
//  Created by zzk on 2017/5/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import CoreData
import ZKPageViewController

protocol UnitCollectionPage: class {
    var unit: Unit! { set get }
}

class UnitDetailController: ZKPageViewController, ZKPageViewControllerDelegate, ZKPageViewControllerDataSource {
    
    private var observer: ManagedObjectObserver?
    
    var unit: Unit! {
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
    
    var vcs: [UnitCollectionPage] = [UnitSimulationController(), UnitInfomationController()]
    
    func reloadUnitIfNeeded() {
        if needsReloadUnit {
            needsReloadUnit = false
            for vc in vcs {
                vc.unit = unit
            }
        }
    }
    
    var titleItems = [ZKPageTitleItem]()
    
    private func prepareTitleItems() {
        let item1 = ZKPageTitleItem()
        item1.normalColor = .darkGray
        item1.selectedColor = Color.vocal
        item1.label.text = NSLocalizedString("得分计算", comment: "")
        
        titleItems.append(item1)
        
        let item2 = ZKPageTitleItem()
        item2.normalColor = .darkGray
        item2.selectedColor = Color.cool
        item2.label.text = NSLocalizedString("队伍信息", comment: "")
        
        titleItems.append(item2)
    }
    
    private var isShowing = false
    private var needsReloadUnit = false
    func setNeedsReloadUnit() {
        needsReloadUnit = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTitleItems()
        
        self.dataSource = self
        self.delegate = self
        
        titleView.backgroundColor = UIColor.init(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        
        // Do any additional setup after loading the view.
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
    
    func pageViewController(_ pageViewController: ZKPageViewController, titleItemFor index: Int) -> ZKPageTitleItem {
        return titleItems[index]
    }
 
    func pageViewController(_ pageViewController: ZKPageViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = vcs[index] as! UIViewController
        return vc
    }
    
    func numberOfPages(_ pageViewController: ZKPageViewController) -> Int {
        return vcs.count
    }
    
    func pageViewController(_ pageViewController: ZKPageViewController, willShow viewController: UIViewController) {
        
    }

}

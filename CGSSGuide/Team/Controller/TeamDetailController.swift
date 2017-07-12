//
//  TeamDetailController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import CoreData

protocol TeamCollectionPage: PageCollectionControllerContainable {
    var unit: Unit! { set get }
}

class TeamDetailController: PageCollectionController, PageCollectionControllerDataSource, PageCollectionControllerDelegate {
    
    private var observer: ManagedObjectObserver?
    
    var unit: Unit! {
        didSet {
            observer = ManagedObjectObserver(object: unit, changeHandler: { [weak self] (type) in
                if type == .delete {
                    self?.navigationController?.popViewController(animated: true)
                } else if type == .update {
                    self?.setNeedsReloadTeam()
                    if self?.isShowing ?? false {
                        self?.reloadTeamIfNeeded()
                    }
                }
            })
            setNeedsReloadTeam()
            if self.isShowing {
                reloadTeamIfNeeded()
            }
        }
    }
    
    var vcs: [TeamCollectionPage] = [TeamSimulationController(), TeamInfomationController()]
    
    var titles = [NSLocalizedString("得分计算", comment: ""),
                  NSLocalizedString("队伍信息", comment: "")]
    
    func reloadTeamIfNeeded() {
        if needsReloadTeam {
            needsReloadTeam = false
            for vc in vcs {
                vc.unit = unit
            }
        }
    }
    
    private var isShowing = false
    private var needsReloadTeam = false
    func setNeedsReloadTeam() {
        needsReloadTeam = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        titleView.backgroundColor = UIColor.init(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShowing = true
        reloadTeamIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isShowing = false
    }
    
    func pageCollectionController(_ pageCollectionController: PageCollectionController, viewControllerAt indexPath: IndexPath) -> UIViewController {
        let vc = vcs[indexPath.item] as! UIViewController
        return vc
    }
    
    func titlesOfPages(_ pageCollectionController: PageCollectionController) -> [String] {
        return titles
    }
    
    func numberOfPages(_ pageCollectionController: PageCollectionController) -> Int {
        return titles.count
    }

    func pageCollectionController(pageCollectionController: PageCollectionController, willShow viewController: UIViewController) {
//        viewController.viewWillAppear(false)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

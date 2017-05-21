//
//  TeamDetailController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol TeamCollectionPage: PageCollectionControllerContainable {
    var team: CGSSTeam! { set get }
}

class TeamDetailController: PageCollectionController, PageCollectionControllerDataSource, PageCollectionControllerDelegate {
    
    var team: CGSSTeam! {
        didSet {
            for vc in vcs {
                vc.team = team
            }
        }
    }
    
    var vcs: [TeamCollectionPage] = [TeamSimulationController(), TeamInfomationController()]
    
    var titles = [NSLocalizedString("得分计算", comment: ""),
                  NSLocalizedString("队伍信息", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        titleView.backgroundColor = UIColor.init(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        // Do any additional setup after loading the view.
    }

    func pageCollectionController(_ pageCollectionController: PageCollectionController, viewControllerAt indexPath: IndexPath) -> UIViewController {
        let vc = vcs[indexPath.item]
        vc.team = self.team
        return vcs[indexPath.item] as! UIViewController
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

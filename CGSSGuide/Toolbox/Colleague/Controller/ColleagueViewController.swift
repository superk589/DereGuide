//
//  ColleagueViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class ColleagueViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
    }
    
    var context: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    private func prepareNavigationBar() {
        let item = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeAction))
        navigationItem.rightBarButtonItem = item
        navigationItem.title = NSLocalizedString("寻找同僚", comment: "")
    }
    
    @objc func composeAction() {
        let vc = ColleagueComposeViewController()
        let profile = Profile.findOrCreate(in: context, configure: { _ in })
        vc.profile = profile
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func filterAction() {
        
    }
    
}

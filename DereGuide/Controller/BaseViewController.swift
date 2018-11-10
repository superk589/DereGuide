//
//  BaseViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/1/4.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

extension UIViewController {
    
    var drawerController: ZKDrawerController? {
        var vc = parent
        while vc != nil {
            if vc is ZKDrawerController {
                return vc as? ZKDrawerController
            } else {
                vc = vc?.parent
            }
        }
        return nil
    }
}

class BaseViewController: UIViewController {

    override var shouldAutorotate: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .pad ? .all : .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

}

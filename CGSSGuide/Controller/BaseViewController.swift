//
//  BaseViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/4.
//  Copyright © 2017年 zzk. All rights reserved.
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

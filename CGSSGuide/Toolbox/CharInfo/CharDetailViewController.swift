//
//  CharDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CharDetailViewController: UIViewController {
    var char: CGSSChar!
    var detailView: CharDetailView!
    var sv: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        sv = UIScrollView.init(frame: CGRectMake(0, 64, CGSSGlobal.width, CGSSGlobal.height -
                64))
        automaticallyAdjustsScrollViewInsets = false
        detailView = CharDetailView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 0))
        detailView.setup(char)
        sv.contentSize = detailView.frame.size
        sv.addSubview(detailView)
        view.addSubview(sv)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

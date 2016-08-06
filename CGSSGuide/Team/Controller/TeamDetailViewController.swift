//
//  TeamDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CMPopTipView

class TeamDetailViewController: UIViewController {

    var selfLeaderLabel: CMPopTipView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        selfLeaderLabel = CMPopTipView.init(message: "sdsdsd")
        selfLeaderLabel.frame = CGRectMake(0, 0, 300, 300)
        let button = UIButton.init(frame: CGRectMake(20, 300, 400, 100))
        button.setTitle("adadadasd", forState: .Normal)
        selfLeaderLabel.presentPointingAtView(button, inView: view, animated: true)
        selfLeaderLabel.has3DStyle = false
        selfLeaderLabel.borderColor = UIColor.grayColor()
        selfLeaderLabel.hasGradientBackground = false
        selfLeaderLabel.backgroundColor = UIColor.grayColor()
        view.addSubview(selfLeaderLabel)
        
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

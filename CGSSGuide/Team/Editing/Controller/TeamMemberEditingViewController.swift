//
//  TeamMemberEditingViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/18.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamMemberEditingViewController: UIViewController {

    var editView: TeamMemberEditingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setup(model:CGSSTeamMember, type:CGSSTeamMemberType) {
        if editView == nil {
            editView = TeamMemberEditingView.init(frame: CGRect.init(x: 0, y: 0, width: 240, height: 290))
        }
        self.view.addSubview(editView)
        editView.setupWith(model: model, type: type)
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

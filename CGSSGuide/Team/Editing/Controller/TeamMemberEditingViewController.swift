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

    func setup(model:CGSSTeamMember, type: CGSSTeamMemberType) {
        if editView == nil {
            editView = TeamMemberEditingView.init(frame: CGRect.init(x: 0, y: 0, width: 240, height: 290))
        }
        view.addSubview(editView)
        editView.setupWith(model: model, type: type)
    }

}

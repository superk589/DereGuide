//
//  TeamMemberEditingViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/18.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class TeamMemberEditingViewController: UIViewController {

    var editView: TeamMemberEditingView!

    func setupWith(member: Member, card: CGSSCard) {
        if editView == nil {
            editView = TeamMemberEditingView()
            view.addSubview(editView)
            editView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        editView.setupWith(member: member, card: card)
    }

}

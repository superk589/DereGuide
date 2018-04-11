//
//  MemberEditingViewController.swift
//  DereGuide
//
//  Created by zzk on 2016/9/18.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import SnapKit

class MemberEditingViewController: UIViewController {

    var editView: MemberEditingView!

    func setupWith(member: Member, card: CGSSCard) {
        if editView == nil {
            editView = MemberEditingView()
            view.addSubview(editView)
            editView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        editView.setupWith(member: member, card: card)
    }

}

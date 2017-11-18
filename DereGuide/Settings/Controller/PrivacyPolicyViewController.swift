//
//  PrivacyPolicyViewController.swift
//  DereGuide
//
//  Created by zzk on 18/11/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentOffset = .zero
    }
}

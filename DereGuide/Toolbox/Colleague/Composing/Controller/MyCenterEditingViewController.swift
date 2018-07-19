//
//  MyCenterEditingViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/8/3.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol MyCenterEditingViewControllerDelegate: class {
    func didDelete(myCenterEditingViewController: MyCenterEditingViewController)
}

class MyCenterEditingViewController: UIViewController {

    var editingView: MyCenterEditingView!
    
    weak var delegate: MyCenterEditingViewControllerDelegate?
    
    var potential: Potential {
        return editingView.potential
    }
    
    func setupWith(card: CGSSCard, potential: Potential = .zero) {
        if editingView == nil {
            editingView = MyCenterEditingView()
            view.addSubview(editingView)
            editingView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            editingView.delegate = self
        }
        
        editingView.setupWith(potential: potential, card: card)
    }
    
}

extension MyCenterEditingViewController: MyCenterEditingViewDelegate {
    
    func didDelete(myCenterEditingView: MyCenterEditingView) {
        dismiss(animated: true, completion: nil)
        delegate?.didDelete(myCenterEditingViewController: self)
    }
    
}
